********************************************************************
* dwdefs - DriveWire Definitions File
*
* $Id: dwdefs.d,v 1.10 2010/02/21 06:24:47 aaronwolfe Exp $
*
* Ed.    Comments                                       Who YY/MM/DD
* ------------------------------------------------------------------
*   1    Started                                        BGP 03/04/03
*   2    Added DWGLOBS area                             BGP 09/12/27

         nam   dwdefs
         ttl   DriveWire Definitions File

* Addresses
BBOUT       equ    $FF20
BBIN        equ    $FF22

* Opcodes
OP_NOP      equ    $00		No-Op
OP_RESET1   equ    $FE		Server Reset
OP_RESET2   equ    $FF		Server Reset
OP_RESET3   equ    $F8		Server Reset
OP_DWINIT	equ	   'Z		DriveWire dw3 init/OS9 boot
OP_TIME     equ    '#	 	Current time requested
OP_INIT     equ    'I		Init routine called
OP_READ     equ    'R		Read one sector
OP_REREAD   equ    'r		Re-read one sector
OP_READEX   equ    'R+128	Read one sector
OP_REREADEX equ    'r+128	Re-read one sector
OP_WRITE    equ    'W		Write one sector
OP_REWRIT   equ    'w		Re-write one sector
OP_GETSTA   equ    'G		GetStat routine called
OP_SETSTA   equ    'S		SetStat routine called
OP_TERM     equ    'T		Term routine called
OP_SERINIT  equ    'E
OP_SERTERM  equ    'E+128

* Printer opcodes
OP_PRINT    equ    'P		Print byte to the print buffer
OP_PRINTFLUSH equ  'F		Flush the server print buffer

* Serial opcodes
OP_SERREAD equ 'C
OP_SERREADM equ 'c
OP_SERWRITE equ 'C+128
OP_SERGETSTAT equ 'D
OP_SERSETSTAT equ 'D+128

* for dw vfm
OP_VFM equ 'V+128

* WireBug opcodes (Server-initiated)
OP_WIREBUG_MODE  equ   'B
* WireBug opcodes (Server-initiated)
OP_WIREBUG_READREGS   equ  'R	Read the CoCo's registers
OP_WIREBUG_WRITEREGS  equ  'r	Write the CoCo's registers
OP_WIREBUG_READMEM    equ  'M	Read the CoCo's memory
OP_WIREBUG_WRITEMEM   equ  'm	Write the CoCo's memory
OP_WIREBUG_GO         equ  'G	Tell CoCo to get out of WireBug mode and continue execution

* VPort opcodes (CoCo-initiated)
OP_VPORT_READ         equ  'V
OP_VPORT_WRITE        equ  'v

* Error definitions
E_CRC      equ   $F3            Same as NitrOS-9 E$CRC

* * DW Globals Page Definitions (must be 256 bytes max)
* DW.StatCnt equ   15
*            org   $00
* DW.StatTbl rmb   DW.StatCnt     page pointers for terminal device static storage
* DW.VIRQPkt rmb   Vi.PkSz
* DW.VIRQNOP rmb   1
* 
* * SCF Multi Terminal Driver Definitions
* 
*          	org   	        V.SCF      	;V.SCF: free memory for driver to use
* SSigID          rmb             1              ;process ID for signal on data ready
* SSigSg          rmb             1              ;signal on data ready code
* RxDatLen	rmb		1              ;current length of data in Rx buffer
* RxBufSiz	rmb		1              ;Rx buffer size
* RxBufEnd	rmb		2              ;end of Rx buffer
* RxBufGet	rmb		2              ;Rx buffer output pointer
* RxBufPut	rmb		2              ;Rx buffer input pointer
* RxGrab		rmb		1              ;bytes to grab in multiread
* RxBufPtr	rmb		2              ;pointer to Rx buffer
* RxBufDSz	equ		256-.          ;default Rx buffer gets remainder of page...
* RxBuff		rmb		RxBufDSz       ;default Rx buffer
* SCFDrvMemSz     equ             .
