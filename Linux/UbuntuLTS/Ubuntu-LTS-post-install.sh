#!/bin/bash
HIGHLIGHT='\033[1;32m'
NC='\033[0m'

function promptPassphrase {
	PASS=""
	PASSCONF=""
	while [ -z "$PASS" ]; do
		read -s -p "Passphrase: " PASS
		echo ""
	done
	
	while [ -z "$PASSCONF" ]; do
		read -s -p "Confirm passphrase: " PASSCONF
		echo ""
	done
	echo ""
}

function getPassphrase {
	promptPassphrase
	while [ "$PASS" != "$PASSCONF" ]; do
		echo "Passphrases did not match, try again..."
		promptPassphrase
	done
}

if [[ $UID -ne 0 ]]; then
 echo "This script needs to be run as root (with sudo)."
 exit 1
fi

# Get the admin user.
users=($(ls /home))
echo "Existing users:"
echo
for index in ${!users[*]}
do
	echo -e "\t[$index]: " ${users[$index]}
done
echo

while [ -z "$SELECTION" ]; do read -p "Please select the user you created during the Ubuntu installation: " SELECTION; done
ADMINUSER=${users[$SELECTION]}
if [ -z "$ADMINUSER" ]; then
	echo "Invalid user selected. Please run the script again."
	exit
fi

# Get the username for the primary user.
echo
echo "Please enter a username for the primary device user that will be created by this script."
while [ -z "$ENDUSER" ]; do read -p "Username for primary device user: " ENDUSER; done
if [ -d "/home/$ENDUSER" ]; then
	if [ "$ENDUSER" == "$ADMINUSER" ]; then
		echo "Primary user cannot be the same as the admin user."
		exit
	fi

	read -p "The username you entered already exists. Do you want to continue? [y/n]: " CONFIRM
	if [ "$CONFIRM" != "y" ]; then
		exit
	fi
fi

echo "If you are not using the default internet repositories you should configure this before running this script."
echo "You should also have an active network connection to the repositories."
read -p "Continue? [y/n]: " CONFIRM
if [ "$CONFIRM" != "y" ]; then
 exit
fi

echo -e "${HIGHLIGHT}Running system updates...${NC}"
# Update.
apt-get update
# Upgrade.
apt-get dist-upgrade -y
# Remove packages.
apt-get remove -y popularity-contest
# And install required packages.
apt-get install -y apparmor-profiles apparmor-utils auditd 

# Configuring mount and grub. We need to make sure the script is running for the first time.
echo -e "${HIGHLIGHT}Configuring fstab...${NC}"
read -p "Is this the first time you run the post-install script? [y/n]: " CONFIRM
if [ "$CONFIRM" == "y" ]; then
	# Update fstab.
	echo -e "${HIGHLIGHT}Writing fstab config...${NC}"
	sed -ie '/\s\/home\s/ s/defaults/defaults,noexec,nosuid,nodev/' /etc/fstab
	EXISTS=$(grep "/tmp/" /etc/fstab)
	if [ -z "$EXISTS" ]; then
		echo "none /tmp tmpfs rw,noexec,nosuid,nodev 0 0" >> /etc/fstab
	else
		sed -ie '/\s\/tmp\s/ s/defaults/defaults,noexec,nosuid,nodev/' /etc/fstab
	fi
	echo "none /run/shm tmpfs rw,noexec,nosuid,nodev 0 0" >> /etc/fstab
	# Bind /var/tmp to /tmp to apply the same mount options during system boot
 	echo "/tmp /var/tmp none bind 0 0" >> /etc/fstab
	# Temporarily make the /tmp directory executable before running apt-get and remove execution flag afterwards. This is because
	# sometimes apt writes files into /tmp and executes them from there.
	echo -e "DPkg::Pre-Invoke{\"mount -o remount,exec /tmp\";};\nDPkg::Post-Invoke {\"mount -o remount /tmp\";};" >> /etc/apt/apt.conf.d/99tmpexec
	chmod 644 /etc/apt/apt.conf.d/99tmpexec
fi

