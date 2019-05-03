
### C64 demo programming

**KRISTOFFER JÄLÉN**

tretton37 AB

---

## Agenda

1. What is the C64?
2. The demoscene
3. Tech
4. Assembly language
5. Graphics
6. Music
7. Interrupts
8. Write a demo
9. Advanced topics
10. Optimization
11. Learn more

---

## What is the C64?

- 8 bit computer
- Introduced in 1982
- Highest-selling single computer model of all time

![Commodore 64](/lib/img/Commodore-64-Computer-FL.jpg) <!-- .element height="60%" width="60%" -->

Note:
8 bit = ... TODO

---

## What did it look like?

<div class="grid">
    <div>![fdd](/lib/img/Brucelee_screenshot1.gif)<!-- .element height="60%" width="60%" --><div>Bruce Lee (1984)</div></div>
    <div>![fdd](/lib/img/CaliforniaGames_Ani1.gif)<!-- .element height="60%" width="60%" --><div>California Games (1987)</div></div>
    <div>![fdd](/lib/img/ImpossibleMisson_Animation.gif)<!-- .element height="60%" width="60%" --><div>Impossible Mission (1984)</div></div>
    <div>![fdd](/lib/img/LastNinja_Animation1.gif)<!-- .element height="60%" width="60%" --><div>The Last Ninja (1987)</div></div>
</div>

---

## The demoscene

- A cultural and competitive subculture
- Groups of people put together code, graphics and music into executable programs
- Impress and outperform each other in creating the most advanced effects
- Since the eighties
- Super-cool handles and group names

Note:
Limited hardware.

---

### Demo groups

<div class="grid black">
    <div>![fdd](/lib/img/Razor1911.png)</div>
    <div>![fdd](/lib/img/fairlight.png)</div>
    <div>![fdd](/lib/img/triad.png)</div>
    <div>![fdd](/lib/img/trsi.jpg)</div>
</div>

---

## Demo components

- Text
- Sprites
- Bitmap
- Music

TODO bilder på detta

---

## Effects

<div class="grid">
    <div>![fdd](/lib/img/plasma.gif)<!-- .element height="60%" width="60%" --></div>
    <div>![fdd](/lib/img/dycp.gif)<!-- .element height="60%" width="60%" --></div>
    <div>![fdd](/lib/img/techtech.gif)<!-- .element height="60%" width="60%" --></div>
    <div>![fdd](/lib/img/lines.gif)<!-- .element height="60%" width="60%" --></div>
</div>

---

## Edge of disgrace<br>Booze Dezign (2008)

<iframe  width="560" height="315" src="https://www.youtube.com/embed/8kJz_XfbxX0" frameborder="0" allow="autoplay; encrypted-media" allowfullscreen></iframe>

---

## What's inside
 
- CPU at 1 Mhz (MOS 6510)
- Graphics chip (VIC-II)
- Sound chip (SID 6581/8580)
- RAM: 64 kB
- 16 colors
- Text mode: 40×25 characters
- Bitmap mode: max 320×200 px
- 8 hardware sprites of max 24×21 px
- Smooth scrolling
- Raster interrupts

Note:
1 MHz = 1000 cycles

---

### Memory

RAM at $0000 - $ffff, and on is ROM with BASIC interpreter, KERNEL routines and Character Generator ROM.

![Memory map](lib/img/memory_map.png) <!-- .element height="50%" width="50%" -->

<small>Image from dustlayer.com</small>

Note:
Character Generator ROM carries four different character sets each 1K in size.

There is 64 kB RAM plus 20 kB ROM sharing address information with RAM. To read any byte in RAM which is "under ROM" you have to switch out the section of ROM which overlaps that particular RAM area.

65536 memory locations, each holding a single byte

Initial memory configuration

---

### Four memory banks

VIC-II address bus is only 14 bits wide, means can address only 16 kB at a time.

|Bank|16 kB area|$dd00
|-|-|-|
|0|$0000 - $3fff|`%xxxxxx11`|
|1|$4000 - $7fff|`%xxxxxx10`|
|2|$8000 - $bfff|`%xxxxxx01`|
|3|$c000 - $ffff|`%xxxxxx00`|

Note:
All displayed graphics must be in the same bank.

Effects by flipping through banks.

---

## Memory-mapped I/O

Access features by read/write to memory addresses

