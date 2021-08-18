#!/bin/bash

# This script demonstrates a number of security-related settings
# that you might want to configure on your organisation's devices.
# We recommend that you develop your own provisioning process 
# which might include some of the commands in this file, or might
# use an entirely different mechanism for enforcement (e.g. MDM).
# 
# (C) Crown Copyright 2021


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

#NEW: Determines if FileVault is enabled or not (returns string)
function get_filevault_status {
  FV_STATUS=$(fdesetup isactive)
  case $FV_STATUS in
    "true")
      echo "enabled"
    ;;
    "false")
      echo "disabled"
    ;;
    *)
      echo "[!] Could not determine FileVault status! Exiting"
      exit 1
    ;;
  esac
}

#NEW: Determines if System Integrity Protection is enabled or not (returns string). Compatible with macOS 10.15 and later only
function get_sip_status {
  SIP_STATUS=$(csrutil status | sed 's/.$//' | awk '{print $NF}' )
  case "$SIP_STATUS" in
    "enabled")
      echo "enabled"
    ;;
    "disabled.")
      echo "disabled"
    ;;
    *)
      echo "[!] Could not determine System Integrity Protection status! Exiting"
      exit 1
    ;;
  esac
}

#NEW: Determines if Signed System Volume is enabled or not (returns string). Compatible with macOS 11 only
function get_ssv_status {
  SSV_STATUS=$(csrutil authenticated-root status | awk '{print $NF}' )
  case "$SSV_STATUS" in
    "enabled")
      echo "enabled"
    ;;
    "disabled")
      echo "disabled"
    ;;
    *)
      echo "[!] Could not determine Signed System Volume status! Exiting"
      exit 1
    ;;
  esac
}

#NEW: Determines if the device is a MacBook (returns string)
function is_macbook {
  PROFILER=$(system_profiler SPHardwareDataType | grep "Model Name" | sed 's/^ *//' | cut -d" " -f3)
  if [ "$PROFILER" == "MacBook" ]; then
    echo "true"
  else
    echo "false"
  fi
}

if [[ $UID -ne 0 ]]; then
  echo "This script needs to be run as root (with sudo)"
  exit 1
fi

#NEW: Determines if a firmware password has been set
function get_firmwarepasswd_status {
  FRW_STATUS=$(firmwarepasswd -check | cut -d" " -f3)
  case "$FRW_STATUS" in
    "On")
      echo "enabled"
    ;;
    "Off")
      echo "disabled"
    ;;
    *)
      echo "[!] Could not determine firmware password status! Exiting"
      exit 1
    ;;
  esac
}

#NEW: Determines the status of Gatekeeper policies
function get_gatekeeper_status {
  GATEKEEPER_STATUS=$(spctl --status 2>/dev/null | awk '{print $NF}')
  case "$GATEKEEPER_STATUS" in
    "enabled")
      echo "enabled"
    ;;
    "disabled")
      echo "disabled"
    ;;
    *)
      echo "[!] Could not determine Gatekeeper policy! Exiting"
      exit 1
  esac
}

#NEW: Determines if NTP is enabled
function get_ntp_status {
  NTP_STATUS=$(systemsetup -getusingnetworktime | awk '{print $NF}')
  case "$NTP_STATUS" in
    "On")
      echo "enabled"
    ;;
    "Off")
      echo "disabled"
    ;;
    *)
      echo "[!] Could not determine time configuration! Exiting"
      exit 1
    ;;
  esac
}

#NEW: Determine if Content Caching is enabled
function get_content_caching_status {
  CC_STATUC=$(defaults read /Library/Preferences/com.apple.AssetCache.plist Activated)
  case "$CC_STATUS" in
    "0")
      echo "disabled"
    ;;
    "1")
      echo "enabled"
    ;;
    *)
      echo "[!] Could not determine Content Caching status! Exiting"
      exit 1
  esac
}

DEBUG=false
if [[ "$1" == "--debug" ]]; then
  DEBUG=true
fi

#NEW: Breaks the version information into individual variables for later use
echo "[I] Determining macOS version"
VERSION=$(system_profiler SPSoftwareDataType | grep macOS | awk {'print $4'})
VERSION_MAJOR=$(echo $VERSION | cut -d. -f1)
VERSION_MINOR=$(echo $VERSION | cut -d. -f2)
VERSION_PATCH=$(echo $VERSION | cut -d. -f3)

