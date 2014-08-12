all:
	make -C .. stm32f103/stm32f103.bin
	arm-none-eabi-objcopy --change-addresses 0x08000000 -I binary -O ihex stm32f103.bin stm32f103.hex
