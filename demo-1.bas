100 printchr$(147);
105 i0$=chr$(146):  rem inverse off
110 i1$ =chr$(18) : rem inverse on
120 for i=64 to 95:a$=a$+chr$(i):next
130 for i=32 to 63:a$=a$+chr$(i):next
140 for i=96 to127:a$=a$+chr$(i):next
150 for i=160to191:a$=a$+chr$(i):next
200 print i0$+a$:print i1$+a$
300 for i=0 to 127:poke 1384+i,i:next
310 for i=128to255:poke 1416+i,i:next
320 goto 320
