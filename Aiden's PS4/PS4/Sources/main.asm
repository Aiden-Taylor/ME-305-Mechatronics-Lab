;**************************************************************************************
;* PS4 main [includes LibV2.2]                                                        *
;**************************************************************************************
;* Summary:                                                                           *
;*   Code for ME 305 PS4                                                              *
;*                                                                                    *
;* Author: Aiden Taylor                                                               *
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


TIOS EQU $0040
TCTL2 EQU $0049
TFLG1 EQU $004E
TMSK1 EQU $004C
TSCR  EQU $0046
TCNTH EQU $0044
TC0H  EQU $0050


INTERVAL DS.W 1





;/------------------------------------------------------------------------------------\
;|  Main Program Code                                                                 |
;\------------------------------------------------------------------------------------/
; Your code goes here

MyCode: SECTION
main:
		   movw #$03E8, INTERVAL
		   
		   bset TIOS, %11111111
		   bset TCTL2, %00000001  
		   bset TFLG1, %11111111
		   cli
		   bset TMSK1, #$01
		   bset TSCR, %10100000
		   ldd TCNTH
		   addd INTERVAL
		   std TC0H
		   
		   
		   
		
	
		
spin: 
   
    bra spin
    
        
;/------------------------------------------------------------------------------------\
;| Subroutines |
;/------------------------------------------------------------------------------------/
; Add subroutines here:

isubrout:

        
        ldd TC0H
        addd INTERVAL
        std TC0H
        bset TFLG1, %11111111
       
        
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
        
        ORG $FFEE
        DC.W isubrout
        
