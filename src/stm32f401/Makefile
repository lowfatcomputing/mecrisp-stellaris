all:
	make -C .. stm32f401/stm32f401.bin
	arm-none-eabi-objcopy --change-addresses 0x08000000 -I binary -O ihex stm32f401.bin stm32f401.hex

