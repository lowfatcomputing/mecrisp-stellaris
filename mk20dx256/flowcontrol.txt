\ This file sets up software flow control

: Xon $11 emit ;
: Xoff $13 emit ;

\ This version flashes the led which is handy to ensure buffered IO is
\ still flowing, but requires that the led.txt file is already compiled
\ : prompt ( -- ) begin led-off xon query xoff led-on interpret ." ok." cr again ; 

: prompt ( -- ) begin xon query xoff interpret ." ok." cr again ; 
: flowcontrol  ['] prompt hook-quit ! quit ;


