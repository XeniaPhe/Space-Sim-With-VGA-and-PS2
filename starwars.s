.data
    addr_keyboard: 0x0224
    addr_keyboard_ack: 0x225
    addr_spaceship_bitmap: 0x0200
    addr_planet_bitmap: 0x0210
    addr_spaceship_x: 0x0220
    addr_spaceship_y: 0x0221
    addr_planet_x: 0x0222
    addr_planet_y: 0x0223
    spaceship_x: 0x0140
    spaceship_y: 0x00F0
    planet_x: 0x0140
    planet_y: 0x00F0
    initialized: 0x0000
.code

MAIN
    ldi 7 0x01FF
    ldi 1 0x07F7
    st 1 ISR_Vsync_init
    dec 1
    st 1 ISR_second_elapsed

    sti
    ldi 0 initialized

init_graphics
    ld 1 0
    mov 1 1
    jz init_graphics

    ldi 1 0x07F7
    st 1 ISR_Vsync

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

    ldi 0 addr_keyboard_ack
    ld 0 0
    ld 1 0

    dec 1
    jz input_ready

    ldi 1 addr_keyboard
    ld 1 1
    ld 2 1

    dec 2
    jz input_available


input_unavailable
    ldi 1 0x0000
    st 0 1
    mov 0 1
    jmp END_read_keyboard

input_available
    ldi 2 0x0001
    st 0 1

input_ready
    ld 2 1
    ldi 1 0x0000
    st 0 1

    ldi 0 0x001D
    sub 0 0 2
    jz key_w

    ldi 0 0x001C
    sub 0 0 2
    jz key_a

    ldi 0 0x001B
    sub 0 0 2
    jz key_s

    ldi 0 0x0023
    sub 0 0 2
    jz key_d

unmapped_key
    ldi 0 0x0000
    jmp END_read_keyboard

key_w
    ldi 0 0x0001
    jmp END_read_keyboard
key_a
    ldi 0 0x0002
    jmp END_read_keyboard
key_s
    ldi 0 0x0003
    jmp END_read_keyboard
key_d
    ldi 0 0x0004

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
    push 2
    push 3
    push 4

    ldi 0 planet_x
    ld 1 0
    ldi 2 planet_y
    ld 3 2

    ldi 4 0x000A
    sub 3 3 4
    add 4 4 4
    add 1 1 4

    st 0 1
    st 2 3

    pop 4
    pop 3
    pop 2
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

ISR_Vsync_init
    push 0
    push 1
    push 3
    
    ldi 0 addr_spaceship_bitmap
    ld 0 0
    ldi 1 addr_planet_bitmap
    ld 1 1

    ldi 3 0x0080
    st 0 3
    ldi 3 0x07E0
    st 1 3

    inc 0
    inc 1

    ldi 3 0x01C0
    st 0 3
    ldi 3 0x1FF8
    st 1 3

    inc 0
    inc 1

    ldi 3 0x01C0
    st 0 3
    ldi 3 0x3FFC
    st 1 3

    inc 0
    inc 1

    ldi 3 0x01C0
    st 0 3
    ldi 3 0x7FFE
    st 1 3

    inc 0
    inc 1

    ldi 3 0x01C0
    st 0 3
    ldi 3 0x7FFE
    st 1 3

    inc 0
    inc 1

    ldi 3 0x03E0
    st 0 3
    ldi 3 0xFFFF
    st 1 3

    inc 0
    inc 1

    ldi 3 0x07F0
    st 0 3
    ldi 3 0xFFFF
    st 1 3

    inc 0
    inc 1

    ldi 3 0x0FF8
    st 0 3
    ldi 3 0xFFFF
    st 1 3
    
    inc 0
    inc 1

    ldi 3 0x3FFE
    st 0 3
    ldi 3 0xFFFF
    st 1 3

    inc 0
    inc 1

    ldi 3 0x01C0
    st 0 3
    ldi 3 0xFFFF
    st 1 3

    inc 0
    inc 1

    ldi 3 0x01C0
    st 0 3
    ldi 3 0xFFFF
    st 1 3

    inc 0
    inc 1

    ldi 3 0x01C0
    st 0 3
    ldi 3 0x7FFE
    st 1 3

    inc 0
    inc 1

    ldi 3 0x01C0
    st 0 3
    ldi 3 0x7FFE
    st 1 3

    inc 0
    inc 1

    ldi 3 0x03E0
    st 0 3
    ldi 3 0x3FFC
    st 1 3

    inc 0
    inc 1

    ldi 3 0x07F0
    st 0 3
    ldi 3 0x1FF8
    st 1 3

    inc 0
    inc 1

    ldi 3 0x01C0
    st 0 3
    ldi 3 0x07E0
    st 1 3

    ldi 0 addr_spaceship_x
    ld 0 0
    ldi 1 0x0140
    st 0 1

    ldi 0 addr_spaceship_y
    ld 0 0
    ldi 1 0x00F0
    st 0 1

    ldi 0 addr_planet_x
    ld 0 0
    ldi 1 0x0140
    st 0 1

    ldi 0 addr_planet_y
    ld 0 0
    ldi 1 0x00F0
    st 0 1

    ldi 0 initialized
    ldi 1 0x0001
    st 0 1

    pop 3
    pop 1
    pop 0
RET_ISR_Vsync_init
sti
iret

ISR_Vsync
    push 0
    push 1

    call PROC_render

    pop 1
    pop 0
RET_ISR_Vsync
sti
iret

ISR_second_elapsed
    push 0
    push 1

    call PROC_move_planet

    pop 1
    pop 0
RET_ISR_second_elapsed
sti
iret
