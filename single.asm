 ; .loadsym "\out\.lab" PUT PATH OF .LAB FILE HERE, USE THIS WITH ALTIRRA EMULATOR
 
;-----------------------------------------------------------------------------
; Memory Map
;-----------------------------------------------------------------------------
; Load Address = $3000 (Helper libraries)
; Run Address = $3200

;-----------------------------------------------------------------------------
;  HARDWARE EQUATES
;-----------------------------------------------------------------------------
    icl 'equates.asm'

;-----------------------------------------------------------------------------
; Structure Declarations
;-----------------------------------------------------------------------------

;-----------------------------------------------------------------------------
; Variables go here
;-----------------------------------------------------------------------------
; Page 0 user data ($80 to $FF with some reserved for OS)
.zpvar Reg1				.byte			; Multi-Use Variables
.zpvar Reg2				.byte			; Multi-Use Variables
.zpvar Reg3				.byte			; Multi-Use Variables
.zpvar Reg4				.byte			; Multi-Use Variables
.zpvar Reg5				.byte			; Multi-Use Variables
.zpvar Reg6				.byte			; Multi-Use Variables
.zpvar Reg7				.byte			; Multi-Use Variables
.zpvar Reg8				.byte			; Multi-Use Variables
.zpvar Ptr_Lo			.byte			; Lo byte of pointer
.zpvar Ptr_Hi			.byte			; Hi byte of pointer

; Non Page-0 Variables ($480-$4FF and $600-$6FF are free)
; When using PMG the 1st $300 bytes are always free

;-----------------------------------------------------------------------------
; Defines go here
;-----------------------------------------------------------------------------
.def	__VBXE_AUTO__
.def	VBXE_WINDOW	=	$2000

; BCB field byte offsets
.def	Src_Adr0						= $00
.def	Src_Adr1						= $01
.def	Src_Adr2						= $02
.def	Dest_Adr0						= $06
.def	Dest_Adr1						= $07
.def	Dest_Adr2						= $08
.def	Blt_Ctrl						= $14

;-----------------------------------------------------------------------------
; VBXE Helpers
;-----------------------------------------------------------------------------
	org $3000
.pages 2								; DO NOT go past $3200
	icl	'fileio.lib'
	icl	'vbxe_min.asm'					; Use my VBXE_SetPalette2 to load linear palete
.endpg


	org $3200
;-----------------------------------------------------------------------------
; Initialization
;-----------------------------------------------------------------------------
init

;-----------------------------------------------------------------------------
; Main loop
;-----------------------------------------------------------------------------
main

; All done - now loop forever
	jsr Wait_For_Sync					; Wait for VSYNC, Q quits
	jmp main

; Set RUN Vector
	run init

;-----------------------------------------------------------------------------
; Clean up and exit
;-----------------------------------------------------------------------------
Exit
	lda #$FF
	sta CH								; Clear last key pressed
	jmp	(DOSVEC)

;-----------------------------------------------------------------------------
; END OF CODE
;-----------------------------------------------------------------------------

;-----------------------------------------------------------------------------
; Subroutines BEGIN
;-----------------------------------------------------------------------------
;-----------------------------------------------------------------------------
; Wait For VSync (locks to the refresh rate, PAL=50Hz, NTSC=60Hz)  Thanks tebe
;-----------------------------------------------------------------------------
Wait_For_Sync							; Hold until VCOUNT == 0
	bit	VCOUNT
	bmi *-3
	bit	VCOUNT
	bpl *-3
; If present, the next 3 lines will allow a "jump to exit" on a specific key press
	lda CH
	cmp #$2F							; Press Q to quit
	beq	Exit
	rts									; Else return to caller
;-----------------------------------------------------------------------------
; Subroutines END
;-----------------------------------------------------------------------------

;-----------------------------------------------------------------------------
; Data Tables go here
;-----------------------------------------------------------------------------