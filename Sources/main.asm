
;*****************************************************************
;*************************
;*  Burak Demirci        *
;*  141044091            *
;*************************
;*******************************************************************
; export symbols
            XDEF Entry, _Startup            ; export 'Entry' symbol
            ABSENTRY Entry                  ; for absolute assembly: mark this as application entry point



; Include derivative-specific definitions 
		INCLUDE 'derivative.inc' 

ROMStart    EQU  $4000  ; absolute address to place my code/constant data
mySTR       EQU  $1200  ; Define String adresses
firstF      EQU  $1400  ; Define firs nuber integer part 
firstS      EQU  $1450  ; Define first number floating part 
secondF     EQU  $1600  ; Define second nuber integer part 
secondS     EQU  $1650  ; Define second number floating part 
operator    EQU  $1700  ; Define  operator 
temp1       EQU  $1800  ; Temp value 
multi       EQU  $1850  ; Temp value
ResultF     EQU  $1500  ; Result integer
ResultS     EQU  $1501  ; Result floating  
; variable/data section

            ORG RAMStart
 ; Insert here your data definition.
            ORG mySTR 
            FCC "32.30 + 17.28 ="


; code section
            ORG   ROMStart


Entry:
_Startup:
      CLRA
      STAA firstF  ; Clear all value
      STAA firstS  
      STAA secondF 
      STAA secondS
      LDAA #$55
      STAA DDRB    ; The first value portB
      CLRA
      LDX  #mySTR   
      JSR  Parser     
      
Parser

      FirstFirst:
         
         LDAA 0,X
         INX 
         STAA temp1
         SUBA #$2E             ; '.' char ascii value 2E  check        
         BEQ  FirstSecond       ; If equal       
         JSR  ACIItoDEC
         LDAA firstF
         JSR  MULTI
         ADDA temp1
         STAA firstF
         JMP  FirstFirst
         
   FirstSecond:
         LDAA 0,X
         INX
         STAA temp1
         SUBA #$20             ; ' ' char ascii value 20  check        
         BEQ  Operator         ; If equal       
         JSR  ACIItoDEC
         LDAA firstS
         JSR  MULTI
         ADDA temp1
         STAA firstS
         JMP  FirstSecond
   
    Operator:
         LDAA 0,X
         INX
         INX
         STAA operator      
         BEQ  SecodFirst  
       
                 
    SecodFirst:
         LDAA 0,X
         INX 
         STAA temp1
         SUBA #$2E               ; '.' char ascii value 2E  check        
         BEQ  SecondSecond       ; If equal       
         JSR  ACIItoDEC
         LDAA secondF
         JSR  MULTI
         ADDA temp1
         STAA secondF
         JMP  SecodFirst

     SecondSecond:
         LDAA 0,X
         INX
         STAA temp1
         SUBA #$20             ; ' ' char ascii value 20  check        
         BEQ  Calculate   ; '=' operator check       
         JSR  ACIItoDEC
         LDAA secondS
         JSR  MULTI
         ADDA temp1
         STAA secondS
         JMP  SecondSecond


ACIItoDEC
        LDAA temp1
        SUBA #$30   ; Conver to acii value to decimal 
        STAA temp1  ;
        RTS         ; Retrun 


MULTI               ; Calculate the number digit value
    CLRB
    LDAB #$9
    STAA multi
  Multiloop:
    ADDA multi
    DECB
    BNE Multiloop
    RTS


Calculate
      LDAA 0,X
      SUBA #$3D
      BNE  Ending   ; '=' operator not found !
      LDAA operator
      SUBA  #$2B    ; '+' operator ascii value
      BEQ Addition
  Subtraction:
      LDAA firstS
      SUBA secondS
      BLO  Negative  ; First one is less than second
      STAA temp1          
  Sub2:
      LDAA firstF  
      SUBA secondF
      STAA multi
      JMP  Ending 
  Negative:            ; If first floating part is less than second floatting part
      ADDA #100        ; 
      STAA temp1
      LDAA firstF
      SUBA #1
      STAA firstF
      JMP  Sub2

  Addition:
      LDAA firstS
      ADDA secondS
      STAA temp1
      LDAB #100
      SUBB temp1
      BLS  Carry      ; Carry jump
  Add2:    
      LDAA firstF
      ADDA secondF
      BCS  Warn       ; Branch is overflow
      STAA multi
      JMP  Ending
  Carry:
     SUBA #100
     STAA temp1    ; Floating part
     LDAA firstF
     ADDA #1       ; Carry adding
     STAA firstF  
     JMP  Add2   

Warn
  CLRB
  LDAB #$FF    ; If the overflow occur
  STAB DDRB    ; Warn the user
  STAB $1900
  RTS 
 
        
Ending
    LDAA multi      ; End the program and assign the value to memory location 
    STAA ResultF
    LDAA temp1
    STAA ResultS 
    


;**************************************************************
;*                 Interrupt Vectors                          *
;**************************************************************
            ORG   $FFFE
            DC.W  Entry           ; Reset Vector
