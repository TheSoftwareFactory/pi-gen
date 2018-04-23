#!/bin/bash

# Check that build configuration exists
if [ ! -f config ]; then
    echo "Build configuration missing"
    exit 1
fi

# Build only a lite system by disabling stages 3-5
touch ./stage3/SKIP ./stage4/SKIP ./stage5/SKIP
touch ./stage4/SKIP_IMAGES ./stage5/SKIP_IMAGES

sudo ./build.sh
