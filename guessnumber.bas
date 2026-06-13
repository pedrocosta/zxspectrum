10 REM Guess a number
20 CLS: RANDOMIZE
30 LET n=INT (RND * 9)+1 : LET t=1
100 INPUT "Guess a number from 1 to 9", g
120 PRINT "Your guess is "; g
130 IF g<n THEN PRINT "The number is bigger"
140 IF g>n THEN PRINT "The number is smaller"
150 IF g=n THEN GO TO 200
160 LET t=t+1: GO TO 100
200 PRINT "You won in "; t; " turns"
