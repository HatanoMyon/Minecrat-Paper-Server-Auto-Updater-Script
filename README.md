# Minecrat Paper Server Auto Updater Script
A script that auto updates paper minecraft server, geyser and floodgate plugins.

***

## Use case
After having a previously installed and configured Minecraft [Paper](https://papermc.io/) server with both [Geyser and Floodgate](https://geysermc.org/), put this script inside your server folder (where your paper jar file is) and create a `user_jvm_args.txt` in the same folder like the one I have included as an example.
Then add running this script as a unit service or at reboot and it will ensure that you always have the latest stable release of paper and updated geyser and floodgate plugins.

***
## Notes
I created this script for my private minecraft server. It needed to have Geyser and Floodgate in order to allow crossplay because of some players only having access to bedrock version.
It was built for running at reboot because I reboot my server every night for automatic backups anyways.
I shared it in hopes that it could be useful for someone else. Enjoy.
