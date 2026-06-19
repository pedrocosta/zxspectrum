org 32768

start:
    ld hl, 16384
    ld de, 16385
    ld bc, 6143
    ld (hl), 0
    ldir
    ld hl, 22528
    ld de, 22529
    ld bc, 767
    ld (hl), 0x07           
    ldir
    xor a
    out (254), a
    ld a, 2
    call 0x1601             
    ld hl, cowboy_sprite    
    ld (23675), hl          

    ld a, 19
    rst 16
    ld a, 1
    rst 16

    ld a, 16
    rst 16
    ld a, 4
    rst 16
    ld a, 17
    rst 16
    ld a, 0
    rst 16

    ld d, 4
    ld e, 4
    ld b, 24
draw_top_cacti:
    push bc
    ld c, 146
    call print_at
    inc e
    pop bc
    djnz draw_top_cacti

    ld d, 16
    ld e, 4
    ld b, 24
draw_bottom_cacti:
    push bc
    ld c, 146
    call print_at
    inc e
    pop bc
    djnz draw_bottom_cacti

    ld a, 16
    rst 16
    ld a, 6
    rst 16
    ld d, 10
    ld e, 10
    ld hl, txt_title
    call print_string

    ld a, 16
    rst 16
    ld a, 5
    rst 16
    ld d, 13
    ld e, 6
    ld hl, txt_press_space
    call print_string

splash_music_start:
    ld hl, melody_data
splash_music_loop:
    ld a, (hl)
    and a
    jp z, splash_music_start
    ld b, a
    inc hl
    ld d, (hl)
    inc hl
    ld e, (hl)
    inc hl
    push hl
    ld h, b
    call play_note
    pop hl
    jp c, wait_space_release
    jp splash_music_loop

wait_space_release:
    ld bc, 0x7ffe
    in a, (c)
    rrca
    jp nc, wait_space_release

init_game:
    ld hl, 16384
    ld de, 16385
    ld bc, 6143
    ld (hl), 0
    ldir
    ld hl, 22528
    ld de, 22529
    ld bc, 767
    ld (hl), 0x07           
    ldir
    xor a
    out (254), a

    ld a, 19
    rst 16
    ld a, 1
    rst 16
    ld a, 17
    rst 16
    ld a, 0
    rst 16

    ld a, 16
    rst 16
    ld a, 7
    rst 16

    ld a, '0'
    ld (score_tens), a
    ld (score_units), a
    
    ld d, 21
    ld e, 11
    ld c, 'S'
    call print_at
    ld e, 12
    ld c, 'C'
    call print_at
    ld e, 13
    ld c, 'O'
    call print_at
    ld e, 14
    ld c, 'R'
    call print_at
    ld e, 15
    ld c, 'E'
    call print_at
    ld e, 16
    ld c, ':'
    call print_at
    call update_score_display

    call init_obstacles

    ld a, 0
    ld (player_x), a        
    ld a, 10
    ld (player_y), a        
    ld a, 31
    ld (bandit_x), a        
    ld a, 10
    ld (bandit_y), a        
    ld a, 0
    ld (bullet_active), a   
    ld (b_bullet_active), a 
    ld (space_last_state), a
    ld (bandit_tick), a     

game_loop:
    ld a, (player_y)
    ld d, a
    ld a, (player_x)
    ld e, a
    ld c, 32                
    call print_at
    ld a, (bandit_y)
    ld d, a
    ld a, (bandit_x)
    ld e, a
    ld c, 32
    call print_at
    ld a, (bullet_active)
    and a
    jp z, skip_erase_p_bullet
    ld a, (bullet_y)
    ld d, a
    ld a, (bullet_x)
    ld e, a
    ld c, 32
    call print_at
skip_erase_p_bullet:
    ld a, (b_bullet_active)
    and a
    jp z, skip_erase_b_bullet
    ld a, (b_bullet_y)
    ld d, a
    ld a, (b_bullet_x)
    ld e, a
    ld c, 32
    call print_at
