all:
	make -C .. stm32f429/stm32f429.bin
	arm-none-eabi-objcopy --change-addresses 0x08000000 -I binary -O ihex stm32f429.bin stm32f429.hex
