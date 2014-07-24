@
@    Mecrisp-Stellaris - A native code Forth implementation for ARM-Cortex M microcontrollers
@    Copyright (C) 2013  Matthias Koch
@
@    This program is free software: you can redistribute it and/or modify
@    it under the terms of the GNU General Public License as published by
@    the Free Software Foundation, either version 3 of the License, or
@    (at your option) any later version.
@
@    This program is distributed in the hope that it will be useful,
@    but WITHOUT ANY WARRANTY; without even the implied warranty of
@    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
@    GNU General Public License for more details.
@
@    You should have received a copy of the GNU General Public License
@    along with this program.  If not, see <http://www.gnu.org/licenses/>.
@

@ -----------------------------------------------------------------------------
@ Interruptvektortabelle
@ -----------------------------------------------------------------------------

.equ addresszero, . @ This is needed to circumvent address relocation issues.

.word   returnstackanfang  @ 00: Stack top address
.word   Reset+1            @ 01: Reset Vector  +1 wegen des Thumb-Einsprunges

@ Gemeinsame Interruptvektortabelle: Common interrupt vector table:

.word nullhandler+1   @ 02: The NMI handler
.word nullhandler+1   @ 03: The hard fault handler
.word 0               @ 04: The MPU fault handler
.word 0               @ 05: Reserved
.word 0               @ 06: Reserved
.word 0               @ 07: Reserved
.word 0               @ 08: Reserved
.word 0               @ 09: Reserved
.word 0               @ 10: Reserved
.word nullhandler+1   @ 11: SVCall handler
.word 0               @ 12: Reserved
.word 0               @ 13: Reserved
.word nullhandler+1   @ 14: The PendSV handler
.word irq_vektor_systick+1   @ 15: The SysTick handler

@ Bis hierhin ist die Interruptvektortabelle bei allen ARM Cortex M0 Chips gleich.
@ Danach geht es mit den Besonderheiten eines jeden Chips los.

@ Special interrupt handlers for this particular chip:

.word nullhandler+1 @ DMA Channel 0 Transfer Complete and Error
.word nullhandler+1 @ DMA Channel 1 Transfer Complete and Error
.word nullhandler+1 @ DMA Channel 2 Transfer Complete and Error
.word nullhandler+1 @ DMA Channel 3 Transfer Complete and Error
.word nullhandler+1 @ Normal Interrupt
.word nullhandler+1 @ FTFL Interrupt
.word nullhandler+1 @ PMC Interrupt
.word nullhandler+1 @ Low Leakage Wake-up
.word nullhandler+1 @ I2C0 interrupt
.word nullhandler+1 @ I2C1 interrupt
.word nullhandler+1 @ SPI0 Interrupt
.word nullhandler+1 @ SPI1 Interrupt
.word nullhandler+1 @ UART0 Status and Error interrupt
.word nullhandler+1 @ UART1 Status and Error interrupt
.word nullhandler+1 @ UART2 Status and Error interrupt
.word irq_vektor_adc+1 @ ADC0 interrupt
.word irq_vektor_cmp+1 @ CMP0 interrupt
.word nullhandler+1 @ FTM0 fault, overflow and channels interrupt
.word nullhandler+1 @ FTM1 fault, overflow and channels interrupt
.word nullhandler+1 @ FTM2 fault, overflow and channels interrupt
.word nullhandler+1 @ RTC Alarm interrupt
.word nullhandler+1 @ RTC Seconds interrupt
.word nullhandler+1 @ PIT timer all channels interrupt
.word nullhandler+1 @ Reserved interrupt 39/23
.word nullhandler+1 @ USB interrupt
.word irq_vektor_dac+1 @ DAC0 interrupt
.word nullhandler+1 @ TSI0 Interrupt
.word nullhandler+1 @ MCG Interrupt
.word nullhandler+1 @ LPTimer interrupt
.word nullhandler+1 @ Reserved interrupt 45/29
.word irq_vektor_porta+1 @ Port A interrupt
.word irq_vektor_portd+1 @ Port D interrupt

@ See page 53 in manual

@  VECTORS (rx)      : ORIGIN = 0x0,         LENGTH = 0x00c0
@  FLASHCFG (rx)     : ORIGIN = 0x00000400,  LENGTH = 0x00000010
@  FLASH (rx)        : ORIGIN = 0x00000410,  LENGTH = 128K - 0x410
@  RAM  (rwx)        : ORIGIN = 0x1FFFF000,  LENGTH = 16K


@ Flash configuration field (loaded into flash memory at 0x400)
.org 0x400, 0xFFFFFFFF @ Advance to Flash Configuration Field (FCF)
.org 0x410, 0xFFFFFFFF @ Fill this field with FF to have Reset Pin enabled.

@ Start for real code !

@ -----------------------------------------------------------------------------
unhandled:
  push {lr} 
  writeln "Unhandled Interrupt !"
  pop {pc}
@ -----------------------------------------------------------------------------