# Set grub password.
echo -e "${HIGHLIGHT}Configuring grub...${NC}"
echo "Please enter a grub sysadmin passphrase..."
getPassphrase

echo "set superusers=\"sysadmin\"" >> /etc/grub.d/40_custom
echo -e "$PASS\n$PASS" | grub-mkpasswd-pbkdf2 | tail -n1 | awk -F" " '{print "password_pbkdf2 sysadmin " $7}' >> /etc/grub.d/40_custom
sed -ie '/echo "menuentry / s/echo "menuentry /echo "menuentry --unrestricted /' /etc/grub.d/10_linux
sed -ie '/^GRUB_CMDLINE_LINUX_DEFAULT=/ s/"$/ module.sig_enforce=yes"/' /etc/default/grub
echo "GRUB_SAVEDEFAULT=false" >> /etc/default/grub
update-grub

# Set permissions for admin user's home directory.
chmod 700 "/home/$ADMINUSER"

# Configure automatic updates.
echo -e "${HIGHLIGHT}Configuring automatic updates...${NC}"
EXISTS=$(grep "APT::Periodic::Update-Package-Lists" /etc/apt/apt.conf.d/20auto-upgrades)
if [ -z "$EXISTS" ]; then
	sed -i '/APT::Periodic::Update-Package-Lists/d' /etc/apt/apt.conf.d/20auto-upgrades
	echo "APT::Periodic::Update-Package-Lists \"1\";" >> /etc/apt/apt.conf.d/20auto-upgrades
fi

EXISTS=$(grep "APT::Periodic::Unattended-Upgrade" /etc/apt/apt.conf.d/20auto-upgrades)
if [ -z "$EXISTS" ]; then
	sed -i '/APT::Periodic::Unattended-Upgrade/d' /etc/apt/apt.conf.d/20auto-upgrades
	echo "APT::Periodic::Unattended-Upgrade \"1\";" >> /etc/apt/apt.conf.d/20auto-upgrades
fi

EXISTS=$(grep "APT::Periodic::AutocleanInterval" /etc/apt/apt.conf.d/10periodic)
if [ -z "$EXISTS" ]; then
	sed -i '/APT::Periodic::AutocleanInterval/d' /etc/apt/apt.conf.d/10periodic
	echo "APT::Periodic::AutocleanInterval \"7\";" >> /etc/apt/apt.conf.d/10periodic
fi

chmod 644 /etc/apt/apt.conf.d/20auto-upgrades
chmod 644 /etc/apt/apt.conf.d/10periodic

# Prevent standard user executing su.
echo -e "${HIGHLIGHT}Configure su execution...${NC}"
dpkg-statoverride --update --add root adm 4750 /bin/su

# Protect user home directories.
echo -e "${HIGHLIGHT}Configuring home directories and shell access...${NC}"
sed -ie '/^DIR_MODE=/ s/=[0-9]*\+/=0700/' /etc/adduser.conf
sed -ie '/^UMASK\s\+/ s/022/077/' /etc/login.defs

read -p "User shell configuration:
[0] Set shell to /bin/passwd (allows password changes, bypassing Gnome bug) (default)
[1] Set shell to /sbin/nologin (prevents shell access)
[2] Set shell to /bin/bash (allows bash shell access)
" LEVEL
	if [ "$LEVEL" == "1" ]; then
		# Disable shell access for new users (not affecting the existing admin user).
		sed -ie '/^SHELL=/ s/=.*\+/=\/usr\/sbin\/nologin/' /etc/default/useradd
		sed -ie '/^DSHELL=/ s/=.*\+/=\/usr\/sbin\/nologin/' /etc/adduser.conf
	elif [ "$LEVEL" == "2" ]; then
		# Keep shell access for new users (not affecting the existing admin user).
		sed -ie '/^SHELL=/ s/=.*\+/=\/bin\/bash/' /etc/default/useradd
		sed -ie '/^DSHELL=/ s/=.*\+/=\/bin\/bash/' /etc/adduser.conf	
	else
		# Keep shell access for new users to prevent Gnome bug re. passwords (not affecting the existing admin user). Default option.
		sed -ie '/^SHELL=/ s/=.*\+/=\/bin\/passwd/' /etc/default/useradd
		sed -ie '/^DSHELL=/ s/=.*\+/=\/bin\/passwd/' /etc/adduser.conf		
	fi