|||
|-----|-----|
|$0400|Character at first row first col|
|$0401|Character at first row second col|
|$0428|Character at second row first col|
|...|...|
|$d016|Bits #0-#2: Horizontal raster scroll|
|$d020|Border color|


Note:
- I/O chips are memory-mapped
- 64 kB RAM
- Plus 20 kB ROM (read only) for BASIC, KERNEL and Character Generator ROM sharing address information with RAM
- To read any byte in RAM which is "under ROM" you have to switch out the section of ROM which overlaps that particular RAM area. This ROM switching concept is the major difference between the 6510 CPU in the C64 and the 6502 CPU used in other 8Bit-Computers. The concept also allows many different memory configurations which can be optimized towards whatever use case needs to be taken care of.

---

## Assembly language

<div class="grid">
    <div>![fdd](/lib/img/c64_prog_ref_guide.jpg)</div>
    <div>![fdd](/lib/img/Compute_s_Mapping_the_Commodore_64.jpg)</div>
</div>

---

### Instructions

- Simple instruction set
- Approx. 60 instructions
- Store data in memory
- Store data in registers
- Increment/decrement
- Add/subtract
- Shift bits
- Jump and branch
- Compare

---

### Numeral system

One byte:

|||
|-|-|
|Decimal|`0` - `255`|
|Hexadecimal|`$00` - `$ff`|
|Binary|`%00000000` - `%11111111`|

Note:
255 + 1 wraps over to 0

---

### Registers

|||
|-|-|
|A (Accumulator)|Arithmetic and logic|
|X and Y|General purpose|
|S|Stack pointer|
|P|Processor status|

Each register can hold one byte.

Note:
TODO vad gör SP och Status osv? https://www.dwheeler.com/6502/oneelkruns/asm1step.html

---

### Store data

|||
|-|-|
|`STA $d020`|Store A in $d020|
|`LDA #$0f`|Load A with `$0f`|
|`STX $d020`|Store X in $d020|
|`LDX #$0f`|Load X with `$0f`|
|`STY $d020`|Store Y in $d020|
|`LDY #$0f`|Load Y with `$0f`|

---

### Transfer data

|||
|-|-|
|`TAX`| Transfer value in A to X|
|`TAY`| Transfer value in A to Y|
|`TXA`| Transfer value in X to A|
|`TYA`| Transfer value in Y to A|

---

### Increment/decrement data

|||
|-|-|
|`INC $d020`| Increase value in $d020 by 1|
|`DEC $d020`| Decrease value in $d020 by 1|
|`INX`| Increase value in X by 1|
|`DEX`| Decrease value in X by 1|
|`INY`| Increase value in Y by 1|
|`DEY`| Decrease value in Y by 1|

---

### Addressing modes

|||
|-|-|
|Implied addressing| `INX`
|Accumulator addressing| `ASL`
|Immediate addressing| `LDA #$40`
|Absolute addressing| `LDA $40`
|Indexed absolute addressing| `LDA $0400,x`
|Relative addressing|  `BEQ loop`
|Indirect-indexed addressing| `LDA ($02),Y`

Also zeropage addressing modes and more.

Note:
LDY #$04; LDA ($02),Y   Here Y is loaded with four (4), and the vector is given as ($02). If zero page memory $02-$03 contains 00 80, then the effective address from the vector ($02) plus the offset (Y) would be $8004. This addressing mode is commonly used in array addressing, such that the array index is placed in Y and the array base address is stored in zero page as the vector. 


---

### Immediate and absolute addressing

|||
|-|-|
| `LDA #$0f` | Immediate addressing |

```
lda #$0f     // Load A with value $0f
```

|||
|-|-|
| `LDA $0f` | Absolute addressing |

```
lda $0f      // Load A with content of location $0f
```

---

### Indexed absolute addressing

Clear the screen. Screen memory is at $0400-$07FF.

```
    lda #$20        // Character SPACE
    ldx #$00
loop:
    sta $0400,x     // Store A in $0400 + X
    sta $0500,x     // Store A in $0500 + X
    sta $0600,x     // Store A in $0600 + X
    sta $0700,x     // Store A in $0700 + X
    
    inx             // Increment X by 1
    
    bne loop        // Branch if X != 0, e.g. 256 iterations
```

---

### Add and subtract

|||
|-|-|
| `ADC` | Add with carry |

