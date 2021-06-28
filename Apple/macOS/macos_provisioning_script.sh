#!/bin/bash

# This script demonstrates a number of security-related settings
# that you might want to configure on your organisation's devices.
# We recommend that you develop your own provisioning process 
# which might include some of the commands in this file, or might
# use an entirely different mechanism for enforcement (e.g. MDM).
# 
# (C) Crown Copyright 2019


function get_user_pass {
 local MATCH=false
 while [ $MATCH == false ] ; do
 read -s -p "Password: " PASS_1
 echo ""
 read -s -p "Repeat Password: " PASS_2
 echo ""
 if [ $PASS_1 == $PASS_2 ] ; then
 PASS="$PASS_1"
 MATCH=true
 fi
 done
 return
}

function get_encryption_pass {
 local MATCH=false
 while [ $MATCH == false ] ; do
 read -s -p "Passphrase: " PASS_1
 echo ""
 read -s -p "Repeat: " PASS_2
 echo ""
 if [ "$PASS_1" == "$PASS_2" ]; then
 DISKPASS="$PASS_1"
 MATCH=true
 fi
 done
 return
}

if [[ $UID -ne 0 ]]; then
 echo "This script needs to be run as root (with sudo)"
 exit 1
fi

DEBUG=false
if [[ "$1" == "--debug" ]]; then
  DEBUG=true
fi

echo "[I] Determining macOS version"
VERSION=$(system_profiler SPSoftwareDataType | grep macOS | awk {'print $4'} | cut -d. -f2)
if [ -n "$VERSION" ]; then
  if [ "${VERSION:-0}" -ge 13 ]; then
    if $DEBUG; then
      echo "[I] You are running macOS 10.$VERSION, proceeding with provisioning"
    fi
  elif [ "$VERSION" == "12" ]; then
    echo "[I] Error, this script is only for macOS 10.13 (High Sierra) and above. You are running macOS 10.12 (Sierra), please run the following provisioning script: https://www.ncsc.gov.uk/guidance/macos-1012-provisioning-script"
    exit 1
  else
    echo "[I] Error, this script is only for macOS 10.13 (High Sierra) and above."
    exit 1
  fi
else
  echo "[I] Error, couldn't determine macOS version!"
  exit 1
fi


echo "[I] Beginning local provisioning now"
read -p "[!] Enter a name for this device: " DEVNAME
systemsetup -setcomputername "$DEVNAME"
scutil --set HostName "$DEVNAME"
echo "[I] Creating a standard user account"
CONFIRM="n"
while [ "$CONFIRM" != "y" ] ; do
 echo "[!] Enter username to create (e.g. jsmith):"
 read -p "Username: " USERNAME
 echo "[!] Enter user's full name (e.g. John Smith):"
 read -p "Real Name: " REALNAME
 echo "[!] Please provide a password for this account"
 get_user_pass
 echo "[!] Please provide a FileVault disk encryption passphrase"
 echo "[ ] This could include a second-factor password entry token component"
 get_encryption_pass
 echo " "
 echo "[?] Are the following details correct?"
 echo " Username: $USERNAME"
 echo " Real Name: $REALNAME"
 read -p "[y/n]: " CONFIRM
done


echo "[I] Turning off iCloud login prompt"
defaults write /System/Library/User\ Template/English.lproj/Library/Preferences/com.apple.SetupAssistant DidSeeCloudSetup -bool TRUE
defaults write /System/Library/User\ Template/English.lproj/Library/Preferences/com.apple.SetupAssistant GestureMovieSeen none
defaults write /System/Library/User\ Template/English.lproj/Library/Preferences/com.apple.SetupAssistant LastSeenCloudProductVersion "10.12"


echo "[I] Creating user $USERNAME"
if [ $VERSION -ge "14" ]; then
  echo "[ ] Click 'OK' to allow Terminal to make system changes"
fi

if $DEBUG; then
  sysadminctl -addUser "$USERNAME" -fullName "$REALNAME" -password "$PASS"
else
  sysadminctl -addUser "$USERNAME" -fullName "$REALNAME" -password "$PASS" &>/dev/null
fi


