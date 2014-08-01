
MEMORY
{
   rom(RX)   : ORIGIN = 0x00000000, LENGTH = 256K   /* 0x40000 */
   ram(WAIL) : ORIGIN = 0x1FFF8000, LENGTH = 64K    /* */
}

SECTIONS
{
   .text : { *(.text*) } > rom
   .bss  : { *(.bss*) } > ram
}

