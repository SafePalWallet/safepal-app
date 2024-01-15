#!/bin/bash

export LANG="en_US.UTF-8"

dart run build_runner clean
dart run build_runner build --delete-conflicting-outputs

#sleep 300