skip_erase_b_bullet:
    ld bc, 0xfbfe
    in a, (c)
    rrca
    jr c, skip_up
    ld a, (player_y)
    and a                   
    jr z, skip_up
    ld d, a
    dec d                   
    ld a, (player_x)
    ld e, a
    call is_obstacle        
    jr c, skip_up           
    ld a, d
    ld (player_y), a
skip_up:
    ld bc, 0xfdfe
    in a, (c)
    rrca
    jr c, skip_down
    ld a, (player_y)
    cp 20                   
    jr z, skip_down
    ld d, a
    inc d
    ld a, (player_x)
    ld e, a
    call is_obstacle
    jr c, skip_down
    ld a, d
    ld (player_y), a
skip_down:
    ld bc, 0xdffe
    in a, (c)
    push af                 
    rrca
    rrca                    
    jr c, skip_left
    ld a, (player_x)
    and a                   
    jr z, skip_left
    ld e, a
    dec e
    ld a, (player_y)
    ld d, a
    call is_obstacle
    jr c, skip_left
    ld a, e
    ld (player_x), a
skip_left:
    pop af
    rrca                    
    jr c, skip_right
    ld a, (player_x)
    cp 15                   
    jr z, skip_right
    ld e, a
    inc e
    ld a, (player_y)
    ld d, a
    call is_obstacle
    jr c, skip_right
    ld a, e
    ld (player_x), a
skip_right:
    ld bc, 0x7ffe
    in a, (c)
    rrca
    jr c, space_not_pressed
    ld a, (space_last_state)
    and a
    jp nz, bandit_ai_logic  
    ld a, 1
    ld (space_last_state), a
    ld a, (bullet_active)
    and a
    jp nz, bandit_ai_logic  
    ld a, (player_x)
    inc a
    cp 32
    jp nc, bandit_ai_logic  
    ld (bullet_x), a
    ld a, (player_y)
    ld (bullet_y), a
    ld a, 1
    ld (bullet_active), a
    call sound_shoot        
    jp bandit_ai_logic      

space_not_pressed:
    ld a, 0
    ld (space_last_state), a

bandit_ai_logic:
    ld a, (bandit_tick)
    inc a
    ld (bandit_tick), a
    cp 4                    
    jp nz, update_bullets   
    ld a, 0
    ld (bandit_tick), a
    call get_random
    and 0x03                
    jp z, bandit_up
    cp 1
    jp z, bandit_down
    cp 2
    jp z, bandit_left
bandit_right:
    ld a, (bandit_x)
    cp 31                   
    jp z, bandit_shoot_check
    ld e, a
    inc e
    ld a, (bandit_y)
    ld d, a
    call is_obstacle
    jp c, bandit_shoot_check
    ld a, e
    ld (bandit_x), a
    jp bandit_shoot_check
bandit_left:
    ld a, (bandit_x)
    cp 16                   
    jp z, bandit_shoot_check
    ld e, a
    dec e
    ld a, (bandit_y)
    ld d, a
    call is_obstacle
    jp c, bandit_shoot_check
    ld a, e
    ld (bandit_x), a
    jp bandit_shoot_check
bandit_up:
    ld a, (bandit_y)
    and a                   
    jp z, bandit_shoot_check
    ld d, a
    dec d
    ld a, (bandit_x)
    ld e, a
    call is_obstacle
    jp c, bandit_shoot_check
    ld a, d
    ld (bandit_y), a
    jp bandit_shoot_check
bandit_down:
    ld a, (bandit_y)
    cp 20                   
    jp z, bandit_shoot_check
    ld d, a
    inc d
    ld a, (bandit_x)
    ld e, a
    call is_obstacle
    jp c, bandit_shoot_check
    ld a, d
    ld (bandit_y), a

