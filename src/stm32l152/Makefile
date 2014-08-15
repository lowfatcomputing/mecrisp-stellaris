all:
	make -C .. stm32l152/stm32l152.bin
	arm-none-eabi-objcopy --change-addresses 0x08000000 -I binary -O ihex stm32l152.bin stm32l152.hex

