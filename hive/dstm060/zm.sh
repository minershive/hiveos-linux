#!/usr/bin/env bash

[[ ! -e ./zm.conf ]] && echo "No zm.conf, exiting" && exit 1

./zm --cfg-file=zm.conf