bandit_shoot_check:
    ld a, (b_bullet_active)
    and a
    jp nz, update_bullets   
    call get_random
    and 0x0f
    jp nz, update_bullets   
    ld a, (bandit_x)
    dec a
    cp 255
    jp z, update_bullets    
    ld (b_bullet_x), a
    ld a, (bandit_y)
    ld (b_bullet_y), a
    ld a, 1
    ld (b_bullet_active), a
    call sound_shoot        

update_bullets:
    ld a, (bullet_active)
    and a
    jp z, update_bandit_bullet
    ld a, (bullet_x)
    inc a
    cp 32
    jr z, kill_p_bullet
    ld (bullet_x), a
    ld d, a                 
    ld a, (bullet_y)
    ld e, a                 
    ld a, (bandit_y)
    cp e
    jr nz, p_bullet_obstacle_check
    ld a, (bandit_x)
    cp d
    jr nz, p_bullet_obstacle_check
    ld a, 0
    ld (bullet_active), a   
    call sound_point        
    call add_score          
    call respawn_bandit     
    jp update_bandit_bullet

p_bullet_obstacle_check:
    ld a, (bullet_y)
    ld d, a
    ld a, (bullet_x)
    ld e, a
    call is_obstacle
    jp nc, update_bandit_bullet
kill_p_bullet:
    ld a, 0
    ld (bullet_active), a

update_bandit_bullet:
    ld a, (b_bullet_active)
    and a
    jp z, draw_entities
    ld a, (b_bullet_x)
    dec a
    cp 255                  
    jr z, kill_b_bullet
    ld (b_bullet_x), a
    ld d, a                 
    ld a, (b_bullet_y)
    ld e, a                 
    ld a, (player_y)
    cp e
    jr nz, b_bullet_obstacle_check
    ld a, (player_x)
    cp d
    jr nz, b_bullet_obstacle_check
    call sound_death        
    jp game_over

b_bullet_obstacle_check:
    ld a, (b_bullet_y)
    ld d, a
    ld a, (b_bullet_x)
    ld e, a
    call is_obstacle
    jp nc, draw_entities
kill_b_bullet:
    ld a, 0
    ld (b_bullet_active), a

draw_entities:
    ld a, 16
    rst 16
    ld a, 5
    rst 16
    ld a, (player_y)
    ld d, a
    ld a, (player_x)
    ld e, a
    ld c, 144
    call print_at

    ld a, 16
    rst 16
    ld a, 6
    rst 16
    ld a, (bandit_y)
    ld d, a
    ld a, (bandit_x)
    ld e, a
    ld c, 145
    call print_at

    ld a, (bullet_active)
    and a
    jp z, draw_b_bullet
    ld a, 16
    rst 16
    ld a, 7
    rst 16
    ld a, (bullet_y)
    ld d, a
    ld a, (bullet_x)
    ld e, a
    ld c, '-'
    call print_at

draw_b_bullet:
    ld a, (b_bullet_active)
    and a
    jp z, frame_delay
    ld a, 16
    rst 16
    ld a, 7
    rst 16
    ld a, (b_bullet_y)
    ld d, a
    ld a, (b_bullet_x)
    ld e, a
    ld c, '*'
    call print_at

frame_delay:
    halt
    halt                    
    jp game_loop

is_obstacle:
    push hl
    push bc
    ld hl, obstacles
    ld b, 8                 
is_obs_loop:
    ld a, (hl)              
    cp d
    jr nz, no_obs_match
    inc hl
    ld a, (hl)              
    cp e
    jr z, obs_hit           
    dec hl
no_obs_match:
    inc hl
    inc hl                  
    djnz is_obs_loop
    pop bc
    pop hl
    and a                   
    ret
obs_hit:
    pop bc
    pop hl
    scf                     
    ret

add_score:
    ld a, (score_units)
    inc a
    cp '9' + 1
    jr nz, store_units
    ld a, '0'
    ld (score_units), a
    ld a, (score_tens)
    inc a
    ld (score_tens), a
