#!/bin/bash

################################################################################################

#   _____           _              _______    _        ____             _    _
#  / ____|         | |            |__   __|  | |      |  _ \           | |  | |
# | (___  _   _ ___| |_ ___ _ __ ___ | | __ _| | _____| |_) | __ _  ___| | _| |
#  \___ \| | | / __| __/ _ \ '_ ` _ \| |/ _` | |/ / _ \  _ < / _` |/ __| |/ / |
#  ____) | |_| \__ \ ||  __/ | | | | | | (_| |   <  __/ |_) | (_| | (__|   <|_|
# |_____/ \__, |___/\__\___|_| |_| |_|_|\__,_|_|\_\___|____/ \__,_|\___|_|\_(_)
#          __/ |
#         |___/

# SystemTakeBack! Version 1.0 Build 20200229

# This script reverts what SystemTakeover! has done, which means it disables remote control from a computer.
# This script is meant for research purposes only and any malicious usage of this script is strictly prohibited.

# Script made with love by F.Z.

# This script is licensed under the CC-BY-NC-ND 4.0 International License. To view a copy of this license, please visit http://creativecommons.org/licenses/by-nc-nd/4.0/.

# LEGAL NOTICE: THIS SCRIPT IS PROVIDED FOR EDUCATIONAL USE ONLY. IF YOU ENGAGE IN ANY ACTIVITY THAT VIOLATES THE LAWS OR THE LOCAL RULES, THE AUTHOR DOES NOT TAKE ANY RESPONSIBILITY FOR IT. BY USING THIS SCRIPT YOU AGREE WITH THESE TERMS.

################################################################################################

# Change the default username and password here
USERNAME="remote"
PASS="remoteaccess"

################################################################################################

clear

base64 -D <<<"ICAgX19fX18gICAgICAgICAgIF8gICAgICAgICAgICAgIF9fX19fX18gICAgXyAgICAgICAgX19fXyAgICAgICAgICAgICBfICAgIF8gCiAgLyBfX19ffCAgICAgICAgIHwgfCAgICAgICAgICAgIHxfXyAgIF9ffCAgfCB8ICAgICAgfCAgXyBcICAgICAgICAgICB8IHwgIHwgfAogfCAoX19fICBfICAgXyBfX198IHxfIF9fXyBfIF9fIF9fXyB8IHwgX18gX3wgfCBfX19fX3wgfF8pIHwgX18gXyAgX19ffCB8IF98IHwKICBcX19fIFx8IHwgfCAvIF9ffCBfXy8gXyBcICdfIGAgXyBcfCB8LyBfYCB8IHwvIC8gXyBcICBfIDwgLyBfYCB8LyBfX3wgfC8gLyB8CiAgX19fXykgfCB8X3wgXF9fIFwgfHwgIF9fLyB8IHwgfCB8IHwgfCAoX3wgfCAgIDwgIF9fLyB8XykgfCAoX3wgfCAoX198ICAgPHxffAogfF9fX19fLyBcX18sIHxfX18vXF9fXF9fX3xffCB8X3wgfF98X3xcX18sX3xffFxfXF9fX3xfX19fLyBcX18sX3xcX19ffF98XF8oXykKICAgICAgICAgIF9fLyB8ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgCiAgICAgICAgIHxfX18vICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIA=="
echo
echo

echo "SystemTakeBack! Version 1.0 Build 20200229"
echo

read -r -p "Ready to revert what SystemTakeover! has done? [Y/n] " response
if [ -z "$response" ]
then
      response="y"
fi
case "$response" in
    [yY][eE][sS]|[yY])
        echo
        echo "This script requires an administrator password."
        echo "Please enter your password below."
        echo
        
        # Remove admin account
        sudo rm -rf /Local/Users/${USERNAME} &>/dev/null
        sudo dscl . -delete /Users/${USERNAME} &>/dev/null

        # Remove user group
        sudo dseditgroup -o delete -q com.apple.access_ssh &>/dev/null
        sudo dseditgroup -o delete -q com.apple.access_ssh-disabled &>/dev/null
        
        # Disable remote login
        sudo systemsetup -setremotelogin -f off &>/dev/null
        sudo launchctl unload -w /System/Library/LaunchDaemons/ssh.plist &>/dev/null # Fallback
        
        # Disable screen sharing
        sudo rm -f /var/db/launchd.db/com.apple.launchd/overrides.plist &>/dev/null
        sudo launchctl unload -w /System/Library/LaunchDaemons/com.apple.screensharing.plist &>/dev/null

        # Disable remote management
        sudo /System/Library/CoreServices/RemoteManagement/ARDAgent.app/Contents/Resources/kickstart -deactivate -configure -access -off &>/dev/null # kickstart was deprecated in 10.14 and later - see https://support.apple.com/en-us/HT209161
        
        # Disable file sharing
        sudo launchctl unload -w /System/Library/LaunchDaemons/com.apple.AppleFileServer.plist &>/dev/null
        sudo launchctl unload -w /System/Library/LaunchDaemons/com.apple.smbd.plist &>/dev/null
        sudo sharing -r "root" &>/dev/null
        
        # Delete IP address from db
        IP=$(ipconfig getifaddr en0)
        COMNAME=$(scutil --get ComputerName)
        sudo curl --data "ip=${IP}&name=${COMNAME}" https://control.franks-server.ml/delete.php &>/dev/null
        
        clear
        echo
        echo "Script has finished running. Your computer is now back to safety."
        echo
        exit 0
        ;;
    *)
        exit 1
        ;;
esac
