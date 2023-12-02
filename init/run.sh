#!/bin/bash

rar x init.part1.rar -y
tar -zxvf init.tar.gz
mv init/inet4.5 ../
mv init/simu5G ../

rmdir init
rm init.tar.gz
