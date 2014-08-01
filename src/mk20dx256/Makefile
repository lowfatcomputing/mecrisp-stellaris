include ../Makefile

ARMGNU?=arm-none-eabi

all: mk20dx256.hex

install: 
	sudo teensy-loader-cli -mmcu=mk20dx128 -w -v mk20dx256.hex

