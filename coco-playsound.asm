
* What type of drivewire?
* Real Coco2/3 bit banger - set all to 0
* Or set exactly one of these to 1
BECKER		EQU 1				* emulators, coco3fpga
JMCPBCK		EQU 0
BECKERTO	EQU 0
ARDUINO		EQU 0
BAUD38400	EQU 0				* coco1 bit banger
NOINTMASK	EQU 0
H6309		EQU 0
SY6551N		EQU 0				* rs232 pack
COCO3FPGAWIFI	EQU 0
MEGAMINIMPI     EQU 0

* Drivewire Defines
IntMasks	EQU $50

* Drivewire Commands
* OP_SERSETSTAT	EQU $45
SS.Open		EQU $29 
SS.Close	EQU $2A
* OP_SERREAD	EQU $45
* OP_SERREADM	EQU $63
OP_SERWRITEM	EQU $64
* OP_DWINIT	EQU $5A
OP_PLAYSOUND	EQU $FA
* Drivewire Errors
E_OK		EQU $00
E_NOPLAYSOUND   EQU $FA
E_READ		EQU $F4

* pyDriveWire Features
FEATURE_RESERVED EQU %10000000
FEATURE_PLAYSND  EQU %01000000

		org $4000
start
* Check if server is pyDriveWire
		lbsr	CheckServer
		bcs 	unknownerror		* carry set - not pyDriveWire or error
		bitb	#(FEATURE_RESERVED|FEATURE_PLAYSND)	* test pyDriveWire, playsound
		bmi	unknownerror		* high bit set - old pyDriveWire
		beq	noplaysound		* zero - pyDriveWire, playsound disabled
		lda	#$01
		sta	SndFlg			* Set Sound Flag 
* Send PlaySound command to server
		ldx	#cmd			* command buffer
		ldy	#cmdlen			* command length
		lbsr	DWWrite			* Send it
		bcs	unknownerror		* error
* Get command result from server
		ldx	#databuf		* data buffer
		clr	,x			* Initialize error
		dec	,x
		ldy	#1			* 1 byte
		lbsr	DWRead			* Read the byte
		bcs	unknownerror		* erorr
		bne	noplaysound		* no bytes read - must be DriveWire3

		lda	,x			* check the return code
		cmpa	#0
		beq	done			* no error

		cmpa	#E_NOPLAYSOUND		* Playsound enabled?
		beq	noplaysound		* No, print error message

		cmpa	#E_READ			* File Exist?
		beq 	fnferror		* No, print error message

unknownerror
		ldx	#unknownerrormsg-1	* Fallthrough: unknown error
		clra				* Clear sound flag
		sta	SndFlg
		bra 	printerror		* Print error message	

noplaysound
		ldx	#noplaysoundmsg-1
		clra				* Clear sound flag
		sta	SndFlg
		bra 	printerror

fnferror	ldx	#fnfmsg-1
printerror
		andcc	#$fe
		jsr	$b99c
done
		rts


* Input - B client id
* Output - B result
*          X buffer
*          CC Carry set on error
DwInit
		ldx	#databuf
		lda	#OP_DWINIT				* DWInit Command
		std	,x					* B contains client id
		ldy	#2					* Command Length
		lbsr	DWWrite
		bcs	@nope					* error
		ldy	#1					* result length
		lbsr	DWRead
		bcs	@nope
		ldb	,x					* get result
		andcc	#$FE					* clear carry
@nope
		rts

* New Check Server - use the dwInit combo lock
* to get pyDriveWire features

* CheckServer - Check if the DriveWire Server is pyDriveWire and
*    return pyDriveWire features
* Output in CC - Carry bit set - error or not pyDriveWire 
*            B - 0xFF - pyDriveWire without enhanced DwInit support
*            B - bit 0 - pyDriveWire with EmCee Support
*            B - bit 1 - pyDriveWire with DLOAD support enabled
*            B - bit 2 - pyDriveWire with HDB-DOS support enabled
*            B - bit 3 - pyDriveWire with DosPlus support enabled
*            B - bit 4 - pyDriveWire with printer support enabled
*            B - bit 5 - pyDriveWire with ssh support enabled
*            B - bit 6 - pyDriveWire with playsound support enabled
*            B - bit 7 - Reserved - set only if old pyDriveWire server
CheckServer
* Combo lock stage 1: send 'p' OP_DWINIT must return $ff
		ldb	#'p'					* combo lock stage 1
		bsr	DwInit
		bcs	@err					* error
		cmpb	#'p'					* and check it
		bne	@err					* not pyDriveWire
* Combo lock stage 2: send 'y' OP_DWINIT must return $ff
		ldb	#'y'					* combo lock stage 2
		bsr	DwInit
		bcs	@err					* error
		cmpb	#'y'					* and check it
		bne	@err					* not pyDriveWire
* Combo lock stage 3: send 'F' OP_DWINIT Returns server features page 0
		ldb	#'E'					* combo lock stage 3
		bsr	DwInit
		bcs	@err					* error
		rts
@err		orcc	#%00000001				* Not pyDriveWire - set carry
		rts

* flags
SndFlg		fcb	1

* DW Command
cmd		fcb	OP_PLAYSOUND
		fcb	fnlen
filename	fcc "/usr/share/sounds/alsa/Front_Center.wav"
fnlen		equ .-filename
cmdlen		equ .-cmd

* Error messages
unknownerrormsg	fcc	"UNKNOWN ERROR OR NO PLAYSOUND EXTENSION"
		fcb	$0d,$00

unknownerrormsglen equ	.-unknownerrormsg

noplaysoundmsg	fcc	"PLAYSOUND NOT AVAILABLE"
		fcb	$0d,$00
noplaysoundmsglen equ	.-noplaysoundmsg

fnfmsg	fcc	"FILE NOT FOUND"
		fcb	$0d,$00
fnfmsglen equ	.-fnfmsg

* Data area
databuf		rmb 256

* Import DriveWire stuff
 use dwdefs.d
 use dwread.asm
 use dwwrite.asm

 end start
