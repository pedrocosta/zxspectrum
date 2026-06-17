org 30000

; We want a black screen.

       ld a,71             ; white ink (7) on black paper (0),
                           ; bright (64).
       ld (23693),a        ; set our screen colours.
       xor a               ; quick way to load accumulator with zero.
       call 8859           ; set permanent border colours.

; Set up the graphics.

       ld hl,blocks        ; address of user-defined graphics data.
       ld (23675),hl       ; make UDGs point to it.

; Okay, let's start the game.

       call 3503           ; ROM routine - clears screen, opens chan 2.

; Initialise coordinates.

       ld hl,21+15*256     ; load hl pair with starting coords.
       ld (plx),hl         ; set player coords.

       call basexy         ; set the x and y positions of the player.
       call splayr         ; show player base symbol.

; This is the main loop.

mloop  equ $

; Delete the player.

       call basexy         ; set the x and y positions of the player.
       call wspace         ; display space over player.

; Now we've deleted the player we can move him before redisplaying him
; at his new coordinates.

       ld bc,57342         ; keyboard row y-o.
       in a,(c)            ; see what keys are pressed.
       rra                 ; outermost bit = key p.
       push af             ; remember the value.
       call nc,mpr         ; it's being pressed, move right.
       pop af              ; restore accumulator.
       rra                 ; next bit along (value 2) = key o.
       call nc,mpl         ; being pressed, so move left.
       ld bc, 65022        ; keyboard row a-g.
       in a,(c)            ; see what keys are pressed.
       rra                 ; outermost bit = key a.
       call nc,mpd         ; being pressed, so move down.
       ld bc, 64510        ; keyboard row q-t.
       in a,(c)            ; see what keys are pressed.
       rra                 ; outermost bit = key q.
       call nc,mpu         ; it's being pressed, move up.

; Now he's moved we can redisplay the player.

       call basexy         ; set the x and y positions of the player.
       call splayr         ; show player.

       halt                ; delay.

; Jump back to beginning of main loop.

       jp mloop

; Move player left.

mpl    ld hl,ply           ; remember, y is the horizontal coord!
       ld a,(hl)           ; what's the current value?
       and a               ; is it zero?
       ret z               ; yes - we can't go any further left.
       dec (hl)            ; subtract 1 from y coordinate.
       ret

; Move player right.

mpr    ld hl,ply           ; remember, y is the horizontal coord!
       ld a,(hl)           ; what's the current value?
       cp 31               ; is it at the right edge (31)?
       ret z               ; yes - we can't go any further left.
       inc (hl)            ; add 1 to y coordinate.
       ret

; Move player up.

mpu    ld hl,plx           ; remember, x is the vertical coord!
       ld a,(hl)           ; what's the current value?
       cp 4                ; is it at upper limit (4)?
       ret z               ; yes - we can go no further then.
       dec (hl)            ; subtract 1 from x coordinate.
       ret

; Move player down.

mpd    ld hl,plx           ; remember, x is the vertical coord!
       ld a,(hl)           ; what's the current value?
       cp 21               ; is it already at the bottom (21)?
       ret z               ; yes - we can't go down any more.
       inc (hl)            ; add 1 to x coordinate.
       ret

; Set up the x and y coordinates for the player's gunbase position,
; this routine is called prior to display and deletion of gunbase.

basexy ld a,22             ; AT code.
       rst 16
       ld a,(plx)          ; player vertical coord.
       rst 16              ; set vertical position of player.
       ld a,(ply)          ; player's horizontal position.
       rst 16              ; set the horizontal coord.
       ret

; Show player at current print position.

splayr ld a,69             ; cyan ink (5) on black paper (0),
                           ; bright (64).
       ld (23695),a        ; set our temporary screen colours.
       ld a,144            ; ASCII code for User Defined Graphic 'A'.
       rst 16              ; draw player.
       ret

wspace ld a,71             ; white ink (7) on black paper (0),
                           ; bright (64).
       ld (23695),a        ; set our temporary screen colours.
       ld a,32             ; SPACE character.
       rst 16              ; display space.
       ret

plx    defb 0              ; player's x coordinate.
ply    defb 0              ; player's y coordinate.

; UDG graphics.

blocks defb $30,$78,$33,$7E,$B0,$38,$68,$4C    ; player base.

end 30000
