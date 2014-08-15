all:
	make -C .. stm32f303/stm32f303.bin
	arm-none-eabi-objcopy --change-addresses 0x08000000 -I binary -O ihex stm32f303.bin stm32f303.hex

