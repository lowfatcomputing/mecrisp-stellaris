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

.word   returnstackanfang  @ 00: Stack top address
.word   Reset+1            @ 01: Reset Vector  +1 wegen des Thumb-Einsprunges

@ Gemeinsame Interruptvektortabelle: Common interrupt vector table:

.word nullhandler+1   @ 02: The NMI handler
.word nullhandler+1   @ 03: The hard fault handler
.word nullhandler+1   @ 04: The MPU fault handler
.word nullhandler+1   @ 05: The bus fault handler
.word nullhandler+1   @ 06: The usage fault handler
.word 0               @ 07: Reserved
.word 0               @ 08: Reserved
.word 0               @ 09: Reserved
.word 0               @ 10: Reserved
.word nullhandler+1   @ 11: SVCall handler
.word nullhandler+1   @ 12: Debug monitor handler
.word 0               @ 13: Reserved
.word nullhandler+1   @ 14: The PendSV handler
.word irq_vektor_systick+1   @ 15: The SysTick handler

@ Bis hierhin ist die Interruptvektortabelle bei allen ARM Cortex Chips gleich.
@ Danach geht es mit den Besonderheiten eines jeden Chips los.

@ Special interrupt handlers for this particular chip:

.word irq_vektor_porta+1   @ 16: GPIO Port A
.word irq_vektor_portb+1   @ 17: GPIO Port B
.word irq_vektor_portc+1   @ 18: GPIO Port C
.word irq_vektor_portd+1   @ 19: GPIO Port D
.word irq_vektor_porte+1   @ 20: GPIO Port E

.word irq_vektor_terminal+1   @ 21: UART0 Rx and Tx
.word nullhandler+1   @ 22: UART1 Rx and Tx
.word nullhandler+1   @ 23: SSI0 Rx and Tx
.word nullhandler+1   @ 24: I2C0 Master and Slave
.word nullhandler+1   @ 25: PWM Fault
.word nullhandler+1   @ 26: PWM Generator 0
.word nullhandler+1   @ 27: PWM Generator 1
.word nullhandler+1   @ 28: PWM Generator 2
.word nullhandler+1   @ 29: QEI0

.word irq_vektor_adc0seq0+1   @ 30: ADC 0 Sequence 0
.word irq_vektor_adc0seq1+1   @ 31: ADC 0 Sequence 1
.word irq_vektor_adc0seq2+1   @ 32: ADC 0 Sequence 2
.word irq_vektor_adc0seq3+1   @ 33: ADC 0 Sequence 3

.word nullhandler+1   @ 34: Watchdog timers 0 and 1

.word irq_vektor_timer0a+1   @ 35: Timer 0 subtimer A
.word irq_vektor_timer0b+1   @ 36: Timer 0 subtimer B
.word irq_vektor_timer1a+1   @ 37: Timer 1 subtimer A
.word irq_vektor_timer1b+1   @ 38: Timer 1 subtimer B
.word irq_vektor_timer2a+1   @ 39: Timer 2 subtimer A
.word irq_vektor_timer2b+1   @ 40: Timer 2 subtimer B

.word nullhandler+1   @ 41: Analog Comparator 0
.word nullhandler+1   @ 42: Analog Comparator 1
.word nullhandler+1   @ 43: Analog Comparator 2
.word nullhandler+1   @ 44: System Control (PLL, OSC, BO)
.word nullhandler+1   @ 45: FLASH Control

.word irq_vektor_portf+1   @ 46: GPIO Port F
.word irq_vektor_portg+1   @ 47: GPIO Port G
.word irq_vektor_porth+1   @ 48: GPIO Port H

.word nullhandler+1   @ 49: UART 2
.word nullhandler+1   @ 50: SSI1

.word irq_vektor_timer3a+1   @ 51: Timer 3 subtimer A
.word irq_vektor_timer3b+1   @ 52: Timer 3 subtimer B

.word nullhandler+1   @ 53: I2C 1
.word nullhandler+1   @ 54: CAN 0
.word nullhandler+1   @ 55: CAN 1

.word irq_vektor_ethernet+1   @ 56: Ethernet MAC

.word nullhandler+1   @ 57: HIB
.word nullhandler+1   @ 58: USB MAC
.word nullhandler+1   @ 59: PWM Generator 3
.word nullhandler+1   @ 60: uDMA Software
.word nullhandler+1   @ 61: uDMA Error

.word irq_vektor_adc1seq0+1   @ 62: ADC 1 Sequence 0
.word irq_vektor_adc1seq1+1   @ 63: ADC 1 Sequence 1
.word irq_vektor_adc1seq2+1   @ 64: ADC 1 Sequence 2
.word irq_vektor_adc1seq3+1   @ 65: ADC 1 Sequence 3

.word nullhandler+1   @ 66: EPI 0

.word irq_vektor_portj+1   @ 67: GPIO Port J
.word irq_vektor_portk+1   @ 68: GPIO Port K
.word irq_vektor_portl+1   @ 69: GPIO Port L

@ ... Das geht noch viel weiter ! Erstmal jedoch eine Grundausstattung an Bord. Siehe Datenblatt Seite 114.


@ -----------------------------------------------------------------------------
unhandled:
  push {lr} 
  writeln "Unhandled Interrupt !"
  pop {pc}
@ -----------------------------------------------------------------------------
