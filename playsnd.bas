10 PRINT "LOADING PLAYSND.BIN"
20 LOADM "PLAYSND.BIN"

30 DIM MO$(10)
40 DIM FI$(10)

100 I=1
110 READ M$, N$
120 IF M$="END" AND N$="END" THEN GOTO 200
130 PRINT I;": ";M$
140 MO$(I)=N$
150 I=I+1
160 GOTO 110

200 INPUT"DRIVEWIRE TYPE";T
210 IF T>=I THEN GOTO 200
220 M$=MO$(T)
220 PRINT "LOADING ";M$
230 LOADM M$

300 I=1
310 READ F$
320 IF F$="END" THEN GOTO 400
330 PRINT I;": ";F$
340 FI$(I)=F$
350 I=I+1
360 GOTO 310

400 INPUT"SELECT FILE";F
410 IF F>=I THEN GOTO 400
420 A$=FI$(F)
430 PRINT "PLAYING ";A$
440 GOSUB 1000
450 GOTO 400


1000 L=LEN(A$)
1010 POKE &H3020,L
1020 FOR I=1TOL
1030 C$=MID$(A$,I,1)
1040 POKE &H3020+I, ASC(C$)
1050 NEXT I
1060 EXEC &H3000
1070 RETURN 

2000 DATA "COCO 2/3 BIT BANGER", "DWSMCC23.BIN"
2010 DATA "COCO 1 BIT BANGER", "DWSMCC1.BIN"
2010 DATA "RS232-PAK", "DWSM232.BIN"
2010 DATA "BECKER PORT", "DWSMBCK.BIN"
2020 DATA "END", "END"

3000 DATA "/usr/share/sounds/alsa/Front_Center.wav"
3010 DATA "C:\Users\Administrator\Downloads\tada.wav"
3020 DATA "END"

