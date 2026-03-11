<div style="font-size: 32px;">JetBrains Trial Reset</div>
IntelliJ IDEA - WebStorm - DataGrip - PhpStorm - CLion - PyCharm - RubyMine - GoLand - Rider

<br>

### Changes:
- Changed launch agent to run every 29 days instead of monthly.
- Updated launch agent job handling.
- Made the script provide clearer messages to the user.
- Added checks to avoid errors if folders or files don’t exist.
- Updated paths for newer JetBrains versions.
- Added final reboot prompt.
<br>

### Notes:
- Both manual and auto reset will prompt to restart once trial reset is complete. You may select now or later.  
- Please save your work before rebooting.
- This script keeps settings, logs and cache

<br>
<br>

Make it executable first 
```
cd /path/to/jetbrains-reset-trial-evaluation-mac-master
chmod +x runme.sh
```
<br>

Auto -
Installs a launch agent (runs every 29 days)
```
./runme.sh --agent
```
Manual - Run the scipt every 29th day
```
./runme.sh
```
<br>

Removal launch agent
```
./runme.sh --rm-agent
```