store_units:
    ld (score_units), a
    call update_score_display
    ret

update_score_display:
    ld a, 16
    rst 16
    ld a, 7
    rst 16
    ld d, 21                
    ld e, 17
    ld a, (score_tens)
    ld c, a
    call print_at
    ld e, 18
    ld a, (score_units)
    ld c, a
    call print_at
    ret

respawn_bandit:
    call get_rand_y
    ld d, a
respawn_re_x:
    call get_random
    and 0x0f                
    add a, 16               
    ld e, a
    call is_obstacle
    jp c, respawn_bandit    
    ld a, d
    ld (bandit_y), a
    ld a, e
    ld (bandit_x), a
    ret

init_obstacles:
    ld hl, obstacles
    ld b, 8                 
init_obs_loop:
    push bc
    push hl
retry_calc_obs:
    call get_rand_y
    ld d, a
    call get_random
    and 0x1f
    cp 29
    jp nc, retry_calc_obs
    cp 3
    jp c, retry_calc_obs    
    ld e, a
    ld a, d
    cp 10
    jr nz, obs_place_ok
    ld a, e
    cp 5
    jp c, retry_calc_obs
obs_place_ok:
    pop hl
    ld (hl), d              
    inc hl
    ld (hl), e              
    inc hl
    push hl
    ld a, 16
    rst 16
    ld a, 4
    rst 16
    ld c, 146               
    call print_at           
    pop hl
    pop bc
    djnz init_obs_loop
    ret

get_random:
    push hl
    push de
    ld hl, (rand_seed)
    ld d, h
    ld e, l
    add hl, hl              
    add hl, hl              
    add hl, hl              
    add hl, de              
    inc hl                  
    ld (rand_seed), hl
    ld a, h                 
    pop de
    pop hl
    ret

get_rand_y:
    call get_random
    and 0x1f
    cp 21                   
    jp nc, get_rand_y
    ret

play_note:
pn_loop:
    ld a, 16
    out (254), a
    ld b, h
pn_w1:
    djnz pn_w1
    ld a, 0
    out (254), a
    ld b, h
pn_w2:
    djnz pn_w2
    ld bc, 0x7ffe
    in a, (c)
    rrca
    jr nc, pn_space    
    dec de
    ld a, d
    or e
    jr nz, pn_loop
    or a               
    ret
pn_space:
    scf                
    ret

sound_shoot:
    push af
    push bc
    push de
    ld b, 30                
    ld d, 5                 
sound_sh_loop:
    ld a, 16                
    out (254), a
    ld c, d
sound_sh_w1:
    dec c
    jr nz, sound_sh_w1
    ld a, 0                 
    out (254), a
    ld c, d
sound_sh_w2:
    dec c
    jr nz, sound_sh_w2
    inc d                   
    inc d
    djnz sound_sh_loop
    pop de
    pop bc
    pop af
    ret

sound_point:
    push af
    push bc
    push de
    ld b, 40
sound_pt1_loop:
    ld a, 16
    out (254), a
    ld c, 30
sound_pt1_w1:
    dec c
    jr nz, sound_pt1_w1
    ld a, 0
    out (254), a
    ld c, 30
sound_pt1_w2:
    dec c
    jr nz, sound_pt1_w2
    djnz sound_pt1_loop
    ld b, 60
sound_pt2_loop:
    ld a, 16
    out (254), a
    ld c, 15
sound_pt2_w1:
    dec c
    jr nz, sound_pt2_w1
    ld a, 0
    out (254), a
    ld c, 15
sound_pt2_w2:
    dec c
    jr nz, sound_pt2_w2
    djnz sound_pt2_loop
    pop de
    pop bc
    pop af
    ret

sound_death:
    push af
    push bc
    push de
    ld e, 20                
sound_d_outer:
    ld b, 15                
sound_d_loop:
    ld a, 16
    out (254), a
    ld c, e
sound_d_w1:
    dec c
    jr nz, sound_d_w1
    ld a, 0
    out (254), a
    ld c, e
