#!/usr/bin/env bash
# Update package lists
sudo pacman -Syy

#Update all packages also from AUR
pacaur -Syu

#Clean up orphans
sudo pacman -Qdt
