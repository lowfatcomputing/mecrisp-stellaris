
\ ------------------------------
\  Manual trigger oscilloscope
\ ------------------------------

\  needs oscilloscope.4th, plotbuffer.4th

: manual-oscilloscope ( -- )
  init-capture
  cr ." Press a key to sample - ESC to quit" cr

  begin
    start
      begin key? until
    stop
  key 27 <> while
    plotwave cr
  repeat

  close-capture
;
