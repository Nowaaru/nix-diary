set -l discord_path = (string match -r "discord: (.+)" $(whereis -b discord))[2]
echo "$discord_path --enable-features=UseOzonePlatform --ozone-platform=wayland"
