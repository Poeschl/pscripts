#!/usr/bin/env bash
# Update package lists
sudo pacman -Syy

#Update all packages
sudo pacman -Syu

#Clean up orphans
sudo pacman -Qdt
