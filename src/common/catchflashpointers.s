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

@ Initialisiert die Pointer und Flash-Variablen nach dem Neustart.
@ Wird direkt eingefügt und nur einmal beim Start benutzt,
@ deshalb werden Register hier nicht gesichert. 

@ Initialises pointers and variables for flash dictionary after Reset.
@ This runs one time after Reset, no registers are saved here.

   @ Hardware sets return stack pointer on startup from vector table.
   @ Set Return stack pointer here (again) just in case this might be a software re-entry.
   ldr r0, =returnstackanfang
   mov sp, r0

   @ Return stack pointer already set up. Time to set data stack pointer !
   @ Normaler Stackpointer bereits gesetzt. Setze den Datenstackpointer:
   ldr psp, =datenstackanfang

   @ TOS setzen, um Pufferunterläufe gut erkennen zu können
   @ TOS magic number to see spurious stack underflows in .s
   @ ldr tos, =0xAFFEBEEF
   movs tos, #42

  @ Suche nun im Flash nach Anfang und Ende.
  @ Short: Search for begin and end in Flash.

   @ Dictionarypointer ins RAM setzen
   @ Set dictionary pointer into RAM first
   ldr r0, =Dictionarypointer
   ldr r1, =RamDictionaryAnfang
   str r1, [r0]

   @ Fadenende fürs RAM vorbereiten
   @ Set latest for RAM
   ldr r0, =Fadenende
   ldr r1, =CoreDictionaryAnfang
   str r1, [r0]
  
  @ Registerbelegung:  Register allocation here:
  @ r0 Adresshangelzeiger  Pointer that crawls through dictionary
  @ r1 Aktuelle Flags      Current Flags
  @ r2 Aktueller Link      Current Link

  @ r3 Für dies und das    Temporary this and that

  @ r4 SucheFadenende...   Search for end of dictionary structure

  @ r5 Belegtes Ram.       Keeps track of allocated RAM

  ldr r0, =CoreDictionaryAnfang   @ Hier fängt es an.  Start at the beginning

  ldr r5, =RamDictionaryEnde @ Fürs Abzählen des Variablenplatzes  Variables start at the end of RAM dictionary

  @ Zwei Möglichkeiten: Vorwärtslink ist $FFFFFFFF --> Ende gefunden
  @ Oder Vorwärtslink gesetzt, aber an der Stelle der Namenslänge liegt $FF. Dann ist das Ende auch da.
  @ Diese Variante tritt auf, wenn nichts hinzugetan wurde, denn im festen Teil ist der Vorwärtslink
  @ immer gesetzt und zeigt auf den Anfang des Schreib/Löschbaren Teils.

  @ There are two possibilities to detect end of dictionary:
  @ - Link is $FFFFFFFF
  @ - Link is set, but points to memory that contains $FF in name length.
  @ Last case happens if nothing is compiled yet, as the latest link in core always
  @ points to the beginning of user writeable/eraseable part of dictionary space.

  @ Dictionary entry structure:
  @ 4 Bytes Link ( 2-aligned on M3, 4-aligned on M0 )
  @ 2 Bytes Flags
  @ 1 Byte  Name length
  @         Counted Name string and sometimes a padding zero to realign.
  @         Code.

