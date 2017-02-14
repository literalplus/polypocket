#!/usr/bin/env bash

# Polypocket - https://github.com/xxyy/polypocket
# Consult the LICENSE and README.md files for more info.

# Write new files with rw permissions for owner and group
# and read-only for others. This is useful for config
# files where other users of the same group may need to
# edit them, for example via SFTP.
umask 002

# --- Configuration is done in config.sh
# config.sh calls the global config defaults file
# to make up for any new, not-yet-configured properties.
source config.sh

echo "Updating start script for next execution..."
cp $POLYPOCKET/start.sh start.sh

echo "Updating $SERVER_JAR from $UPSTREAM_SERVER_JAR..."
cp $UPSTREAM_SERVER_JAR $SERVER_JAR

echo "Updating plugins in $PLUGINS_FOLDER from $UPSTREAM_PLUGINS_FOLDER..."
mkdir -p $PLUGINS_FOLDER
#r...recursive, v...verbose,t...preserve times,
#u...update (skip files with newer or equal mtime),c...update based on checksum
#L...copy links as files
rsync -rtvucL --progress $UPSTREAM_PLUGINS_FOLDER $PLUGINS_FOLDER

# Try to kill dead previous instance
if [ "$KILL_IF_PID" = true ]; then
  if [ -r "mc.pid" ]; then
    PREV_PID=$(cat mc.pid)
    echo "A previous instance was not stopped cleanly - Killing PID $PREV_PID."
    kill -0 $PREV_PID
    if [ "$?" == 0 ]; then
      # It refused to kill itself, so we got to murder it
      kill -9 $PREV_PID
      if [ "$?" == 0 ]; then
        echo "Killed $PREV_PID."
      else
        echo "Failed to kill $PREV_PID...exiting!"
        exit 1
      fi
    else
      echo "Already dead. Nice!"
      rm mc.pid
    fi
  fi
fi

echo 'Starting server...'

# Note that this is Polypocket's PID
# Finding the Minecraft PID would be a little more complicated.
MC_PID="$$"
echo "My PID is $MC_PID"
echo "$MC_PID" >mc.pid

# Flags in order:
# Set servername system property, actually for easy identification in htop
# Use new G1 Garbage Collector, better performance and all than default
# Limit GC pauses to prevent lag spikes on GC
# Required for RemoteToolkit apparently
# Use UTF-8 as default encoding - solves issues with config files and basically everything
# Limit memory allocation

java \
  -Dservername=$SERVER_NAME \
  -XX:+UseG1GC \
  -XX:MaxGCPauseMillis=50 \
  -Djline.terminal=jline.UnsupportedTerminal \
  -Dfile.encoding=UTF-8 \
  -Xmx$MAX_MEMORY \
  -jar $SERVER_JAR

# oh no we're dead rip
echo "Server exited! (PID: $MC_PID)"
rm mc.pid

# This is why you need a wrapper script
