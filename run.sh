#!/bin/bash
# Add custom JVM arguments to the user_jvm_args.txt!

paperversion=""
RETRY=10

# get latest paper version
while [ "$RETRY" -gt 0 ]; do
  paperversion=$(curl -s https://api.papermc.io/v2/projects/paper | jq --raw-output '.versions | reverse[0]')
  if [ ! -z $paperversion ]
  then
    break
  else
    let RETRY-=1
    sleep 5
  fi
done

if [ "$RETRY" -eq 0 ]
then
  exit 2
fi

# Auto update paper
paperversion=$(curl -s https://api.papermc.io/v2/projects/paper | jq --raw-output '.versions | reverse[0]')
paperbuild=$(curl -s https://api.papermc.io/v2/projects/paper/versions/$paperversion | jq --raw-output '.builds | max')
paperchannel=$(curl -s https://api.papermc.io/v2/projects/paper/versions/$paperversion/builds/$paperbuild | jq --raw-output '.channel')
paperdownload=$(curl -s https://api.papermc.io/v2/projects/paper/versions/$paperversion/builds/$paperbuild | jq --raw-output '.downloads.application.name')

if [ "$paperchannel" = "experimental" ];
then
  echo "dont download paper mcsv version $paperversion build $paperbuild because it's $paperchannel!"
else
  echo "DO download paper mcsv version $paperversion build $paperbuild because it's $paperchannel"
  cd "$(dirname "$0")"
  rm paper.jar.bak.bak
  mv paper.jar.bak paper.jar.bak.bak
  mv paper.jar paper.jar.bak

  wget https://api.papermc.io/v2/projects/paper/versions/$paperversion/builds/$paperbuild/downloads/$paperdownload

  mv $paperdownload paper.jar
  echo "Downloaded $paperdownload"

  #auto update plugins
  cd "$(dirname "$0")"
  cd plugins

  # auto update geyser plugin
  rm geyser.jar.bak.bak
  mv geyser.jar.bak geyser.jar.bak.bak
  mv geyser.jar geyser.jar.bak

  wget https://download.geysermc.org/v2/projects/geyser/versions/latest/builds/latest/downloads/spigot

  mv spigot geyser.jar

  # auto update floodgate plugin
  rm floodgate.jar.bak.bak
  mv floodgate.jar.bak floodgate.jar.bak.bak
  mv floodgate.jar floodgate.jar.bak

  wget https://download.geysermc.org/v2/projects/floodgate/versions/latest/builds/latest/downloads/spigot

  mv spigot floodgate.jar
fi

# get back to main dir and start the server
cd "$(dirname "$0")"
java @user_jvm_args.txt -jar paper.jar
