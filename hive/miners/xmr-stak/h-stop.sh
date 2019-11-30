#!/usr/bin/env bash

hugepages -r

pidof xmr-stak | xargs kill -9
