#!/bin/bash

yay -Syy &> /dev/null
echo "$(yay -Qu | wc -l)"
