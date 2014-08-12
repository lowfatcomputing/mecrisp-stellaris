all:
	make -C .. stm32f407/stm32f407.bin
	arm-none-eabi-objcopy --change-addresses 0x08000000 -I binary -O ihex stm32f407.bin stm32f407.hex
