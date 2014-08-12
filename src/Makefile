TERMPORT?=/dev/ttyUSB0
CPU?=cortex-m4
ARMGNU?=arm-none-eabi
AS=$(ARMGNU)-as

TOP:=$(dir $(lastword $(MAKEFILE_LIST)))
TESTING=$(MAKEFILE_LIST)

BOARDS=kl25z128 lm4f120 lm4f232 mk20dx256 nrf51822 stm32f051 stm32f100 stm32f103 stm32f401 stm32f407 stm32f429 tm4c1294

all: $(BOARDS)
	for d in $(BOARDS); do $(MAKE) -C $$d; done

%.bin: %.elf
	$(ARMGNU)-objcopy -Obinary $< $@

%.o: %.s
	$(AS) -I$(shell dirname $*) -o $@ $<

%.elf: %.ld %.o
	$(ARMGNU)-ld -o $@ -T $^

%.lst: %.elf
	$(ARMGNU)-objdump -D $< > $@

# only one target needs this
%.srec: %.elf
	$(ARMGNU)-objcopy -Osrec $< $@

%.hex: %.elf
	$(ARMGNU)-objcopy -Oihex $< $@

clean:
	rm -f */*.{bin,hex,o,elf,lst}

me4up:
	$(CC) -O3 -std=c99 -o $(TOP)me4up $(TOP)me4up.c

# FIXME upload with one command rather than calling me4up multiple times.
%.4th:
	@$(TOP)me4up -d $(TERMPORT) $@

serial: $(TOP)me4up
	picocom --send-cmd "$(TOP)me4up" --omap delbs --emap bsdel --imap lfcrlf -l -b 115200 -p n -d 8 $(TERMPORT)

.PHONY: all clean me4up serial
