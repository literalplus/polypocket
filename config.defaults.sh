#!/bin/bash

# Polypocket - https://github.com/xxyy/polypocket
# Consult the LICENSE and README.md files for more info.

# This is the main global configuration file
# for Polypocket. Edit this accordingly for the template
# folder. This is sourced by the individual instances
# before their own configuration files to provide
# default values for unset properties.

# NOTE: Do not try to replace local config files with the
# global config or vice-versa. That breaks the local
# config calling the global config.

# --- General settings
# Name of this server
#  Try to stick to [A-Za-z0-9] to prevent issues.
export SERVER_NAME=unknown

# --- Server binaries
# Path to this instance's server binary, relative to the
#  local start.sh script - should be a jar file.
export SERVER_JAR=Paperclip.jar
# Path to the 'upstream' server binary, as absolute path.
#  The script will update $SERVER_JAR from this file
#  every time it starts
export UPSTREAM_SERVER_JAR=~minecraft/bin/Paperclip.jar

# --- Plugin distribution
# Path to the plugins folder of this instance, relative to
#  the local start.sh script - usually ./plugins/
#  Note that this needs a tailing slash.
export PLUGINS_FOLDER=./plugins/
# Path to the 'upstream' plugins folders.
#  These should be absolute paths with tailing slashes.
#  You can put as many as you like.
#  For files with the same name, the one from the folder
#  that appears first in the list is taken.
EXTRA_PLUGINS=~minecraft/plugins/extra/$SERVER_NAME/
COMMON_PLUGINS=~minecraft/plugins/common/
export UPSTREAM_PLUGINS_FOLDER="$EXTRA_PLUGINS $COMMON_PLUGINS"

# --- Runtime settings
# The Java -Xmx maxiumum memory allocated to the server binary
export MAX_MEMORY=4G
# Whether previous instances that may still be running should
#  be killed if a process id file is found in the local
#  instance folder. Note that this may under some rare
#  circumstances kill unrelated processes that have the same
#  PID as a previous server process that did not exit cleanly,
#   but also doesn't exist any more.
export KILL_IF_PID=true;

# ------ End of file