#NEW: Gets the architecture for later use
ARCH=$(uname -a | awk -F" " '{print $NF}')

#NEW: Get administators account name
ADMIN=$(users)

#NEW: Uses a switch statement to determine the major version and act accordingly
if [ -n "$VERSION" ]; then
  case "$VERSION_MAJOR" in
  "10")
    if [ "$VERSION_MINOR" -ge "13" ]; then
      if $DEBUG; then
        echo "[I] You are running macOS $VERSION_MAJOR.$VERSION_MINOR, proceeding with provisioning"
      fi
    elif [ "$VERSION_MINOR" == "12" ]; then
      echo "[I] Error, this script is only for macOS 10.13 (High Sierra) and above. You are running macOS 10.12 (Sierra), please run the following provisioning script: https://www.ncsc.gov.uk/guidance/macos-1012-provisioning-script"
      exit 1
    else
      echo "[I] Error, this script is only for macOS 10.13 (High Sierra) and above."
      exit 1
    fi
  ;;
  "11")
    if $DEBUG; then
      echo "[I] You are running macOS $VERSION_MAJOR.$VERSION_MINOR, proceeding with provisioning"
    fi
  ;;
  *)
    echo "[I] Error, couldn't determine macOS version!"
    exit 1
  ;;
  esac
else
  echo "[I] Error, couldn't determine macOS version!"
  exit 1
fi

echo "[I] Beginning local provisioning now"

#NEW: Check if SIP is enabled
if ([ $VERSION_MAJOR == "10" ] && [ $VERSION_MINOR -ge "15" ]) || [ $VERSION_MAJOR -ge "11" ]; then
  echo "[I] Checking if System Integrity Protection (SIP) is enabled"
  if [ "$(get_sip_status)" == "enabled" ]; then
    echo "[I] System Integrity Protection (SIP) is enabled"
  else
    echo "[!] System Integrity Protection (SIP) is not enabled!"
    echo "[I] To continue with provisioning, you need to enable SIP in macOS Recovery with the following command:"
    echo "$ csrutil enable"
    exit 1
  fi
fi

#NEW: Check if SSV is enabled
if [ $VERSION_MAJOR -ge "11" ]; then
  echo "[I] Checking if Signed System Volume (SSV) is enabled"
  if [ "$(get_ssv_status)" == "enabled" ]; then
    echo "[I] Signed System Volume is enabled"
  else
    echo "[!] Signed System Volume is disabled!"
    echo "[I] To continue with provisioning, you need to enable SSV in macOS Recovery with the following command:"
    echo "$ csrutil authenticated-root enable"
    exit 1
  fi
fi

#NEW: Check the status of FileVault and enable it if it is not enabled
echo "[I] Checking FileVault status"
if [ "$(get_filevault_status)" == "enabled" ]; then
  echo "[I] FileVault is enabled, continuing"
else
  echo "[I] FileVault is not enabled... enabling now"
  echo "[ ] Enter your administrative account credentials when prompted"
  RKEY=$(fdesetup enable)
  RKEY_ONLY=$(echo $RKEY | cut -d"'" -f2)
  echo "[I] Your recovery key is $RKEY_ONLY, keep this safe!"
  echo "[I] FileVault is now enabled"
fi

