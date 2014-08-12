all:
	make -C .. stm32f100/stm32f100.bin
	arm-none-eabi-objcopy --change-addresses 0x08000000 -I binary -O ihex stm32f100.bin stm32f100.hex

