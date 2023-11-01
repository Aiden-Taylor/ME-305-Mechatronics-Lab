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

INTERVAL EQU $64






;/------------------------------------------------------------------------------------\
;|  Main Program Code                                                                 |
;\------------------------------------------------------------------------------------/
; Your code goes here

MyCode: SECTION
main:
		   bset $0040, %11111111
		   bset $0050, %11111111
		   bset $0051, %11111111
		   bset $0049, %00000001  
		   bset $004E, %11111111
		   sei
		   bset $004C, #$01
		   bset $0046, %10100000
		   ldd $0044
		   addd INTERVAL
		   std $0050
		   
		   
		   
		
	
		
spin: 
   
    bra spin
    
        
;/------------------------------------------------------------------------------------\
;| Subroutines |
;/------------------------------------------------------------------------------------/
; Add subroutines here:


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
        pshd
        pshc
        ldd $0044
        addd INTERVAL
        std $0050
        bset $0049, %00000001
        
        rti