# Installing libpam-pwquality 
echo -e "${HIGHLIGHT}Configuring minimum password requirements...${NC}"
apt-get install -f libpam-pwquality

# Create the standard user.
adduser "$ENDUSER"

# Set some AppArmor profiles to enforce mode.
echo -e "${HIGHLIGHT}Configuring apparmor...${NC}"
aa-enforce /etc/apparmor.d/usr.bin.firefox
aa-enforce /etc/apparmor.d/usr.sbin.avahi-daemon
aa-enforce /etc/apparmor.d/usr.sbin.dnsmasq
aa-enforce /etc/apparmor.d/bin.ping
aa-enforce /etc/apparmor.d/usr.sbin.rsyslogd

# Setup auditing.
echo -e "${HIGHLIGHT}Configuring system auditing...${NC}"
if [ ! -f /etc/audit/rules.d/tmp-monitor.rules ]; then
echo "# Monitor changes and executions within /tmp
-w /tmp/ -p wa -k tmp_write
-w /tmp/ -p x -k tmp_exec" > /etc/audit/rules.d/tmp-monitor.rules
fi

if [ ! -f /etc/audit/rules.d/admin-home-watch.rules ]; then
echo "# Monitor administrator access to /home directories
-a always,exit -F dir=/home/ -F uid=0 -C auid!=obj_uid -k admin_home_user" > /etc/audit/rules.d/admin-home-watch.rules
fi
augenrules
systemctl restart auditd.service

# Configure the settings for the "Welcome" popup box on first login.
echo -e "${HIGHLIGHT}Configuring user first login settings...${NC}"
mkdir -p "/home/$ENDUSER/.config"
echo yes > "/home/$ENDUSER/.config/gnome-initial-setup-done"
chown -R "$ENDUSER:$ENDUSER" "/home/$ENDUSER/.config"
sudo -H -u "$ENDUSER" ubuntu-report -f send no

# Disable error reporting services
echo -e "${HIGHLIGHT}Configuring error reporting...${NC}"
systemctl stop apport.service
systemctl disable apport.service
systemctl mask apport.service

systemctl stop whoopsie.service
systemctl disable whoopsie.service
systemctl mask whoopsie.service

if [ ! -f "/etc/dconf/profile/user" ]; then
	touch /etc/dconf/profile/user
fi

EXISTS=$(grep "user-db:user" /etc/dconf/profile/user)
if [ -z "$EXISTS" ]; then
	echo "user-db:user" >> /etc/dconf/profile/user
fi

EXISTS=$(grep "system-db:local" /etc/dconf/profile/user)
if [ -z "$EXISTS" ]; then
	echo "system-db:local" >> /etc/dconf/profile/user
fi

# Optionally disable bluetooth
read -p "Do you want to disable bluetooth for all users? [y/n]: " CONFIRM
if [ "$CONFIRM" == "y" ]; then
systemctl disable bluetooth.service
fi

# Lockdown Gnome screensaver lock settings
echo -e "${HIGHLIGHT}Configuring Gnome screensaver lock settings...${NC}"
mkdir -p /etc/dconf/db/local.d/locks
echo "[org/gnome/login-screen]
disable-user-list=true

[org/gnome/desktop/session]
idle-delay=600

[org/gnome/desktop/screensaver]
lock-enabled=true
lock-delay=0
ubuntu-lock-on-suspend=true" > /etc/dconf/db/local.d/00_custom-lock

echo "/org/gnome/desktop/session/idle-delay
/org/gnome/desktop/screensaver/lock-enabled
/org/gnome/desktop/screensaver/lock-delay
/org/gnome/desktop/screensaver/ubuntu-lock-on-suspend
/org/gnome/login-screen/disable-user-list" > /etc/dconf/db/local.d/locks/00_custom-lock

# Remove user list from login page
sed -ie '/^\# disable-user-list\=true/ s/#//' /etc/gdm3/greeter.dconf-defaults

