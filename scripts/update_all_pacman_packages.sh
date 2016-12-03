#!/usr/bin/env bash
# Update package lists
pacman -Syy

#Update all packages
pacman -Syu

#Clean up orphans
pacman -Qdt