echo "[I] Locking down Terminal/Shell access"
mkdir /Users/"$USERNAME"/Bash
echo "set -r" > /Users/"$USERNAME"/.bash_profile
echo "unset PATH" >> /Users/"$USERNAME"/.bash_profile
echo "export PATH=/Users/"$USERNAME"/Bash" >> /Users/"$USERNAME"/.bash_profile
ln -s /usr/bin/clear /Users/"$USERNAME"/Bash
ln -s /bin/df /Users/"$USERNAME"/Bash
ln -s /usr/bin/egrep /Users/"$USERNAME"/Bash
ln -s /usr/bin/env /Users/"$USERNAME"/Bash
ln -s /usr/bin/fgrep /Users/"$USERNAME"/Bash
ln -s /usr/bin/rview /Users/"$USERNAME"/Bash
ln -s /usr/bin/rvim /Users/"$USERNAME"/Bash
ln -s /usr/bin/sudo /Users/"$USERNAME"/Bash
ln -s /usr/bin/tail /Users/"$USERNAME"/Bash
ln -s /usr/bin/wc /Users/"$USERNAME"/Library/Bash


echo "[I] Enabling FileVault2 full disk encryption"
if $DEBUG; then
  sysadminctl -addUser filevault -fullName "Disk Encryption Password" -shell /usr/bin/false
else
  sysadminctl -addUser filevault -fullName "Disk Encryption Password" -shell /usr/bin/false &>/dev/null
fi
sysadminctl -resetPasswordFor filevault -newPassword "$DISKPASS" -adminUser "$SUDO_USER" -adminPassword - &>/dev/null
while [ $(fdesetup isactive) == "false" ]; do
  fdesetup enable -user filevault
done
defaults write com.apple.loginwindow HiddenUsersList -array-add filevault
defaults write /Library/Preferences/com.apple.loginwindow SHOWFULLNAME -int 1
pmset destroyfvkeyonstandby 1 hibernatemode 25

if $DEBUG; then
  echo "[!] SecureToken status on account 'filevault'"
  sysadminctl -secureTokenStatus filevault
  echo "[!] fdesetup list"
  fdesetup list
fi


echo "[I] Disabling IPv6"
networksetup -setv6off Wi-Fi >/dev/null
networksetup -setv6off Ethernet >/dev/null
echo "[I] Disabling infrared receiver"
defaults write com.apple.driver.AppleIRController DeviceEnabled -bool FALSE
echo "[I] Disabling Bluetooth"
defaults write /Library/Preferences/com.apple.Bluetooth ControllerPowerState -int 0
echo "[I] Turning off WiFi"
networksetup -setairportpower airport off > /dev/null
echo "[I] Enabling scheduled updates"
softwareupdate --schedule on
defaults write /Library/Preferences/com.apple.SoftwareUpdate.plist AutomaticCheckEnabled -bool true
defaults write /Library/Preferences/com.apple.SoftwareUpdate.plist AutomaticDownload -bool true
defaults write /Library/Preferences/com.apple.commerce.plist AutoUpdateRestartRequired -bool true
defaults write /Library/Preferences/com.apple.commerce.plist AutoUpdate -bool true
echo "[I] Disabling password hints on lock screen"
defaults write com.apple.loginwindow RetriesUntilHint -int 0
echo "[I] Enabling password-protected screen lock after 5 minutes"
systemsetup -setdisplaysleep 5
defaults write com.apple.screensaver askForPassword -int 1
defaults write com.apple.screensaver askForPasswordDelay -int 0
echo "[I] Enabling firewall"
/usr/libexec/ApplicationFirewall/socketfilterfw --setloggingmode on
/usr/libexec/ApplicationFirewall/socketfilterfw --setallowsigned on
/usr/libexec/ApplicationFirewall/socketfilterfw --setglobalstate on
echo "[I] Launching firmware password utility (this may take a moment)"
diskutil mount Recovery
ID_RECOVERY=$(ls -alh /Volumes/Recovery | tail -n1 | cut -d " " -f 13)
RECOVERY=$(hdiutil attach /Volumes/Recovery/"$ID_RECOVERY"/BaseSystem.dmg | grep -i Base | cut -f 3)
open "$RECOVERY/Applications/Utilities/Startup Security Utility.app"
echo "[!] Follow the prompts on the utility to set a strong unique firmware password"
echo "[!] Provisioning complete. Press enter when done"
read DONE


