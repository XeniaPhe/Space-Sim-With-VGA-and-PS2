.data
    addr_spaceship_bitmap: 0x0200
    addr_planet_bitmap: 0x0210
    addr_spaceship_x: 0x0220
    addr_spaceship_y: 0x0221
    addr_planet_x: 0x0222
    addr_planet_y: 0x0223
    addr_keyboard: 0x0224
    addr_keyboard_ack: 0x0225
    spaceship_x: 0x0140
    spaceship_y: 0x00F0
    planet_x: 0x0140
    planet_y: 0x00F0
.code

MAIN
    ldi 7 0x01F7
    ldi 0 0x01FF
    ldi 1 ISR_Vsync
    st 0 1
    dec 0
    ldi 1 ISR_timer_100ms
    st 0 1

    ldi 0 addr_spaceship_bitmap
    ld 0 0
    ldi 1 addr_planet_bitmap
    ld 1 1

    ldi 2 0x0080
    ldi 3 0x07E0
    st 0 2
    st 1 3

    inc 0
    inc 1

    ldi 2 0x01C0
    ldi 3 0x1FF8
    st 0 2
    st 1 3

    inc 0
    inc 1

    ldi 3 0x3FFC
    st 0 2
    st 1 3

    inc 0
    inc 1

    ldi 3 0x7FFE
    st 0 2
    st 1 3

    inc 0
    inc 1

    st 0 2
    st 1 3

    inc 0
    inc 1

    ldi 2 0x03E0
    ldi 3 0xFFFF
    st 0 2
    st 1 3

    inc 0
    inc 1

    ldi 2 0x07F0
    st 0 2
    st 1 3

    inc 0
    inc 1

    ldi 2 0x0FF8
    st 0 2
    st 1 3
    
    inc 0
    inc 1

    ldi 2 0x3FFE
    st 0 2
    st 1 3

    inc 0
    inc 1

    ldi 2 0x01C0
    st 0 2
    st 1 3

    inc 0
    inc 1

    st 0 2
    st 1 3

    inc 0
    inc 1

    ldi 3 0x7FFE
    st 0 2
    st 1 3

    inc 0
    inc 1

    st 0 2
    st 1 3

    inc 0
    inc 1

    ldi 2 0x03E0
    ldi 3 0x3FFC
    st 0 2
    st 1 3

    inc 0
    inc 1

    ldi 2 0x07F0
    ldi 3 0x1FF8
    st 0 2
    st 1 3

    inc 0
    inc 1

    ldi 2 0x01C0
    ldi 3 0x07E0
    st 0 2
    st 1 3


    ldi 0 0x0140
    ldi 1 0x00F0

    ldi 2 addr_spaceship_x
    ld 2 2
    st 2 0

    ldi 2 addr_spaceship_y
    ld 2 2
    st 2 1

    ldi 2 addr_planet_x
    ld 2 2
    st 2 0

    ldi 2 addr_planet_y
    ld 2 2
    st 2 1

    sti

game_loop
    call PROC_read_keyboard
    mov 0 0
    jz game_loop
    call PROC_move_spaceship
    jmp game_loop

END_PROGRAM
cli

PROC_read_keyboard
    push 2

    ldi 1 addr_keyboard
    ld 1 1

    ldi 2 addr_keyboard_ack
    ld 2 2
    ld 0 2
    dec 0
    jz input_ready

    ld 0 1
    dec 0
    jz input_available

input_unavailable
    sub 0 0 0
    st 2 0
    jmp END_read_keyboard
input_available
    inc 0
    st 2 0
    dec 0
input_ready
    ld 1 1
    st 2 0

key_w
    inc 0
    ldi 2 0x001D
    sub 2 2 1
    jz END_read_keyboard

key_a
    inc 0
    ldi 2 0x001C
    sub 2 2 1
    jz END_read_keyboard

key_s
    inc 0
    ldi 2 0x001B
    sub 2 2 1
    jz END_read_keyboard

key_d
    inc 0
    ldi 2 0x0023
    sub 2 2 1
    jz END_read_keyboard

unmapped_key
    sub 0 0 0

END_read_keyboard
    pop 2
RET_read_keyboard
ret

PROC_move_spaceship
    push 2

    ldi 2 0x0004
    dec 0
    jz move_forward
    dec 0
    jz move_left
    dec 0
    jz move_backward

move_right
    ldi 0 spaceship_x
    ld 1 0
    add 1 1 2
    st 0 1
    jmp END_move_spaceship
move_forward
    ldi 0 spaceship_y
    ld 1 0
    sub 1 1 2
    st 0 1
    jmp END_move_spaceship
move_left
    ldi 0 spaceship_x
    ld 1 0
    sub 1 1 2
    st 0 1
    jmp END_move_spaceship
move_backward
    ldi 0 spaceship_y
    ld 1 0
    add 1 1 2
    st 0 1

END_move_spaceship
    pop 2
RET_move_spaceship
ret

PROC_move_planet
    ldi 0 planet_x
    ld 1 0
    inc 1
    inc 1
    st 0 1

    ldi 0 planet_y
    ld 1 0
    dec 1
    st 0 1
RET_move_planet
ret

PROC_render
    ldi 0 addr_spaceship_x
    ld 0 0
    ldi 1 spaceship_x
    ld 1 1
    st 0 1

    ldi 0 addr_spaceship_y
    ld 0 0
    ldi 1 spaceship_y
    ld 1 1
    st 0 1

    ldi 0 addr_planet_x
    ld 0 0
    ldi 1 planet_x
    ld 1 1
    st 0 1

    ldi 0 addr_planet_y
    ld 0 0
    ldi 1 planet_y
    ld 1 1
    st 0 1
RET_render
ret

ISR_Vsync
    push 0
    push 1

    call PROC_render

    pop 1
    pop 0
RET_ISR_Vsync
sti
iret

ISR_timer_100ms
    push 0
    push 1

    call PROC_move_planet

    pop 1
    pop 0
RET_ISR_timer_100ms
sti
iret