```
lda $0400       // Read the byte value at $0400
clc             // No incoming carry; make sure carry is clear
adc #$05        // Perform the addition
sta $0500       // Store result
```

|||
|-|-|
| `SBC` | Subtract with carry |

```
lda $0400       // Read the byte value at $0400
sec             // No incoming borrow; make sure carry is set
sbc #$05        // Perform the subtraction
sta $0500       // Store result in Result
```

Note:
The inclusion of the incoming carry provides a simple means to add binary integers of arbitrary length, "spread" across two or more bytes: Add the least significant byte pair first with the carry cleared, then add increasingly significant bytes without modifying the carry. This will let the outgoing carry from one addition "travel" from one addition to the next. 

---

### Bit shifting

|||
|-|-|
| `ASL` | Bit shift left |

```
lda #$02	// A = %0010 = $02
asl 		// A = %0100 = $04
asl 		// A = %1000 = $08
```

|||
|-|-|
| `LSR` | Bit shift right |

```
lda #$08    // A = %1000 = $08
lsr         // A = %0100 = $04
lsr         // A = %0010 = $02
```

Note:
Shift the bits that are in a given memory to the left, the value there will be multiplied by two, and if you shift them to the right, the value will be divided by two.

---

### Bit masking

Set individual bits to 1

```
lda $d01d
ora %10000100    // set bit 2 and 7
sta $d01d
```

Set individual bits to 0

```
lda $d01d
and %01111011    // clear bit 2 and 7
sta $d01d
```

Flip individual bits

```
lda $d01d        // A is %00000001
eor %10000000    // flip bits
sta $d01d        // A is %10000001
```

---

#### Branching

|||
|-|-|
|`CMP`| Compare memory and A|
|`CPX`| Compare memory and X|
|`CPY`| Compare memory and Y|
|`BEQ` / `BNE`| Branch if equal / not equal|

```
lda NumA    // Read the value "NumA"
beq Equal   // Go to label "Equal" if "NumA" == 0
...         // Continue here if "NumA" != 0

lda NumA    // Read the value "NumA"
cmp NumB    // Compare against "NumB"
beq Equal   // Go to label "Equal" if "NumA" == "NumB"
...         // Execution continues here if "NumA" != "NumB"
```

Note:
Since the zero flag is set if the result of an operation, or a byte retrived from memory, equals zero, one of the uses for BEQ is to check for such zero results. 
The zero flag is also affected as a result of comparisons (CMP, CPX, CPY), and so BEQ and BNE is often used after a comparison to redirect program execution depending on whether the compared values are equal or not

---

## Graphics

![Screen](/lib/img/dustlayer.com-screen-raster-cycles.png) <!-- .element height="70%" width="70%" -->

<small>Image from dustlayer.com</small>

Note:
The time the raster beam needs to go from the last line it drawed to the first line into account. This is called Vertical blank or VBLANK. The Raster beam has to travel 504 pixels horizontally and 312 lines vertically for one full screen refresh on a PAL C64.

---

## Rendering text

|||
|-|-|
|$0400 - $07e8|Screen memory (default)|
|$d800 - $dbe7|Color memory|

```
    ldx #$00
loop:
    lda message,x
    sta $0400,x     // Screen memory is at $0400-$07ff
    lda #$07        // $07 = Yellow
    sty $d800,x     // Color memory is at $d800-$dbff
    inx
    cpx #54         // Text is 54 chars long
    bne loop
    jmp *           // Infinite loop

message: .text "I am a cool demo coder"
   
*=$2000 "myCharset.64c" // Load custom charset at $2000
```

Note:
Screen memory contains character codes
Color memory contains colour values of the characters

---

### Sprites

- 2d images that you can move over a background
- Up to 8 sprites rendered at the same time
- More sprites on screen with advanced tricks 

![Sprite](/lib/img/spritepad.png)

Note:
Like a player character, a sun, a tree, an enemy and so on. 

---

### Render a sprite

- Enable it
- Set its x and y position
- Set a pointer to its data

---

### Sprite data

- One sprite takes 64 ($40) bytes of data
- Sprite data loaded at some location, e.g. at $2000:

|||
|-|-|
|$2000 - $203f|Sprite 0
|$2040 - $207f|Sprite 1
|$2080 - $20bf|Sprite 2
|...|...
|$21c0 - $21ff|Sprite 7

