#!/usr/bin/env zsh
main() {
	echo 'Before flashing make sure you have following files in the current folder:'
	# echo '+ SuperSu-vx.xx-xxxxxxxxx.zip'
	echo '+ bullhead-xxxxxx-factory-xxxxxxxx'
	echo '####################################################'
	read -p "Are the files there [y/n]? " -n 1 -r
	echo

	if [[ ! $REPLY =~ ^[Yy]$ ]]
	then
		exit 1
	fi

	#Continiue extracting
	echo Extracting images...
	mkdir images
	unzip -j bullhead-*-factory-*.zip "*.zip" -d images
	unzip -j bullhead-*-factory-*.zip "*.img" -d images
	unzip -j images/image-bullhead-*.zip "*.img" -d images
	rm images/*.zip

	echo 'Put flightmode on and reboot the device into the bootloader'
	waitingForFastbootDevice

	echo 'Start flashing now...'
	read -p "Is that ok [y/n]? " -r

	if [[ ! $REPLY =~ ^[Yy]$ ]]
	then
		echo 'Flashing aborted'
		exit 1
	fi

	fastboot flash bootloader bootloader-bullhead-*.img
	fastboot reboot-bootloader
	waitingForFastbootDevice

	fastboot flash radio radio-bullhead-bullhead-*.img
	fastboot reboot-bootloader
	waitingForFastbootDevice

	fastboot flash boot boot.img
	fastboot erase cache
	fastboot flash cache cache.img
	# fastboot flash recovery recovery.img
	fastboot flash system system.img
	fastboot flash vendor vendor.img

	echo 'Flashing finished. Please install SuperSu again for root rights.'
	echo 'The system might overwrite a custom recovery so you might have to install it again as well.'
}

function waitingForFastbootDevice {
	echo 'Waiting for fastboot device... '
	#sleep 5
	fastboot device
}

main
