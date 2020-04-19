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
else
    SCRIPT_DIR=$(dirname $(readlink -f $0))
fi

docker run -v $SCRIPT_DIR/../samples:/tmp/samples --rm -it --network none android-reversing-workbench:latest
