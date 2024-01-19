.data
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
.code

MAIN
    ldi 7 0x01ff
    ldi 1 0x07f7
    st 1 ISR_Vsync
    dec 1
    st 1 ISR_second_elapsed

    ldi 0 addr_spaceship_bitmap
    ldi 1 addr_planet_bitmap
    ld 0 0
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

    sti

game_loop
    jmp game_loop


PROC_move_spaceship
    mov 0 0

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

ISR_Vsync
    push 0
    push 1

    sti
    call PROC_render
    
    pop 1
    pop 0
RET_ISR_Vsync
iret

ISR_second_elapsed
    push 0
    push 1

    sti
    call PROC_move_planet

    pop 1
    pop 0
RET_ISR_second_elapsed
iret
