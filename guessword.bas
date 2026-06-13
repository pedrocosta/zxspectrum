10 REM Guess the word
20 INPUT "Enter the word: ", w$
30 LET g$=w$: FOR i=1 TO LEN (g$): LET g$(i)="-": NEXT i
40 LET t=0: LET u$="": CLS 
100 PRINT " Word: "; g$: PRINT "Turns: "; t: PRINT " Used: "; u$
110 INPUT "Enter a letter (empty to exit): "; l$
115 IF l$="" THEN STOP 
120 IF LEN (l$)<>1 THEN PRINT "Enter only ONE letter": GO TO 110
130 FOR i=1 TO LEN (w$)
135 IF w$(i)=l$(1) THEN LET g$(i)=l$(1)
140 NEXT i
150 LET t=t+1: LET u$=u$ + l$(1)
160 IF w$=g$ THEN GO TO 200
170 GO TO 100
200 PRINT "You won in "; t; " turns, the word was: "; w$