---

### Pointer to sprite data

- 8 sprite pointers
- A byte giving the location of the sprite's data
- Last 8 bytes of screen memory ($0400 – $0800)

**Sprite**|**0**|**1**|**2**|**3**|**4**|**5**|**6**|**7**
:-----:|:-----:|:-----:|:-----:|:-----:|:-----:|:-----:|:-----:|:-----:
Address|07f8|07f9|07fa|07fb|07fc|07fd|07fe|07ff

```
lda #$80    // Sprite data is at $80 * $40 = $2000
sta $07f8   // Set sprite pointer 0 to $80

lda #$81    // Sprite data is at $81 * $40 = $2040
sta $07f9   // Set sprite pointer 1 to $81

*=$2000 .import "monster.spr"    // Load sprite data at $2000
```

---

### Enable sprites

Each bit in $d015 controls if a sprite is enabled.

```
lda #$ff        // Enable all sprites: %11111111
sta $d015

lda #$28        // Enable sprite 3 and 5: %00101000
sta $d015
```

---

### Set X and Y position

X and Y coordinates are stored at $d000-$d00f.

**Sprite**|**x pos **|**y pos**
:-----:|:-----:|:-----:
#0|$d000|$d001
#1|$d002|$d003
...|...|...
#5|$d00a|$d00b
#6|$d00c|$d00d
#7|$d00e|$d00f

---

### Set X and Y position

```
lda #$80
sta $d000   // Set X of sprite 0 to $80 (128)

lda #$60
sta $d001   // Set Y of sprite 0 to $60 (96)
```

---

### Complete sprite listing

```
lda #$80 
sta $07f8       // Sprite data is at $80 * $40 = $2000

lda #$01        
sta $d015       // Enable sprite 0

lda #$80
sta $d000       // Set X of sprite 0 to $80 (128)

lda #$60
sta $d001       // Set Y of sprite 0 to $60 (96)

*=$2000 .import "monster.spr"     // Load sprite data at $2000
```

Note: The C-64 screen is 320 px. One byte can hold 255 values. How can we move a sprite across the 255 limit? If the corresponding bit in $d010 is set to 1, the position of the corresponding sprite’s X coordinate is: 256 + the value in $d000.
 
---

## Bitmaps

- 320×200 px in hires mode
- 160×200 px in multicolour mode
- 8 kB required for whole screen
- No direct addressing of pixels

<div class="grid">
    <div>![fdd](/lib/img/rescuing-bitmap.png)<div>Rescuing Orc by Mermaid (2017)</div></div>
    <div>![fdd](/lib/img/disconnet-bitmap.png)<div>Disconnect by Joe (2017)</div></div>
</div> 

Note:
320×200 = 64000 px = 8000 kB

---

## Interrupts

- Pause at a given condition and do another task
- When interrupt is complete, program will continue where it was interrupted
- Timer interrupts
- Raster interrupts
- Sprite collision interrupts
- Multiple interrupts during a screen refresh

Note:
Timer interrupt: when a given amount of cycles has passed
Raster interrupt:
Collision interrupt

---

## Raster interrupt

- Screen is redrawn 50 times per second

- Draws from top to bottom, from left to right

- Screen has 318 raster lines

- When raster beam reaches a specific line, a raster interrupt will occur

Note:
TODO eller är det 312 raster lines?

1 raster line takes 63 cycles
312 raster lines takes 312 * 63 = 19 656 cycles
Refresh rate is 1 Mhz / 19 656 = 50 hz

- Effects are achieved through well-timed modifications of VIC registers. At exactly the right time, or you'll get flickering bars.

---

## $d012

|||
|-|-|
|Read|Get current raster line|
|Write|Set line for next raster interrupt|

Note:
So, if you want something to happen 50 times per second, all you have to do is to check the current value of $d012, and when it reaches a certain value, call the routine that performs the desired task. When finished, go back to checking $d012.

Bit 7 of $d011 is really bit 8 of $d012

---

### Initialize interrupts

