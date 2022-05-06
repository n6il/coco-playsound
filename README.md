# CoCo Playsound module for pyDriveWire
This project contains sample code for using the PlaySound module for pyDriveWire.  

The contents of the project are:

* playsound.bas - a BASIC loader program.  Allows you to select a DriveWire module and play sample sounds
* Makefile - project make file
* coco-playsound-player.asm - driver program
* coco-playsound-module.asm - playsound module
* dwread.asm - DriveWire DWRead module
* dwwrite.asm - DriveWire DWWrite module
* dwdefs.d - assembler defines for DriveWire modules

## Building the Project

PreRequisites
* lwasm
* toolshed

Run: 

    make dsk
    
This makes coco-playsound.dsk with the following contents

* PLAYSND.BAS - a BASIC loader program.  Allows you to select a DriveWire module and play sample sounds
* PLAYSND.BIN - Driver program
* DWSMCC23.BIN - DriveWire Sound Module for CoCo2(57600)/CoCo3(115200) Bit-Banger Port
* DWSMCC1.BIN - DriveWire Sound Module for CoCo1(38400) Bit-Banger Port
* DWSMBCK.BIN - DriveWire Sound Module for Becker Port - Emulators and CoCo3Fpga
* DWSM232.BIN - DriveWire Sound Module for RS-232 Pak(115200)

## Running the Demo

Put the disk image in your CoCo

    RUN "PLAYSND
    
