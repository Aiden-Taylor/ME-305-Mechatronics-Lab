;**************************************************************************************
;* PS3 main [includes LibV2.2]                                                        *
;**************************************************************************************
;* Summary:                                                                           *
;*   Code for ME 305 PS3                                                              *
;*                                                                                    *
;* Author: Aiden Taylor                                                               *
;*   Cal Poly University                                                              *
;*   Fall 2023                                                                        *
;*                                                                                    *
;* Revision History:                                                                  *
;*   -                                                                                *
;*                                                                                    *
;* ToDo:                                                                              *
;*   - Done!                                                                          *
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

COUNT DS.B 1
BUFFER DS.B 5
RESULT DS.B 2
TMP DS.B 1
ERR DS.B 1




;/------------------------------------------------------------------------------------\
;|  Main Program Code                                                                 |
;\------------------------------------------------------------------------------------/
; Your code goes here

MyCode: SECTION
main:
		
		ldx #BUFFER
		movb #$30, 0,x     ;loading ASCII into the the BUFFER
		movb #$30, 1,x
		movb #$30, 2,x
		movb #$30, 3,x
		movb #$30, 4,x
		ldy #$32           ;loads random set values into y and b to confirm that they are preserved
		ldab #$33
		
spin:		
		
		movb #$05, COUNT   ;sets COUNT to 5
		
		bgnd               ;bgnd for debugging
		
	  jsr conversion     ;calls conversion	  
	  
    bra spin           ;loops 
		

		
    
        
;/------------------------------------------------------------------------------------\
;| Subroutines |
;/------------------------------------------------------------------------------------/
; Add subroutines here:

conversion:
		
		;init here
		clrw RESULT
		clr TMP
		clr ERR
		ldx #BUFFER
		pshy			;pushes registers to stack so that they remain unchanged by the subroutine
		pshb
		pshc
		
		
convloop:

		;loop goes here
		ldaa COUNT		;check if COUNT has finished for loop
		beq loopfin		;branch to exit if COUNT is done
		
		
		ldy RESULT		;load current value of RESULT into register y for use
		ldd #$000A		;load hex 10 into accumulator for use
		emul			    ;multiply register y and acc d
		tsty          ;sets flag for y
		bne ERR1      ;checks if the multiplication overflowed to y
		std RESULT		;keep the bottom 2 bytes of the emul since we are never dealing with 4 bit nums
		
		
		
		ldaa TMP		;TMP is used for index addressing
		ldab a,x		;reference the correct digit in the BUFFER using TMP
		subb #$30		;subtract $30 to get the decimal value of the ascii code
		
		
		clra
		addd RESULT		;add RESULT and acc d 
		bcs ERR1      ;branch if the addition triggers an overflow, causing error 1
		std RESULT		;store addition in RESULT
		inc TMP		  	;inc TMP so that BUFFER digits are correctly referenced
		dec COUNT		  ;dec COUNT to track how long the loop has operated for
		bra convloop
			

ERR1:		

		movb #$01, ERR ;set ERR for MAGNITUDE TOO LARGE
		bra cnvexit
	
loopfin:
		
		ldx RESULT     ;happens at the end of the loop to check for error 2
		bne cnvexit	
		
ERR2:

		movb #$02, ERR  ;set ERR for ZERO MAGNITUDE INAPPROPRIATE

cnvexit:

		ldaa ERR		;load ERRor into accumulator a
		pulc        ;pulls registers from stack to restore them to pre-subroutine states
		pulb
		puly
		rts         ;return



DELAY_1ms:
        ldy #$0584
        INNER: ; inside loop
        cpy #0
        beq EXIT
        dey
        bra INNER

EXIT:
        rts ; exit DELAY_1ms
        
;/------------------------------------------------------------------------------------\
;| Messages |
;/------------------------------------------------------------------------------------/
; Add ASCII messages here:
;/------------------------------------------------------------------------------------\
;| Vectors |
;\------------------------------------------------------------------------------------/
; Add intERRupt and reset vectors here:
        ORG $FFFE ; reset vector address
        DC.W Entry