SucheFlashPointer_Hangelschleife:

  movs r4, r0 @ Es könnte das Fadenende sein !      Save current address - it might already be LATEST.
  @ Hier ist r0 direkt auf das Flagfeld gerichtet. Register r0 currently points to flag field.

  @ Adresse in r0 zeigt auf:

  @   --> Link
  ldr r2, [r0]  @ Aktuellen Link lesen   Fetch current Link
  adds r0, #4

  @   --> Flagfeld
  ldrh r1, [r0]  @ Aktuelle Flags lesen  Fetch current Flags
  adds r0, #2

  @   --> Namen   Currently, r0 points to name string.
  @ Prüfe für die Rambelegung die Flags der aktuellen Definition:

  .ifdef m0core
  ldr r3, =0xFFFF
  .else
  movw r3, #0xFFFF
  .endif

  cmp r1, r3   @ Flag_invisible ? Überspringen !  Skip invisible definitions
  beq.n Sucheflashpointer_Speicherbelegung_fertig
    @ Dies Wort ist sichtbar. Prüfe, ob es Ram-Speicher anfordert und belegt.
    @ This definition is visible. Check if it allocates RAM.

    ldr r3, =Flag_buffer
    ands r3, r1
    beq 1f @ No buffer requested.

      @ Search for end of code of current definition.
      bl skipstring
      @ r0 zeigt nun an den Codebeginn des aktuellen Wortes.  r0 points to start of code of current definition
      bl suchedefinitionsende @ Advance pointer to end of code. This is detected by "bx lr" or "pop {pc}" opcodes.
      @ r0 ist nun an der Stelle, wo die Initialisierungsdaten liegen. r0 now points to the location of the initialisation at the end of code of current definition.

      @ Fetch required length of buffer, do this in two steps because of alignment issues
      ldrh r3, [r0]
      ldrh r0, [r0, #2]
      lsls r0, #16
      orrs r3, r0
      
      @ Ramvariablenpointer wandern lassen  Subtract from the pointer that points to the next free location
      subs r5, r3  
      b.n Sucheflashpointer_Speicherbelegung_fertig @ Finished


1:  movs r3, #Flag_ramallot
    ands r3, r1
    
    beq.n Sucheflashpointer_Speicherbelegung_fertig @ Benötigt doch kein RAM.
      @ writeln "Speicher gewünscht !"
      @ Die Flags werden später nicht mehr gebraucht.
      @ This one allocates RAM, Flags are not needed anymore.

      movs r3, #0x0F @ Das unterste Nibble maskieren  Mask lower 4 bits that contains amount of 32 bit locations requested.
      ands r1, r3

        @ Bei Null Bytes brauche ich nichts zu kopieren, den Fall erkennt move.
        @ Zero byte requests are handled by move itself, no need to catch this special case. Sounds strange, but is useful to have two handles for one variable.
        lsls r1, #2 @ Mit vier malnehmen                  Multiply by 4
        subs r5, r1 @ Ramvariablenpointer wandern lassen  Subtract from the pointer that points to the next free location

        @ Den neu geschaffenen Platz initialisieren !
        @ Initialise the freshly allocated RAM locations !
        @ r0: zeigt gerade auf das Namensfeld und wird danach nicht mehr benötigt.  Points to Name and is not needed afterwards
        @ r1: enthält die Zahl der noch zu verschiebenden Bytes                     Contains number of bytes to copy/initialise
        @ r3: ist frei für uns.                                                     Free for use !
        @ r5: die Startadresse des Ram-Bereiches, der geschrieben werden soll.      Contains address in RAM the initialisation values have to be written in.

        @ Muss zuerst schaffen, das Ende der aktuellen Definition zu finden.
        @ Search for end of code of current definition.
        bl skipstring
        @ r0 zeigt nun an den Codebeginn des aktuellen Wortes.  r0 points to start of code of current definition
        bl suchedefinitionsende @ Advance pointer to end of code. This is detected by "bx lr" or "pop {pc}" opcodes.
        @ r0 ist nun an der Stelle, wo die Initialisierungsdaten liegen. r0 now points to the location of the initialisation at the end of code of current definition.
        @ Kopiere die gewünschte Zahl von r1 Bytes von [r0] an [r5]  Copy desired amount of r1 bytes from [r0] to [r5].
        pushda r0 @ Quelle  Source
        pushda r5 @ Ziel    Target
        pushda r1 @ Anzahl an Bytes  Amount
        bl move

Sucheflashpointer_Speicherbelegung_fertig:
  @ Speicherbelegung und -initialisierung abgeschlossen.
  @ Finished RAM allocation and initialisation.
  @ Prüfe den Link Check Link.
 

  adds r0, r2, #1 @ -1 +1 = 0 Ungesetzter Link bedeutet Ende erreicht  Unset Link means end of dictionary detected.
  beq.n SucheFlashPointer_Fadenende_gefunden

  @ writeln " Folge dem Link, er ist gesetzt"
  @ Dem Link folgen  Follow the link, it is set
  movs r0, r2

  @ Prüfe, ob die Namenslänge an der Stelle etwas anderes als $FF ist:
  @ Check if the name length on that location is different from $FF:
  adds r2, #6 @ Flags und Link überlesen  Skip Flags and Link
  ldrb r2, [r2]
  cmp r2, #0xFF @ Ist an der Stelle der Namenslänge $FF ? Dann ist das Fadenende erreicht.  End detected if name length is $FF.
  beq.n SucheFlashPointer_Fadenende_gefunden
  
  @ write " Namenslänge nicht $FF, weiterhangeln"  
  @ Okay, der Faden ist noch nicht am Ende. Es könnte allerdings das letzte Wort sein.
  @ Dictionary continues, end not detected yet.

  b.n SucheFlashPointer_Hangelschleife

SucheFlashPointer_Fadenende_gefunden:
  ldr r0, =ZweitFadenende
  str r4, [r0] @ Das Fadenende für den Flash setzen.  Set pointer to latest definition.

@  write "Fadenende im Flash: "
@  pushda r4
@  bl hexdot
@  writeln " gefunden."


  ldr r0, =VariablenPointer @ Set pointer to current end-of-ram-dictionary for later permanent RAM allocations by variables defined in Flash.
  str r5, [r0]

@  write "Stand des Variablenpointers: "
@  pushda r5
@  bl hexdot
@  writeln " gefunden."


  @ Mache mich auf die Suche nach dem Dictionarypointer im Flash:
  @ Suche jetzt gleich noch den DictionaryPointer.
  @ Time to search the Dictionarypointer !

  ldr r0, =FlashDictionaryEnde
  ldr r1, =FlashDictionaryAnfang
  ldr r2, =0xffff

  @ Gehe Rückwärts, bis ich aus dem $FFFF-Freigebiet in Daten komme.
  @ Run backwards through whole Flash memory to find DictionaryPointer.
1:cmp r0, r1 @  Wenn ich am Anfang angelangt bin, ist das der DictionaryPointer.
  beq.n 2f     @  Finished if beginning of Flash is hit.

  subs r0, #2
  ldrh r3, [r0]
  cmp r3, r2 @ 0xFFFF
  beq.n 1b @ Wenn es nicht gleich ist, habe ich eine Füllung gefunden.
           @ If there is not $FFFF on that location I have found "end of free space".

  adds r0, #2

2:@ Dictionarypointer gefunden. Found DictionaryPointer.
  ldr r1, =ZweitDictionaryPointer @ We start to compile into RAM - the pointer found goes to the second set of pointers that are swapped with compiletoflash/compiletoram.
  str r0, [r1]

@  write "Dictionarypointer im Flash: "
@  pushda r0
@  bl hexdot
@  writeln " gefunden."

  .ifdef emulated16bitflashwrites
   @ Prepare 16-Bit Flash write emulation value-and-location collection table
   bl sammeltabelleleeren
  .endif
