#!/bin/bash

export LANG="en_US.UTF-8"

flutter packages pub run build_runner clean
flutter packages pub run build_runner build --delete-conflicting-outputs

#sleep 300