#NEW: Get the status of firewall components (returns string)
function get_firewall_status {
  # on or off
  FW_LOGGING_MODE=$(/usr/libexec/ApplicationFirewall/socketfilterfw --getloggingmode | awk '{print $NF}')
  # ENABLED or DISABLED
  FW_ALLOW_SIGNED_BUILTIN=$(/usr/libexec/ApplicationFirewall/socketfilterfw --getallowsigned | head -n1 | awk '{print $NF}')
  # ENABLED or DISABLED
  FW_ALLOW_SIGNED_DOWNLOADED=$(/usr/libexec/ApplicationFirewall/socketfilterfw --getallowsigned | tail -n1 | awk '{print $NF}')
  # enabled or disabled
  FW_GLOBAL_STATE=$(/usr/libexec/ApplicationFirewall/socketfilterfw --getglobalstate | cut -d" " -f3 | sed 's/\.$//')
  # enabled or disabled
  FW_STEALTH_MODE=$(/usr/libexec/ApplicationFirewall/socketfilterfw --getstealthmode | awk '{print $NF}')
  # throttled, brief, or detail
  FW_LOGGING_OPT=$(/usr/libexec/ApplicationFirewall/socketfilterfw --getloggingopt | awk '{print $NF}')
  RESULT=("$FW_LOGGING_MODE $FW_ALLOW_SIGNED_BUILTIN $FW_ALLOW_SIGNED_DOWNLOADED $FW_GLOBAL_STATE $FW_STEALTH_MODE $FW_LOGGING_OPT")
  echo $RESULT
}

#NEW: Checks architecture to see if firmware passwords are supported. If so, uses the firmwarepasswd utility to set one
if [ "$ARCH" == "x86_64" ]; then
  if [ "$(get_firmwarepasswd_status)" == "disabled" ]; then
    echo "[I] Setting a firmware password"
    firmwarepasswd -setpasswd
  else
    echo "[I] Firmware password already set, skipping..."
  fi
else
  echo "[I] Firmware passwords not supported on Apple Silicon, skipping..."
fi

#NEW: Checks if the Gatekeeper master policy is enabled. I not, enables it
echo "[I] Checking Gatekeeper policy"
if [ "$(get_gatekeeper_status)" == "disabled" ]; then
  spctl --master-enable
  echo "[ ] Gatekeeper enabled"
else
  echo "[ ] Gatekeeper already enabled, skipping..."
fi

#NEW: Check if the time is set via the network (NTP)
echo "[I] Checking time configuration"
if [ "$(get_ntp_status)" == "disabled" ]; then
  systemsetup -setnetworktimeserver time.apple.com
  sntp -sS time.apple.com
else
  echo "[ ] Time already configured to use network, skipping..."
fi

#NEW: Disable Fast User Switching
echo "[I] Disabling Fast User Switching"
defaults write /Library/Preferences/.GlobalPreferences.plist MultipleSessionEnabled -bool false

read -p "[!] Enter a name for this device: " DEVNAME
systemsetup -setcomputername "$DEVNAME"
scutil --set HostName "$DEVNAME"

echo "[I] Creating a standard user account"
CONFIRM="n"
while [ "$CONFIRM" != "y" ]; do
  echo "[!] Enter username to create (e.g. jsmith):"
  read -p "Username: " USERNAME
  echo "[!] Enter user's full name (e.g. Alex Smith):"
  read -p "Real Name: " REALNAME
  echo "[!] Please provide a password for this account"
  get_user_pass

  echo " "
  echo "[?] Are the following details correct?"
  echo " Username: $USERNAME"
  echo " Real Name: $REALNAME"
  read -p "[y/n]: " CONFIRM
done

#NEW: Check to see if Content Caching is disabled
echo "[I] Checking Content Caching status"
if [ "$(get_content_caching_status)" == "enabled" ]; then
  AssetCacheManagerUtil deactivate
  echo "[ ] Content Caching disabled"
else
  echo "[ ] Content Caching already disabled... skipping"
fi

echo "[I] Turning off iCloud login prompt"
defaults write /System/Library/User\ Template/English.lproj/Library/Preferences/com.apple.SetupAssistant DidSeeCloudSetup -bool TRUE
defaults write /System/Library/User\ Template/English.lproj/Library/Preferences/com.apple.SetupAssistant GestureMovieSeen none
defaults write /System/Library/User\ Template/English.lproj/Library/Preferences/com.apple.SetupAssistant LastSeenCloudProductVersion "$VERSION"

echo "[I] Creating user $USERNAME"
if ([ $VERSION_MAJOR == "10" ] && [ $VERSION_MINOR -ge "14" ]) || [ $VERSION_MAJOR -ge "11" ]; then
  echo "[ ] Click 'OK' to allow Terminal to make system changes"
fi

if $DEBUG; then
  sysadminctl -addUser "$USERNAME" -fullName "$REALNAME" -password "$PASS"
