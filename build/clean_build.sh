#!/bin/sh
# if PWD is not the build directory, return with exit code 1
if [ ! -f "clean_build.sh" ]; then
    echo "This script must be run from the CS3305-2024-Team-2/build directory";
    exit 1;
fi
rm -rf linux/* || exit 1;
rm -rf mac/* || exit 1;
rm -rf windows/* || exit 1;
exit 0;

