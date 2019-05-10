
*=$0801 "Basic upstart"
:BasicUpstart($0900)

*=$0900 "Program"
	
    ldx #$00
loop:
    lda message,x
    sta $0400,x     // Screen memory is at $0400-$07ff
    lda #$07        // $07 = yellow
    sta $d800,x     // Color memory is at $d800-$dbff
    inx
    cpx #13         // String length == 13
    bne loop
    jmp *           // Infinite loop

message: 
    .text "hello, world!"