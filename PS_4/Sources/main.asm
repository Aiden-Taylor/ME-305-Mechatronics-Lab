;**************************************************************************************
;* PS4 main [includes LibV2.2]                                                        *
;**************************************************************************************
;* Summary:                                                                           *
;*   Code for ME 305 PS4                                                              *
;*                                                                                    *
;* Author: Julia Fay                                                                  *
;*   Cal Poly University                                                              *
;*   Fall 2023                                                                        *
;*                                                                                    *
;* Revision History:                                                                  *
;*   -                                                                                *
;*                                                                                    *
;* ToDo:                                                                              *
;*   -                                                                                *
;**************************************************************************************

;/------------------------------------------------------------------------------------\
;| Include all associated files                                                       |
;\------------------------------------------------------------------------------------/
; The following are external files to be included during assembly


;/------------------------------------------------------------------------------------\
;| External Definitions                                                               |
;\------------------------------------------------------------------------------------/
; All labels that are referenced by the linker need an external definition

              XDEF  main

;/------------------------------------------------------------------------------------\
;| External References                                                                |
;\------------------------------------------------------------------------------------/
; All labels from other files must have an external reference

              XREF ENABLE_MOTOR, DISABLE_MOTOR
              XREF STARTUP_MOTOR, UPDATE_MOTOR, CURRENT_MOTOR
              XREF STARTUP_PWM, STARTUP_ATD0, STARTUP_ATD1
              XREF OUTDACA, OUTDACB
              XREF STARTUP_ENCODER, READ_ENCODER
              XREF INITLCD, SETADDR, GETADDR, CURSOR_ON, CURSOR_OFF, DISP_OFF
              XREF OUTCHAR, OUTCHAR_AT, OUTSTRING, OUTSTRING_AT
              XREF INITKEY, LKEY_FLG, GETCHAR
              XREF LCDTEMPLATE, UPDATELCD_L1, UPDATELCD_L2
              XREF LVREF_BUF, LVACT_BUF, LERR_BUF,LEFF_BUF, LKP_BUF, LKI_BUF
              XREF Entry, ISR_KEYPAD
            
;/------------------------------------------------------------------------------------\
;| Assembler Equates                                                                  |
;\------------------------------------------------------------------------------------/
; Constant values can be equated here


;/------------------------------------------------------------------------------------\
;| Variables in RAM                                                                   |
;\------------------------------------------------------------------------------------/
; The following variables are located in unpaged ram

DEFAULT_RAM:  SECTION

Chan0 EQU $01
TIOS  EQU $0040
TCTL2 EQU $0049
TFLG1 EQU $004E
TMSK1 EQU $004C
TSCR  EQU $0046
TCNTH EQU $0044
TC0   EQU $0050


INTERVAL DS.W 1

;/------------------------------------------------------------------------------------\
;|  Main Program Code                                                                 |
;\------------------------------------------------------------------------------------/
; Your code goes here

MyCode: SECTION
main:
		   
		   
;Step 1: Pre-initialization
		   
		   movw #$03E8, INTERVAL ;Determine the number of bus clock counts that corresponds to 0.1 msec.
		   
;Step 2: Timer Initialization
		   
		   bset TIOS, Chan0   ; Set timer channel 0 for output compare
		   bset TCTL2,Chan0   ; Set timer channel 0 to toggle its output pin
		   bset TFLG1, Chan0  ; Clear timer channel flag by writing a 1 to it 
		   cli                ; Clear I bit 
		   bset TMSK1, Chan0  ; enable maskable interrupts 
		   

		   bset TSCR, %10100000 ; enable timer channel output compare intuerrupts 
		                        ; sets TEN = 1  (enable timer bit)
		                        ; sets TSBCK = 1 (timer stop in background mode) 

;Step 3: Generating the first interrupt		   
		  
		   ldd TCNTH            ; read current timer count 
		   addd INTERVAL        ; add interval to count 
		   std TC0              ; load result into TC0 
		   
		   		
spin: bra spin
    
        
;/------------------------------------------------------------------------------------\
;| Subroutines |
;/------------------------------------------------------------------------------------/
; Add subroutines here:

PS4_INT:

;Step 4: Generating subsequent interrupts
        
        ldd TC0             ; read current timer count  
        addd INTERVAL       ; add interval 
        std TC0             ; store result   
        bset TFLG1, Chan0   ; clear timer channel 0 flag by writing a 1 to it
       
        
        rti
;/------------------------------------------------------------------------------------\
;| Messages |
;/------------------------------------------------------------------------------------/
; Add ASCII messages here:
;/------------------------------------------------------------------------------------\
;| Vectors |
;\------------------------------------------------------------------------------------/
; Add interrupt and reset vectors here:
        ORG $FFFE ; reset vector address
        DC.W Entry
        
        ORG $FFEE      ;vector address of CH0 Timer Interrupts 
        DC.W PS4_INT
       