else
  sysadminctl -addUser "$USERNAME" -fullName "$REALNAME" -password "$PASS" &>/dev/null
fi

echo "[I] Allowing user $USERNAME to access the FileVault protected volume"
echo "[ ] Enter administrative credentials when prompted"
sysadminctl interactive -secureTokenOn $USERNAME -password "$PASS"

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
#NEW: Enable SecureKeyboardEntry on Terminal
defaults write -app Terminal SecureKeyboardEntry -bool true
sudo -u $USERNAME defaults write -app Terminal SecureKeyboardEntry -bool true

#NEW: Secure the login Keychain with an inactivity timeout
echo "[I] Configurating Keychain inactivity lock "
security set-keychain-settings -l -t 21600 /Users/$ADMIN/Library/Keychains/login.keychain
sudo -u $USERNAME security set-keychain-settings -l -t 21600 /Users/$USERNAME/Library/Keychains/login.keychain

echo "[I] Configuring Login Window"
defaults write /Library/Preferences/com.apple.loginwindow com.apple.login.mcx.DisableAutoLoginClient -int 1
defaults write /Library/Preferences/com.apple.loginwindow DisableConsoleAccess -int 1
defaults write /Library/Preferences/com.apple.loginwindow DisableFDEAutoLogin -int 1
defaults write /Library/Preferences/com.apple.loginwindow HideAdminUsers -int 1
defaults write /Library/Preferences/com.apple.loginwindow HideLocalUsers -int 1
defaults write /Library/Preferences/com.apple.loginwindow HideMobileAccounts -int 1
defaults write /Library/Preferences/com.apple.loginwindow IncludeNetworkUser -int 0
defaults write /Library/Preferences/com.apple.loginwindow LocalUserLoginEnabled -int 1
defaults write /Library/Preferences/com.apple.loginwindow LoginwindowText -string "Authorised use only. Unauthorised usage will be subject to disciplinary and/or legal action."
defaults write /Library/Preferences/com.apple.loginwindow SHOWFULLNAME -int 1
defaults write /Library/Preferences/com.apple.loginwindow SHOWOTHERUSERS_MANAGED -int 1
defaults write /Library/Preferences/com.apple.loginwindow RestartDisabled -int 1
defaults write /Library/Preferences/com.apple.loginwindow ShutDownDisabled -int 1
defaults write /Library/Preferences/com.apple.loginwindow SleepDisabled -int 1
defaults write /Library/Preferences/com.apple.loginwindow RetriesUntilHint -int 0
defaults write /Library/Preferences/com.apple.loginwindow GuestEnabled -bool false

echo "[I] Configuring FileVault key lifetime"
pmset destroyfvkeyonstandby 1 hibernatemode 25

#NEW: Prevents guests from accessing shared folders
echo "[I] Disallowing guests from accessing shared folders"
defaults write /Library/Preferences/com.apple.AppleFileServer guestAccess -bool false
defaults write /Library/Preferences/SystemConfiguration/com.apple.smb.server AllowGuestAccess -bool false

#NEW: Disables Siri and makes it so she doesn't ask for permission again
echo "[I] Disabling Siri"
defaults write com.apple.assistant.support.plist 'Assistant Enabled' -int 0
sudo -u $USERNAME defaults write /Users/$USERNAME/Library/Preferences/com.apple.assistant.support.plist 'Assistant Enabled' -int 0
defaults write com.apple.Siri.plist StatusMenuVisible -bool false
sudo -u $USERNAME defaults write /Users/$USERNAME/Library/Preferences/com.apple.Siri.plist StatusMenuVisible -bool false
defaults write com.apple.Siri UserHasDeclinedEnabled -bool true
sudo -u $USERNAME defaults write /Users/$USERNAME/Library/Preferences/com.apple.Siri.plist UserHasDeclinedEnable -bool true

echo "[I] Disabling IPv6"
networksetup -setv6off Wi-Fi >/dev/null
networksetup -setv6off Ethernet >/dev/null

echo "[I] Disabling infrared receiver"
defaults write com.apple.driver.AppleIRController DeviceEnabled -bool false