```
    sei         // Disable interrupts ("Set interrupt flag")
                // to make sure another interrupt won't interfere
                // with the init process

    lda #$7f
    sta $dc0d
    sta $dd0d   // Disable CIA I, CIA II and VIC interrupts

    lda #$01
    sta $d01a   // Enable raster interrupts

    lda #<irq   // Load low part of interrupt handler
    ldx #>irq   // Load high part of interrupt handler
    sta $0314   // Store low handler in vector
    stx $0315   // Store high handler in vector
    
    ldy #$7e
    sty $d012   // Raster interrupt at line $7e

    lda $dc0d
    lda $dd0d
    asl $d019
    
    cli         // Enable interrupts ("Clear interrupt flag")

    jmp *       // Infinite loop

irq:            // Label for interrupt handler
    asl $d019   // Ack the interrupt
    // ...
    jmp $ea81   // Restore the stack and return from interrupt
```

Note:
ACK interrupt is done because we don't want the interrupt to be called again right after we return from it.

---

## Music

- Load music data
- Initialize music
- In interrupt, jump to play routine

![Screen](/lib/img/goattracker.gif) <!-- .element height="50%" width="50%" -->

---

### Play music

```
    lda #$00
    tax
    tay
    jsr $1000   // Init routine is at $1000
    sei
    jsr setupInterrupts
    cli
    jmp *
irq:
    jsr $1003   // Play routine is at $1003
    asl $d019
    jmp $ea81

.import $1000-$7e "music.sid"
```

Note:
A SID file has an offset of $7e so we need to subtract this from $1000 so the file is correctly placed in memory.

---

### Multiple Interrupts

Example:

- Split screen into different sections
- Upper section: render a bitmap
- Lower section: render text
- Screen must support both bitmap and text mode

---

### Multiple interrupts

Inside **first** interrupt handler:

- Set `$d012` to raster line 160
- Set vectors `$0314` - `$0315` to second handler

Inside **second** interrupt handler:

- Set `$d012` to raster line 0
- Set vectors `$0314` - `$0315` to first handler
 
---

# Write a demo!

---

### Setup
|||
|-|-|
|Cross assembler|Kick Assembler|
|Emulator|WinVICE|
|Text editor support|Sublime Text package|

In the old days:

- Live edit in memory
- Action Replay cartridge

Note:
Assemble code on modern computer. 

For Sublime Text, there's a package for syntax highlighting: https://goatpower.org/projects-releases/sublime-package-kick-assembler-c64/

---

### Change the background color

```
*=$0801 "Basic upstart"
:BasicUpstart($0900)    // Special Kick Assembler macro

*=$0900 "Program"       // Put program at $0900

loop:
    inc $d021           // Change background color
    jmp loop
```

|||
|-|-|
|Compile| `java –jar kickass.jar code.asm`|
|Run| `x64s.exe code.prg`|

---

### Text scroller

- An interrupt that occurs a few lines before the text
- In interrupt read a variable with value of $d016
- The three lower bits of $d016 control the x-scroll:
 - Value is 7 = scrolled 7 pixels to the right
 - Value is 0 = normal screen, reset to 7 again, move the characters in screen memory one step to the left, and insert a new character in the right end of the screen

Note:
so you have 8 steps of scrolling
TODO Varför läsa variabel för d016?

---

## Home exercise

Your first demo:

- A logo at the top of the screen
- Sprites moving around in some sine pattern
- A scroll text at the bottom of the screen
- Raster bars in the top and bottom border
- A tune playing

---

## Advanced topics

- Stable raster interrupts
- Tech-tech (horizontal waving)
- DYCP (sinus scroll)
- Plasma
- Opening borders
- Load from disk during execution
- Badlines
- Self modifying code
- Interlace modes

Note:
Sine and cosine functions to color values
---

## Optimization

- Use tables
- Loop unrolling
- Zero page

Note:
An LDA or STA to a normal memory address takes 4 clock cycles, but if you use an address in the zero page, they only take 3 cycles.

---

## Learn more

- **How to program for the C64 on Windows** <small>digitalerr0r.wordpress.com/category/commodore-64/</small>
- **An Introduction to Programming C-64 Demos** <small>www.antimon.org/code/Linus/</small>
- **C64 coding tutorial** <br><small>dustlayer.com</small>
- **Kick Assembler** <br><small>www.theweb.dk/KickAssembler</small>
- **Sublime Text package** <br><small>goatpower.org/projects-releases/sublime-package-kick-assembler-c64/</small>

--

## Learn more

- **Codebase64** <br><small>codebase64.org</small>
- **The C64 scene database** <br><small>csdb.dk</small>
