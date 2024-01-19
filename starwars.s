.data
    addr_spaceship_bitmap: 0x0200
    addr_planet_bitmap: 0x0210
    addr_spaceship_x: 0x0220
    addr_spaceship_y: 0x0221
    addr_planet_x: 0x0222
    addr_planet_y: 0x0223
.code

MAIN
    ldi 7 0x01ff
    ldi 1 0x07f7
    st 1 ISR_Vsync

    ldi 0 addr_spaceship_bitmap
    ldi 1 addr_planet_bitmap
    ld 0 0
    ld 1 1

    ldi 3 0x0080
    st 0 3
    ldi 3 0x0180
    st 1 3

    inc 0
    inc 1

    ldi 3 0x01C0
    st 0 3
    ldi 3 0x03C0
    st 1 3

    inc 0
    inc 1

    ldi 3 0x01C0
    st 0 3
    ldi 3 0x07E0
    st 1 3

    inc 0
    inc 1

    ldi 3 0x01C0
    st 0 3
    ldi 3 0x0FF0
    st 1 3

    inc 0
    inc 1

    ldi 3 0x01C0
    st 0 3
    ldi 3 0x1FF8
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
    ldi 3 0x7FFE
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
    ldi 3 0x7FFE
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
    ldi 3 0x1FF8
    st 1 3

    inc 0
    inc 1

    ldi 3 0x01C0
    st 0 3
    ldi 3 0x0FF0
    st 1 3

    inc 0
    inc 1

    ldi 3 0x01C0
    st 0 3
    ldi 3 0x07E0
    st 1 3

    inc 0
    inc 1

    ldi 3 0x03E0
    st 0 3
    ldi 3 0x03C0
    st 1 3

    inc 0
    inc 1

    ldi 3 0x07F0
    st 0 3
    ldi 3 0x0180
    st 1 3

    inc 0
    inc 1

    ldi 3 0x01C0
    st 0 3
    ldi 3 0x0000
    st 1 3

    sti

inf jmp inf


ISR_Vsync
    sti

RET_ISR_Vsync
iret
