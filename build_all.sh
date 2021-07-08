#! /usr/bin/env bash

Build_Root=$HOME
SimpleITK_Source=$Build_Root/SimpleITK
COREBINARYDIRECTORY=$Build_Root/SimpleITK-build

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"

cd $Build_Root

# Get the SimpleITK Source
if [ -d $SimpleITK_Source ]
then
    pushd $SimpleITK_Source
    git pull
    popd
else
    git clone https://github.com/SimpleITK/SimpleITK.git
    $SimpleITK_Source=.
fi

if [ ! -z $SIMPLEITK_GIT_TAG ]
then
    pushd $SimpleITK_Source
    git checkout $SIMPLEITK_GIT_TAG
    popd
fi

mkdir -p $COREBINARYDIRECTORY
pushd $COREBINARYDIRECTORY
sh $SCRIPT_DIR/mac_build_core.sh
popd

mkdir -p py38
pushd py38
COREBINARYDIRECTORY=$COREBINARYDIRECTORY sh $SCRIPT_DIR/mac_build_py.sh 3.8
popd

mkdir -p py39
pushd py39
COREBINARYDIRECTORY=$COREBINARYDIRECTORY sh $SCRIPT_DIR/mac_build_py.sh 3.9
popd
