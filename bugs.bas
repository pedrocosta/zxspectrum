10 REM Space bug hunt by JJM and VMP. Use 1 to 8 to squash bugs!
15 RANDOMIZE
20 REM Load bug graphic
30 RESTORE 50
40 FOR i=0 TO 7: READ b: POKE USR "E"+i,b: NEXT i
50 DATA 32, 24, 165, 90, 90, 165, 24, 32
60 REM Bug placing functions
70 DEF FN x(n)=16+6*SIN (n/4*PI)
80 DEF FN y(n)=10-6*COS (n/4*PI)
90 REM Draw bug radar
100 PAPER 0: BORDER 0: CLS
110 INK 5: CIRCLE 130, 92, 70: CIRCLE 130, 92, 20: INK 3
120 FOR n=1 TO 8
130 PRINT AT 10-10*COS (n/4*PI),16+10*SIN (n/4*PI); n
140 NEXT n
150 LET score=0
200 REM Main loop (number of bugs)
220 FOR c=1 TO 10
225 REM Random pause
230 FOR i=0 TO INT (RND*300) +10: NEXT i
240 REM Quadrant to have the bug
250 LET q=INT (RND*8)+1
260 INK 2: PRINT AT FN y (q), FN x (q); "{E}"
265 REM Read input (smaller number for a harder game)
270 FOR i=0 TO 120
280 LET r$=INKEY$
285 IF r$<>"" THEN GO TO 295
290 NEXT i
295 REM Did we kill the bug?
300 IF VAL ("0"+r$)<>q THEN BORDER 2: BEEP .2,-30: BORDER 0: GO TO 320
305 REM Yes! Add score
310 LET score=score+1: BEEP .1,10: BEEP 0.1,20
315 REM Erase the bug
320 PRINT AT FN y (q), FN x (q); " "
330 NEXT c
335 REM End of game
340 CLS: INK 7: PRINT "You squashed "; score; " bugs!"
350 FOR i=0 TO 200: NEXT i: REM to let the user see the message
360 INPUT "Play again? (y/n)", r$
370 IF r$="y" THEN GO TO 100
