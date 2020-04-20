#!/bin/bash
set -euo pipefail

# Get the dir the script lives in not just the one it's exec'd from 
SCRIPT_DIR=""
if [ "$(uname)" == 'Darwin' ]; then

    if [ -z "$(which greadlink)" ]; then
        echo "Install brew then run \`brew install coreutils\`"
        exit 1
    fi

    SCRIPT_DIR=$(dirname $(greadlink -f $0))
    XHOST=/opt/X11/bin/xhost
else
    SCRIPT_DIR=$(dirname $(readlink -f $0))
    XHOST=xhost
fi

# allow access from localhost
$XHOST + 127.0.0.1

echo "caution: networking now in bridge (docker default) mode"

docker run -v $SCRIPT_DIR/../samples:/tmp/samples -e DISPLAY=host.docker.internal:0 --rm -it android-reversing-workbench:latest
