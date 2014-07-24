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

serial:
	picocom --omap delbs --emap bsdel --imap lfcrlf -l -b 115200 -p n -d 8 $(TERMPORT)

