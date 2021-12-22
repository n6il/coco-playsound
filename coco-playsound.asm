
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

		org $4000
start
* Check if server is pyDriveWire
		bsr	CheckServer
		bcs 	noplaysound
* Send PlaySound command to server
		ldx	#cmd			* command buffer
		ldy	#cmdlen			* command length
		lbsr	DWWrite
		bcs	unknownerror
* Get command result from server
		ldx	#databuf		* data buffer
		clr	,x			* Initialize error
		dec	,x
		ldy	#1			* 1 byte
		lbsr	DWRead
		bcs	unknownerror
		bne	noplaysound

		lda	,x
		cmpa	#0
		beq	done			* no error

		cmpa	#E_NOPLAYSOUND		* Playsound enabled?
		beq	noplaysound		* No, print error message

		cmpa	#E_READ			* File Exist?
		beq 	fnferror		* No, print error message

unknownerror
		ldx	#unknownerrormsg-1	* Fallthrough: unknown error
		bra 	printerror		* Print error message	

noplaysound	ldx	#noplaysoundmsg-1
		bra 	printerror

fnferror	ldx	#fnfmsg-1
printerror
		andcc	#$fe
		jsr	$b99c
done
		rts


DwGetStatus
		ldx	#databuf
		lda	#OP_SERREAD
		sta	,x
		ldy	#1
		lbsr	DWWrite
		bcs	@rts
		lda	#OP_SERREAD
		sta	,x
		ldy	#2
		lbsr	DWRead
		bcs	@rts
		ldd	,x
@rts
		rts
CheckServer
* 1. OP_DWINIT must return $ff
		ldx	#databuf
		lda	#OP_DWINIT
		sta	,x
		ldy	#1
		lbsr	DWWrite
		lbcs	nope
		ldy	#1
		lbsr	DWRead
		lbcs	nope
		lda	,x
		cmpa	#$FF
		lbne	nope
* 2. Open channel
		ldx	#databuf
		lda	#OP_SERSETSTAT
		ldb	#1			* channel 1
		std	,x
		lda	#SS.Open		* operation
		sta	2,x
		ldy	#3
		lbsr	DWWrite
* 3. status
		bsr	DwGetStatus
		lbcs	nope
* 4. send command
		ldx	#ATI
		ldy	#ATIlen
		lbsr	DWWrite
		bcs	nope
* 5. get status and length
		bsr	DwGetStatus
		lbcs	nope
		cmpa	#18			* channel 1
		bne	nope
* 6. read data command
		ldx	#databuf
		lda	#OP_SERREADM		* command
		sta	,x
		lda	#1			* channel
		sta	1,x
		stb	2,x			* data length
		pshs	b			* save length for later
		clra				* save length for later again
		pshs	d
		ldy	#3			* command length
		lbsr	DWWrite			* write it
		bcs	nope
* 7. read the data
		puls	y			* get length back
		lbsr	DWRead			* read it
		bcs	nope			* error
		bne	nope			* not enough bytes read
* 8. parsing
* "pyDriveWire v0.5d"
		puls	b			* get length back
		ldy	#pyDriveWire		* compare string
		ldx	#databuf		* input data
@loop		cmpy	#pyDriveWireEnd		* if got to end of compare string
		beq	@zero			* found it, start parsing major version
		cmpb	#0			* check if more input data
		beq 	nope
		lda	,x+			* get next input data
		decb				* decrement input data counter
		cmpa	,y			* compare input to current pos in compare string
		bne	@loop			* nope move along in input string
		leay	1,y			* found, move compare string
		bra	@loop
@zero
		lda	,x+			* check major version
		cmpa	#'0'
		beq	@dot			* major version is 0, go for dot then minor
		blo	nope			* not a digit
		cmpa	#'9'
		bhi	nope			* not a digit
		bra	@ok			* Major version is higher than 0 - ok!
@dot
		lda	,x+			* look for the dot
		cmpa	#'.'			
		bne	nope			* this is not valid
@minor		lda	,x+			* minor version
		cmpa	#'5'
		blo	nope			* less than 5
@sub		lda	,x+			* sub version
		cmpa	#'d'
		blo	nope			* too low
@ok
		andcc 	#$FE			* clear carry
		rts
nope		orcc	#$01			* set carry
		rts
ATI		fcb	OP_SERWRITEM,$01,ATImsglen
ATImsg		fcc	"ATI"
		fcb	$0d
ATImsglen	equ	.-ATImsg
ATIlen		equ	.-ATI
pyDriveWire	fcc	"pyDriveWire v"
pyDriveWireEnd	equ	.
* flags
SndFlg		fcb	1

* DW Command - Playsound Check
chkcmd		fcb	OP_PLAYSOUND
		fcb	0
chkcmdlen		equ .-chkcmd
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
