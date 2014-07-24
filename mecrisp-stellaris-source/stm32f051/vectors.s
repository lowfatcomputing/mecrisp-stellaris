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

.word nullhandler+1 @ Position  0: Window Watchdog
.word nullhandler+1 @ Position  1: PVD through EXTI line detection
.word nullhandler+1 @ Position  2: RTC Wakeup
.word nullhandler+1 @ Position  3: Flash
.word nullhandler+1 @ Position  4: RCC
.word irq_vektor_exti0_1+1  @ Position  5: EXTI Line 0 - 1
.word irq_vektor_exti2_3+1  @ Position  6: EXTI Line 2 - 3
.word irq_vektor_exti4_15+1 @ Position  7: EXTI Line 4 - 15
.word nullhandler+1 @ Position  8: Touch sensing
.word nullhandler+1 @ Position  9: DMA
.word nullhandler+1 @ Position 10: DMA
.word nullhandler+1 @ Position 11: DMA
.word irq_vektor_adc+1     @ Position 12: ADC and Comp interrupts
.word irq_vektor_tim1_up+1 @ Position 13: Timer 1 Break & Update
.word irq_vektor_tim1_cc+1 @ Position 14: Timer 1 Capture & Compare
.word irq_vektor_tim2+1    @ Position 15: Timer 2 global
.word irq_vektor_tim3+1    @ Position 16: Timer 3 global

@ Much more ! 

@ -----------------------------------------------------------------------------
unhandled:
  push {lr} 
  writeln "Unhandled Interrupt !"
  pop {pc}
@ -----------------------------------------------------------------------------
