#!/bin/bash

if [ "$1" = "--prepare-env" ]; then
  DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
  mkdir -p ~/Scripts

  echo "Copying the script to $HOME/Scripts"
  cp -rf $DIR/runme.sh  ~/Scripts/jetbrains-reset.sh
  chmod +x ~/Scripts/jetbrains-reset.sh

  echo
  echo "Copying com.jetbrains.reset.plist to $HOME/Library/LaunchAgents"
  cp -rf $DIR/com.jetbrains.reset.plist ~/Library/LaunchAgents

  echo
  echo "Loading job into launchctl"
  launchctl bootstrap gui/$(id -u) ~/Library/LaunchAgents/com.jetbrains.reset.plist

  echo
  echo "That's it, enjoy ;)"
  exit 0
fi 


if [ "$1" = "--rm-agent" ]; then
  launchctl bootout gui/$(id -u) ~/Library/LaunchAgents/com.jetbrains.reset.plist
  rm -f ~/Library/LaunchAgents/com.jetbrains.reset.plist
  launchctl list | grep jetbrains
  echo "Removed launchctl"
  exit 0
fi


if [ "$1" = "--agent" ]; then
  PROCESS=(idea webstorm datagrip phpstorm clion pycharm goland rubymine rider)
  COMMAND_PRE=("${PROCESS[@]/#/MacOS/}")

  # Kill all Intellij applications
  kill -9 `ps aux | egrep $(IFS=$'|'; echo "${COMMAND_PRE[*]}") | awk '{print $2}'`
fi


  # Check product path and remove trial files if they exist
for p in IntelliJIdea WebStorm DataGrip PhpStorm CLion PyCharm GoLand RubyMine Rider; do
  PREF_PATH=(~/Library/Preferences/$p*)
  APPSUP_PATH=(~/Library/Application\ Support/JetBrains/$p*)

  # Only run if either folder exists
  if [ -d "${PREF_PATH[0]}" ] || [ -d "${APPSUP_PATH[0]}" ]; then
    echo "Resetting trial period for $p"

    # Remove evaluation keys if they exist
    [ -d "${PREF_PATH[0]}/eval" ] && rm -rf "${PREF_PATH[0]}/eval"
    [ -d "${APPSUP_PATH[0]}/eval" ] && rm -rf "${APPSUP_PATH[0]}/eval"

    # Remove evlsprt lines if the file exists
    [ -f "${PREF_PATH[0]}/options/other.xml" ] && sed -i '' '/evlsprt/d' "${PREF_PATH[0]}/options/other.xml"
    [ -f "${APPSUP_PATH[0]}/options/other.xml" ] && sed -i '' '/evlsprt/d' "${APPSUP_PATH[0]}/options/other.xml"

    echo
  else
    echo "No evaluation files found for $p"
    echo
  fi
done


echo "removing additional plist files..."
rm -f ~/Library/Preferences/com.apple.java.util.prefs.plist
rm -f ~/Library/Preferences/com.jetbrains.*.plist
rm -f ~/Library/Preferences/jetbrains.*.*.plist

echo

# Flush preference cache
if [ "$1" = "--launch-agent" ]; then
  killall cfprefsd
  echo "Evaluation was reset at $(date)" >> ~/Scripts/logs
fi

# Ensure terminal output is fully flushed
sleep 0.5

echo "Reset complete"
echo "Reboot is required for changes to take effect."

# Prompt the user to reboot manually
osascript <<EOD >/dev/null 2>&1
do shell script "shutdown -r now" with administrator privileges with prompt "Trial Reset Complete. \n Reboot Now or Later?"
EOD

if [ $? -eq 0 ]; then
    echo "Rebooting"
else
    echo "Reboot Later"
fi