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
.word   Reset+1            @ 01: Reset Vector  +1 wegen des Thumb-Einsprunges (because of thumb2 mode)

@ Gemeinsame Interruptvektortabelle: Common interrupt vector table:

.word nullhandler+1   @ 02: The NMI handler
.word nullhandler+1   @ 03: The hard fault handler
.word nullhandler+1   @ 04: The MPU fault handler
.word nullhandler+1   @ 05: ARM: Bus Fault
.word nullhandler+1   @ 06: ARM: Usage Fault
.word 0               @ 07: Reserved
.word 0               @ 08: Reserved
.word 0               @ 09: Reserved
.word 0               @ 10: Reserved
.word nullhandler+1   @ 11: SVCall handler
.word nullhandler+1   @ 12: Debug Monitor
.word 0               @ 13: Reserved
.word nullhandler+1   @ 14: The PendSV handler
.word irq_vektor_systick+1   @ 15: The SysTick handler

@ Bis hierhin ist die Interruptvektortabelle bei allen ARM Cortex M0 Chips gleich.
@ Danach geht es mit den Besonderheiten eines jeden Chips los.

@ Up to this point the interrupt vector is the same forall ARM Cortex M0 chips
@ Special interrupt handlers for this particular chip:

.word nullhandler+1  @ DMA Channel 0 Transfer Complete and Error
.word nullhandler+1  @ DMA Channel 1 Transfer Complete and Error
.word nullhandler+1  @ DMA Channel 2 Transfer Complete and Error
.word nullhandler+1  @ DMA Channel 3 Transfer Complete and Error
.word irq_vektor_dma_ch4+1  @ DMA Channel 4 Transfer Complete and Error
@.word irq_vektor_dma_ch5+1  @ DMA Channel 5 Transfer Complete and Error
.word nullhandler+1  @ DMA Channel 5 Transfer Complete and Error
.word nullhandler+1  @ DMA Channel 6 Transfer Complete and Error
.word nullhandler+1  @ DMA Channel 7 Transfer Complete and Error
.word nullhandler+1  @ DMA Channel 8 Transfer Complete and Error
.word nullhandler+1  @ DMA Channel 9 Transfer Complete and Error
.word nullhandler+1 @ DMA Channel 10 Transfer Complete and Error
.word nullhandler+1 @ DMA Channel 11 Transfer Complete and Error
.word nullhandler+1 @ DMA Channel 12 Transfer Complete and Error
.word nullhandler+1 @ DMA Channel 13 Transfer Complete and Error
.word nullhandler+1 @ DMA Channel 14 Transfer Complete and Error
.word nullhandler+1 @ DMA Channel 15 Transfer Complete and Error
.word nullhandler+1 @ DMA Channel 16 Transfer Complete and Error
.word 0             @ 17: Reserved
.word nullhandler+1 @ 18:  Flash memory command complete
.word nullhandler+1 @ 19:  Flash memory Read collision
.word nullhandler+1 @ 20:  Mode controller low-voltage
.word nullhandler+1 @ 21:  Low Leakage Wakeup
.word nullhandler+1 @ 22: Watchdog
.word 0             @ 23: Reserved
.word nullhandler+1 @ 24: I2c0
.word nullhandler+1 @ 25: I2C1
.word nullhandler+1 @ 26 SPIO0
.word nullhandler+1 @ 27 SPIO1
.word 0             @ 28 reserved
.word nullhandler+1 @ 29 CAN0 Or'ed Message Buffer
.word nullhandler+1 @ 30 CAN0 Buss Off
.word nullhandler+1 @ 31 CAN0 Error
.word nullhandler+1 @ 32 CAN0 Transmit Warning
.word nullhandler+1 @ 33 CAN0 Receive Warning
.word nullhandler+1 @ 34 CAN0 Wake up
.word nullhandler+1 @ 35 I2S0 Transmit
.word nullhandler+1 @ 36 I2S0 Receive
.word 0             @ 37 Reserved
.word 0             @ 38 Reserved
.word 0             @ 39 Reserved
.word 0             @ 40 Reserved
.word 0             @ 41 Reserved
.word 0             @ 42 Reserved
.word 0             @ 43 Reserved
.word nullhandler+1 @ 44 UART0 LON sources
.word irq_vektor_UART0S+1 @ 45 UART0 Status sources
.word irq_vektor_UART0E+1 @ 46 UART0 Error sources
.word nullhandler+1 @ 47 UART1 status sources
.word nullhandler+1 @ 48 UART1 Error sources
.word nullhandler+1 @ 49 UART2 Status
.word nullhandler+1 @ 50 UART2 Error
.word 0             @ 51 Reserved
.word 0             @ 52 Reserved
.word 0             @ 53 Reserved
.word 0             @ 54 Reserved
.word 0             @ 55 Reserved
.word 0             @ 56 Reserved
.word irq_vektor_adc0+1 @ 57 ADC0 interrupt
.word irq_vektor_adc1+1 @ 58 ADC1 interrupt
.word irq_vektor_cmp0+1 @ 59 CMP0 interrutp
.word irq_vektor_cmp1+1 @ 60 CMP1 interrutp
.word irq_vektor_cmp2+1 @ 61 CMP2 interrupt
.word nullhandler+1 @ 62 FTM0 fault, overflow and channels interrupt
.word nullhandler+1 @ 63 FTM1 fault, overflow and channels interrupt
.word nullhandler+1 @ 64 FTM2 fault, overflow and channels interrupt
.word nullhandler+1 @ 65 CMT
.word nullhandler+1 @ 66 RTC Alarm interrupt
.word nullhandler+1 @ 67 RTC Seconds interrupt
.word nullhandler+1 @ 68 PIT channel 0
.word nullhandler+1 @ 69 PIT channel 1
.word nullhandler+1 @ 70 PIT channel 2
.word nullhandler+1 @ 71 PIT channel 3
.word irq_vektor_pdb+1 @ 72 PDB
@.word nullhandler+1 @ 72 PDB
.word nullhandler+1 @ 73 USB OTG
.word nullhandler+1 @ 74 USB Charger detect
.word 0             @ 75 Reserved
.word 0             @ 76 Reserved
.word 0             @ 77 Reserved
.word 0             @ 78 Reserved
.word 0             @ 79 Reserved
.word 0             @ 80 Reserved
.word irq_vektor_dac+1 @ 81 DAC0 interrupt
.word 0             @ 82 Reserved
.word nullhandler+1 @ 83 TSI Interrupt
.word nullhandler+1 @ 84 MCG Interrupt
.word nullhandler+1 @ 85 Low Power PTimer interrupt
.word nullhandler+1 @ 86 Reserved interrupt 
.word irq_vektor_porta+1 @ 87 Port A interrupt
.word irq_vektor_portb+1 @ 88 Port B interrupt
.word irq_vektor_portc+1 @ 89 Port C interrupt
.word irq_vektor_portd+1 @ 90 Port D interrupt
.word irq_vektor_porte+1 @ 91 Port E interrupt
.word 0             @ 92 Reserved
.word 0             @ 93 Reserved
.word nullhandler+1 @ 94 Reserved


@ See page 53 in manual

@  VECTORS (rx)      : ORIGIN = 0x0,         LENGTH = 0x01CC
@  FLASHCFG (rx)     : ORIGIN = 0x00000400,  LENGTH = 0x00000010
@  FLASH (rx)        : ORIGIN = 0x00000410,  LENGTH = 256K - 0x410
@  RAM  (rwx)        : ORIGIN = 0x1FFF8000,  LENGTH = 64K


@ Flash configuration field (loaded into flash memory at 0x400)
.org 0x400, 0xFFFFFFFF @ Advance to Flash Configuration Field (FCF)
.org 0x404, 0xFFFFFFFF @ "
.org 0x408, 0xFFFFFFFF @ "
.org 0x40C, 0xFFFFFFFF @ "

@ Start for real code !

.org 0x410
@ -----------------------------------------------------------------------------
@unhandled:
@  push {lr} 
@  writeln "Unhandled Interrupt !"
@  pop {pc}
@ -----------------------------------------------------------------------------