read -p "Do you want to disable lockscreen notifications? [y/n]: " CONFIRM
if [ "$CONFIRM" == "y" ]; then
echo "
[org/gnome/desktop/notifications]
show-in-lock-screen=false

[org/gnome/login-screen]
banner-message-enable=false" >> /etc/dconf/db/local.d/00_custom-lock

echo "/org/gnome/desktop/notifications/show-in-lock-screen
/org/gnome/login-screen/banner-message-enable" >> /etc/dconf/db/local.d/locks/00_custom-lock

fi

# Optionally Disable Location Services
read -p "Do you want to disable location services? [y/n]: " CONFIRM
if [ "$CONFIRM" == "y" ]; then
echo "
[org/gnome/system/location]
max-accuracy-level='country'
enabled=false" >> /etc/dconf/db/local.d/00_custom-lock

echo "/org/gnome/system/location/max-accuracy-level
/org/gnome/system/location/enabled" >> /etc/dconf/db/local.d/locks/00_custom-lock
fi

# Further Privacy Setting
echo "
[org/gnome/desktop/privacy]
report-technical-problems=false" >> /etc/dconf/db/local.d/00_custom-lock
echo "/org/gnome/desktop/privacy/report-technical-problems" >> /etc/dconf/db/local.d/locks/00_custom-lock

# Optionally Set USB Restrictions (located within org/gnome/desktop/privacy)
read -p "Do you want to restrict USB usage? [y/n]: " CONFIRM
if [ "$CONFIRM" == "y" ]; then
echo "usb-protection=true" >> /etc/dconf/db/local.d/00_custom-lock
read -p "Set the restriction level:
[0] block USB on lockscreen (default)
[1] always block USB
" LEVEL
	if [ "$LEVEL" == "1" ]; then
		echo "Setting USB lockdown mode to: always"
		echo "usb-protection-level='always'" >> /etc/dconf/db/local.d/00_custom-lock
		echo "/org/gnome/desktop/privacy/usb-protection-level" >> /etc/dconf/db/local.d/locks/00_custom-lock
		if [ ! -f "/etc/modprobe.d/blacklist.conf" ]; then
			touch /etc/modprobe.d/blacklist.conf
		fi
		if [ ! -f "/etc/rc.local" ]; then
			touch /etc/rc.local
			echo "#!/bin/bash" >> /etc/rc.local
		fi
		echo "blacklist usb_storage
blacklist uas" >> /etc/modprobe.d/blacklist.conf
		echo "modprobe -r uas
modprobe -r usb_storage" >> /etc/rc.local
		rmmod usb_storage
	else
		echo "Setting USB lockdown mode to: lockscreen"
		echo "usb-protection-level='lockscreen'" >> /etc/dconf/db/local.d/00_custom-lock
		echo "/org/gnome/desktop/privacy/usb-protection-level" >> /etc/dconf/db/local.d/locks/00_custom-lock
	fi
fi

dconf update

# Fix dconf permissions, otherwise option locks don't apply upon subsequent script executions
chmod 644 -R /etc/dconf/db/
chmod a+x /etc/dconf/db/local.d/locks
chmod a+x /etc/dconf/db/local.d
chmod a+x /etc/dconf/db

# Disable apport (error reporting)
sed -ie '/^enabled=1$/ s/1/0/' /etc/default/apport

sudo -H -u "$ENDUSER" dbus-launch gsettings set com.ubuntu.update-notifier show-apport-crashes false

# Fix some permissions in /var that are writable and executable by the standard user.
echo -e "${HIGHLIGHT}Configuring additional directory permissions...${NC}"
chmod o-w /var/crash
chmod o-w /var/metrics
chmod o-w /var/tmp

# Setting up firewall without any rules.
echo -e "${HIGHLIGHT}Configuring firewall…  ${NC}"
ufw enable	


echo -e "${HIGHLIGHT}Installation complete.${NC}"

read -p "Reboot now? [y/n]: " CONFIRM
if [ "$CONFIRM" == "y" ]; then
	reboot
fi
