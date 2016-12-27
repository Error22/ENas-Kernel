#!/bin/bash

apt-get update
apt-get build-dep -y linux-image-$(uname -r)
export DEBIAN_FRONTEND=noninteractive
apt-get install -y git build-essential kernel-package fakeroot libncurses5-dev software-properties-common
apt-get update