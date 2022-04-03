
* What type of drivewire?
* Real Coco2/3 bit banger - set all to 0
* Or set exactly one of these to 1
 IFNDEF BECKER
BECKER		EQU 0				* emulators, coco3fpga
 ENDC
 IFNDEF JMCPBCK
JMCPBCK		EQU 0
 ENDC
 IFNDEF BECKERTO
BECKERTO	EQU 0
 ENDC
 IFNDEF ARDUINO
ARDUINO		EQU 0
 ENDC
 IFNDEF BAUD38400
BAUD38400	EQU 0				* coco1 bit banger
 ENDC
 IFNDEF NOINTMASK
NOINTMASK	EQU 0
 ENDC
 IFNDEF H6309
H6309		EQU 0
 ENDC
 IFNDEF SY6551N
SY6551N		EQU 0				* rs232 pack
 ENDC
 IFNDEF COCO3FPGAWIFI
COCO3FPGAWIFI	EQU 0
 ENDC
 IFNDEF MEGAMINIMPI
MEGAMINIMPI     EQU 0
 ENDC

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
OP_PLYSNDSTP	EQU $FB
* Drivewire Errors
E_OK		EQU $00
E_NOPLAYSOUND   EQU $FA
E_READ		EQU $F4

* pyDriveWire Features
FEATURE_RESERVED EQU %10000000
FEATURE_PLAYSND  EQU %01000000

		org $4000
start
playsound
* PLAYSOUND
* Plays a sound through the drivewire server
* Input
*    X - filename buffer
*    B - filename length
* Output
*    B - Return Code
*	  0 - OK
*	255 - Unknonwn Error
*	254 - Playsound not available
*	250 - Playsound not enabled
*	244 - File not found
* Send PlaySound command to server
		clra				* Length in D
		pshs	d			* save length for later
		pshs	x			* save filename buffer(X) for later
		ldx	#cmd			* cmd buffer
		stb	1,x			* length (b)
		ldy	#cmdlen			* command length
		lbsr	DWWrite			* Send it
		bcs	unknownerror		* error
		puls	x			* filename buffer
		puls	y			* filename length
		lbsr	DWWrite			* Send it
		bcs	unknownerror		* error
* Get command result from server
		ldx	#buf			* data buffer
		clr	,x			* Initialize error
		dec	,x
		ldy	#buflen			* 1 byte
		lbsr	DWRead			* Read the byte
		bcs	unknownerror		* erorr
		bne	noplaysound		* no bytes read - must be DriveWire3

		ldb	,x			* get the return code
done
		rts				* no error


unknownerror
		ldb	#255			* unknown error 255
		rts 				* exit

noplaysound
		ldb	#254			* no playsouund error 254
		rts 				* exit

playstop
		ldx	#stpcmd
		ldy	#stplen
		lbsr	DWWrite
		rts

* DW Command
cmd		fcb	OP_PLAYSOUND
buf		rmb	1
cmdlen		equ .-cmd
buflen		equ .-buf

stpcmd		fcb	OP_PLYSNDSTP
stplen		equ .-stpcmd

* Import DriveWire stuff
 include dwdefs.d
 include dwread.asm
 include dwwrite.asm

 end start