echo "[I] Disabling Bluetooth"
defaults write /Library/Preferences/com.apple.Bluetooth ControllerPowerState -int 0
defaults write /Users/$USERNAME/Library/Preferences/com.apple.systemuiserver menuExtras -array-add "/System/Library/CoreServices/Menu Extras/Bluetooth.menu"

#NEW: Only disable Wi-Fi if the device is not a MacBook
if [ "$(is_macbook)" == "false" ]; then
  echo "[I] Turning off Wi-Fi"  
  networksetup -setairportpower airport off > /dev/null
fi

#NEW: Disable's wake on network access
echo "[I] Disabling wake on network access"
pmset -a womp 0

echo "[I] Enabling scheduled updates"
softwareupdate --schedule on
defaults write /Library/Preferences/com.apple.SoftwareUpdate.plist AutomaticCheckEnabled -bool true
defaults write /Library/Preferences/com.apple.SoftwareUpdate.plist AutomaticDownload -bool true
defaults write /Library/Preferences/com.apple.SoftwareUpdate.plist ConfigDataInstall -bool true
defaults write /Library/Preferences/com.apple.SoftwareUpdate.plist CriticalUpdateInstall -bool true
defaults write /Library/Preferences/com.apple.commerce.plist AutoUpdateRestartRequired -bool true
defaults write /Library/Preferences/com.apple.commerce.plist AutoUpdate -bool true

echo "[I] Enabling password-protected screen lock after 5 minutes"
systemsetup -setdisplaysleep 5
defaults write com.apple.screensaver askForPassword -int 1
defaults write com.apple.screensaver askForPasswordDelay -int 0
defaults write com.apple.screensaver idleTime -int 600

#NEW: Check the status of firewall components and act according to what is already set
echo "[I] Enabling firewall"
FW_STATUS_STR=$(get_firewall_status)
IFS=" " read -r -a FW_STATUS <<< "$FW_STATUS_STR"
if [[ "${FW_STATUS[0]}" == "off" ]]; then
  /usr/libexec/ApplicationFirewall/socketfilterfw --setloggingmode on
else
  echo "[ ] Firewall: Logging mode already enabled"
fi
if [[ "${FW_STATUS[1]}" == "DISABLED" ]]; then
  /usr/libexec/ApplicationFirewall/socketfilterfw --setallowsigned on
else
  echo "[ ] Firewall: Builtin signed applications already allowed"
fi
if [[ "${FW_STATUS[2]}" == "DISABLED" ]]; then
  /usr/libexec/ApplicationFirewall/socketfilterfw --setallowsignedapp on
else
  echo "[ ] Firewall: Downloaded signed applications already allowed"
fi
if [[ "${FW_STATUS[3]}" == "disabled" ]]; then
  /usr/libexec/ApplicationFirewall/socketfilterfw --setglobalstate on
else
  echo "[ ] Firewall: Global state already enabled"
fi
if [[ "${FW_STATUS[4]}" == "disabled" ]]; then
  /usr/libexec/ApplicationFirewall/socketfilterfw --setstealthmode on
else
  echo "[ ] Firewall: Stealth mode already enabled"
fi
if [[ "${FW_STATUS[5]}" == "throttled" ]] || [[ "${FW_STATUS[5]}" == "brief" ]]; then
  /usr/libexec/ApplicationFirewall/socketfilterfw --setloggingopt detail
else
  echo "[ ] Firewall: Logging options already det to detailed"
fi

#NEW: Set Finder to show all extensions to help identify potential malware
echo "[I] Setting Finder to show all file extensions"
defaults write /Library/Preferences/.GlobalPreferences.plist AppleShowAllExtensions -bool true

#NEW: Ensure telemetry/data sharing is disabled
echo "[I] Disabling sending of diagnostics data"
defaults write /Library/Application\ Support/CrashReporter/DiagnosticsMessagesHistory.plist AutoSubmit -bool false
defaults write /Library/Application\ Support/CrashReporter/DiagnosticsMessagesHistory.plist ThirdPartyDataSubmit -bool false

#NEW: Disable Bonjour advertismenets
echo "[I] Disabling Bonjour Advertising"
defaults write /Library/Preferences/com.apple.mDNSResponder.plist NoMulticastAdvertisements -bool true

echo "[!] Provisioning complete. Press enter when done"
read DONE