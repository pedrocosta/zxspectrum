; -----------------------------------------------------
; Prints a BCD number on the screen.
; Input: B -> BCD number to be printed.
; Alters the value of the AF register.
; ----------------------------------------------------- 
org $8000
    call 3503  ; Call ROM CLS routine

PrintBCD:
    ld   b, $74
    ld   a, b   ; Loads in A the number to print
    and  $f0    ; Keeps the upper nibble
    rrca
    rrca
    rrca
    rrca        ; Rotates it four times to move it to the lower nibble
    add  a, '0' ; Adds the ASCII of the 0 to get the ASCII of the number
    rst  $10    ; Display the number on the screen (ZX Spectrum)
    ld   a, b   ; Loads in A the number to print
    and  $0f    ; Keeps the bottom nibble
    add  a, '0' ; Adds the ASCII of the 0 to get the ASCII of the number
    rst  $10    ; Display the number on the screen (ZX Spectrum)
    ret         ; Exits

END $8000