TERMPORT?=/dev/ttyUSB0

CPU?=cortex-m4
ARMGNU?=arm-none-eabi

COPS=-Wall -Os -nostdlib -nostartfiles -ffreestanding -save-temps
AOPS=--warn --fatal-warnings

all: %.hex

# -mcpu=$(CPU)
%.o: %.s
	$(ARMGNU)-as $(ASMFLAGS) -o $@ $<

%.elf: %.ld %.o
	$(ARMGNU)-ld -o $@ -T $^

%.bin: %.elf
	$(ARMGNU)-objcopy -Obinary $< $@

%.lst: %.elf
	$(ARMGNU)-objdump -D $< >$@

%.hex: %.elf
	$(ARMGNU)-objcopy -Oihex $< $@

clean:
	rm -f *.bin *.hex *.o *.elf *.lst

me4up:
	$(CC) -o $(shell pwd)/me4up $(shell pwd)/me4up.c

serial: me4up
	picocom --send-cmd "$(shell pwd)/me4up" --omap delbs --emap bsdel --imap lfcrlf -l -b 115200 -p n -d 8 $(TERMPORT)

