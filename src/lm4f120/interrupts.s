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

@ Routinen für die Interrupthandler, die zur Laufzeit neu gesetzt werden können.
@ Code for interrupt handlers that are exchangeable on the fly

@ -----------------------------------------------------------------------------
  Wortbirne Flag_inline, "eint" @ ( -- ) Aktiviert Interrupts  Enables Interrupts
@ ----------------------------------------------------------------------------- 
  cpsie i @ Interrupt-Handler
 @ cpsie f @ Fehler-Handler  Error Handler
  bx lr

@ -----------------------------------------------------------------------------
  Wortbirne Flag_inline, "dint" @ ( -- ) Deaktiviert Interrupts  Disables Interrupts
@ ----------------------------------------------------------------------------- 
  cpsid i @ Interrupt-Handler
 @ cpsid f @ Fehler-Handler
  bx lr

@ -----------------------------------------------------------------------------
  Wortbirne Flag_visible, "nop" @ ( -- ) Handler für unbenutzte Interrupts
nop_vektor:                     @        Handler for unused Interrupts
@ ----------------------------------------------------------------------------- 
  bx lr


@------------------------------------------------------------------------------
@ Alle Interrupthandler funktionieren gleich und werden komfortabel mit einem Makro erzeugt:
@ All interrupt handlers work the same way and are generated with a macro:
@------------------------------------------------------------------------------
interrupt systick
initinterrupt fault, nullhandler, unhandled

interrupt terminal
interrupt porta
interrupt portb
interrupt portc
interrupt portd
interrupt porte
interrupt portf
interrupt adc0seq0
interrupt adc0seq1
interrupt adc0seq2
interrupt adc0seq3
interrupt timer0a
interrupt timer0b
interrupt timer1a
interrupt timer1b
interrupt timer2a
interrupt timer2b
@------------------------------------------------------------------------------

/*
  Zu den Registern, die gesichert werden müssen:  Register map and interrupt entry push sequence:
  r 0  Wird von IRQ-Einsprung gesichert  Saved by IRQ entry
  r 1  Wird von IRQ-Einsprung gesichert  Saved by IRQ entry
  r 2  Wird von IRQ-Einsprung gesichert  Saved by IRQ entry
  r 3  Wird von IRQ-Einsprung gesichert  Saved by IRQ entry

  r 4    Schleifenindex und Arbeitsregister, wird vor Benutzung gesichert  Is saved by code for every usage
  r 5    Schleifenlimit und Arbeitsregister, wird vor Benutzung gesichert  Is saved by code for every usage
  r 6  TOS - müsste eigentlich von sich aus funktionieren                  No need to save TOS
  r 7  PSP - müsste eigentlich von sich aus funktionieren                  No need to save PSP

  r 8  Unbenutzt  Unused
  r 9  Unbenutzt  Unused
  r 10 Unbenutzt  Unused
  r 11 Unbenutzt  Unused
  r 12 Unbenutzt, wird von IRQ-Einsprung gesichert  Unused, but saved by IRQ entry

  r 13 = sp
  r 14 = lr
  r 15 = pc
*/
