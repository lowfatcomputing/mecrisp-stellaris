all:
	make -C .. stm32f051/stm32f051.bin
	arm-none-eabi-objcopy --change-addresses 0x08000000 -I binary -O ihex stm32f051.bin stm32f051.hex

