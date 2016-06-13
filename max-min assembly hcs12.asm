; Soner

; max sayıyı buluyor (max find)
; min sayıyı buluyor (min find)
; if max / min > 10
; bir adrese (put a adress)
; değilse başka bir adrese koyuyor (else put another address)


;*****************************************************************
;* This stationery serves as the framework for a                 *
;* user application (single file, absolute assembly application) *
;* For a more comprehensive program that                         *
;* demonstrates the more advanced functionality of this          *
;* processor, please see the demonstration applications          *
;* located in the examples subdirectory of the                   *
;* Freescale CodeWarrior for the HC12 Program directory          *
;*****************************************************************

; export symbols
            XDEF Entry, _Startup            ; export 'Entry' symbol
            ABSENTRY Entry        ; for absolute assembly: mark this as application entry point



; Include derivative-specific definitions 
		INCLUDE 'derivative.inc' 

ROMStart    EQU  $4000  ; absolute address to place my code/constant data

; variable/data section

            ORG RAMStart
 ; Insert here your data definition.
Counter     DS.W 1
FiboRes     DS.W 1

            ORG  $1200
arr         DC.B 12,10,13,19,21,1
COUNT       EQU  6
MAXNUM      EQU   $1400
COUNTADDR   EQU   $1402
TEMP        EQU   $1404
MINNUM      EQU   $1406
DIVMAX      EQU   $1408
DIVMIN      EQU   $140A


; code section
            ORG   ROMStart


Entry:
_Startup:
            CLRA
            STAA MAXNUM  ; MAXNUM = 0
            LDAA #COUNT
            LDX  #arr
            STAA COUNTADDR
            
loop:
            LDAB 1,X+
            DEC  COUNTADDR
            LDAA COUNTADDR
            CMPA #0
            BLT  minpart
            STAA COUNTADDR
            JMP  maxfind
            BRA  loop                       
            
maxfind:
            LDAA MAXNUM
            STAB TEMP
            CMPA TEMP
            BGE  loop
            JMP  maxhold
            RTS 
             
            
maxhold:
            STAB MAXNUM
            BRA  loop 

            
minpart:
            LDX  #arr
            LDAB 0,X
            STAB MINNUM  ; MINNUM = arr[0]
            LDAA #COUNT
            STAA COUNTADDR
            
loop2:
            LDAB 1,X+
            DEC  COUNTADDR
            LDAA COUNTADDR
            CMPA #0
            BLT  divpart
            STAA COUNTADDR
            JMP  minfind
            BRA  loop2
            
minfind:
            LDAA MINNUM
            STAB TEMP
            CMPA TEMP
            BLE  loop2
            JMP  minhold
            RTS
minhold:
            STAB MINNUM
            BRA  loop2
            
divpart:
            LDD  MAXNUM
            LDX  MINNUM
            IDIV
            STX  TEMP  ; quotient
            LDAA TEMP  ; A <- quotient
            CMPA #10   ; A < 10 ?
            BLE  holdformax
            BRA  holdformin
holdformax:
            STX DIVMAX
            BRA halt
holdformin:
            STX DIVMIN
            BRA halt

halt:            
            SWI 
            

;**************************************************************
;*                 Interrupt Vectors                          *
;**************************************************************
            ORG   $FFFE
            DC.W  Entry           ; Reset Vector