sound_d_w2:
    dec c
    jr nz, sound_d_w2
    djnz sound_d_loop
    inc e                   
    inc e
    inc e
    ld a, e
    cp 90                   
    jr nz, sound_d_outer
    pop de
    pop bc
    pop af
    ret

game_over:
    ld hl, 16384
    ld de, 16385
    ld bc, 6143
    ld (hl), 0
    ldir
    ld hl, 22528
    ld de, 22529
    ld bc, 767
    ld (hl), 0x07
    ldir
    xor a
    out (254), a

game_over_loop:
    ld a, 16
    rst 16
    ld a, 2
    rst 16
    ld d, 10
    ld e, 11
    ld c, 'G'
    call print_at
    ld e, 12
    ld c, 'A'
    call print_at
    ld e, 13
    ld c, 'M'
    call print_at
    ld e, 14
    ld c, 'E'
    call print_at
    ld e, 16
    ld c, 'O'
    call print_at
    ld e, 17
    ld c, 'V'
    call print_at
    ld e, 18
    ld c, 'E'
    call print_at
    ld e, 19
    ld c, 'R'
    call print_at
    ld a, 16
    rst 16
    ld a, 7
    rst 16
    ld d, 13
    ld e, 11
    ld c, 'S'
    call print_at
    ld e, 12
    ld c, 'C'
    call print_at
    ld e, 13
    ld c, 'O'
    call print_at
    ld e, 14
    ld c, 'R'
    call print_at
    ld e, 15
    ld c, 'E'
    call print_at
    ld e, 16
    ld c, ':'
    call print_at
    ld e, 18
    ld a, (score_tens)
    ld c, a
    call print_at
    ld e, 19
    ld a, (score_units)
    ld c, a
    call print_at
    ld a, 16
    rst 16
    ld a, 5
    rst 16
    ld d, 16
    ld e, 5
    ld hl, txt_restart
    call print_string
    ld bc, 0x7ffe
    in a, (c)
    rrca
    jp c, game_over_loop
    jp init_game            

print_at:
    push af
    push bc
    push de
    push hl
    ld a, 22
    rst 16       
    ld a, d
    rst 16       
    ld a, e
    rst 16       
    ld a, c
    rst 16       
    pop hl
    pop de
    pop bc
    pop af
    ret

print_string:
    ld a, (hl)
    and a
    ret z
    ld c, a
    push hl
    call print_at
    pop hl
    inc hl
    inc e
    jp print_string

txt_title:         defb "C O W B O Y S", 0
txt_press_space:   defb "PRESS SPACE TO START", 0
txt_restart:       defb "PRESS SPACE TO RESTART", 0

melody_data:
    defb 140, 1, 100
    defb 140, 1, 100
    defb 105, 1, 200
    defb 140, 2, 0
    defb 120, 1, 100
    defb 120, 1, 100
    defb 93, 1, 200
    defb 120, 2, 0
    defb 0

cowboy_sprite:
    defb 0x3C, 0x7E, 0x5C, 0x3C, 0x7F, 0x38, 0x6C, 0x44 
bandit_sprite:
    defb 0x3C, 0x7E, 0x3A, 0x3C, 0xFE, 0x1C, 0x36, 0x22 
cactus_sprite:
    defb 0x18, 0x5A, 0x5A, 0x7E, 0x18, 0x18, 0x18, 0x3C 

rand_seed:         defw 0x1234        
player_x:          defb 0
player_y:          defb 0
bandit_x:          defb 0
bandit_y:          defb 0
bandit_tick:       defb 0
bullet_active:     defb 0
bullet_x:          defb 0
bullet_y:          defb 0
b_bullet_active:   defb 0
b_bullet_x:        defb 0
b_bullet_y:        defb 0
space_last_state:  defb 0
score_tens:        defb 0
score_units:       defb 0
obstacles:         defs 16            

end 32768
