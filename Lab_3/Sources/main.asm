;**************************************************************************************
;* Lab 3 Main [includes LibV2.2]                                              *
;**************************************************************************************
;* Summary:                                                                           *
;*   -                                                                                *
;*                                                                                    *
;* Author: Aiden Taylor & Julia Fay                                                   *
;*   Cal Poly University                                                              *
;*   Fall 2023                                                                      *
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

              XREF  ENABLE_MOTOR, DISABLE_MOTOR
              XREF  STARTUP_MOTOR, UPDATE_MOTOR, CURRENT_MOTOR
              XREF  STARTUP_PWM, STARTUP_ATD0, STARTUP_ATD1
              XREF  OUTDACA, OUTDACB
              XREF  STARTUP_ENCODER, READ_ENCODER
              XREF  INITLCD, SETADDR, GETADDR, CURSOR_ON, CURSOR_OFF, DISP_OFF
              XREF  OUTCHAR, OUTCHAR_AT, OUTSTRING, OUTSTRING_AT
              XREF  INITKEY, LKEY_FLG, GETCHAR
              XREF  LCDTEMPLATE, UPDATELCD_L1, UPDATELCD_L2
              XREF  LVREF_BUF, LVACT_BUF, LERR_BUF,LEFF_BUF, LKP_BUF, LKI_BUF
              XREF  Entry, ISR_KEYPAD
            
;/------------------------------------------------------------------------------------\
;| Assembler Equates                                                                  |
;\------------------------------------------------------------------------------------/
; Constant values can be equated here



;/------------------------------------------------------------------------------------\
;| Variables in RAM                                                                   |
;\------------------------------------------------------------------------------------/
; The following variables are located in unpaged ram

DEFAULT_RAM:  SECTION

;params for t1 

COUNT DS.B 1
F1_FLG  DS.B 1
F2_FLG  DS.B 1
SPEED1  DS.B 1 
SPEED2  DS.B 1
ON1     DS.B 1 
ON2     DS.B 1 

;params for t2 
KEY_FLG DS.B 1
KEY_BUFF DS.W 1

;params for t3
MSG_NUM DS.B 1

;state vars
t1state DS.B 1
t2state DS.B 1
t3state DS.B 1
t4state DS.B 1
t5state DS.B 1
t6state DS.B 1
t7state DS.B 1
t8state DS.B 1

;subroutines ---------

;convert
RESULT DS.W 1 
BUFFER DS.B 5
TMP DS.B 1
ERR DS.B 1 

;input
INPUT DS.B 1
DPTR DS.W 1
FIRSTCH DS.B 1

;/------------------------------------------------------------------------------------\
;|  Main Program Code                                                                 |
;\------------------------------------------------------------------------------------/
; Your code goes here

MyCode:       SECTION
main:  
       clr t1state ; initialize all tasks to state0
       clr t2state
       clr t3state
       clr t4state
       clr t5state
       clr t6state
       clr t7state
       clr t8state
       
       
       
spin: bra spin

;-------------TASK_1 MASTERMIND ---------------------------------------------------------

TASK_1: ldaa t1state ; get current t1state and branch accordingly
        beq t1s0
        deca
        beq t1s1
        deca
        beq t1s2
        deca
        beq t1s3
        deca
        beq t1s4
        deca
        beq t1s5
        deca
        beq t1s6
        rts ; undefined state - do nothing but return
;__________________________________________________________________________________
t1s0: ; init TASK_1

;clear all of the flags 

  clr COUNT 


        movb #$01, t1state ; set next state
        rts
;__________________________________________________________________________________
t1s1: ;

;check if its F1

        tst KEY_FLG                                 ;first test if there is a key to be checked
        beq exit1                                   ;if there is no 
        ldaa KEY_BUFF                               ;load accumulator A with the current char
        cmpa $F1                                    ;compare whats in A to F1 
        bne skipF1                                  ;if its not F1, skip settting the state
        movb #$05 , t1state                         ;set the state to the appropriate number  
        rts

skipF1:  

;check if its F2
                          
        cmpa $F2                                    ;compare whats in A to F2
        bne skipF2                                  ;if its not F2, skip settting the state
        movb #$06 , t1state                         ;set the state to the appropriate number 
        rts

skipF2:

;check if its a BS 
       
        cmpa $08                                    ;compare whats in A to BS 
        bne skipBS                                  ;if its not BS, skip settting the state 
        movb #$04 , t1state                         ;set the state to the appropriate number 
        rts

skipBS: 

;check if its a ENT  

        cmpa $0A                                    ;compare whats in A to ENT 
        bne skipENT                                 ;if its not BS, skip settting the state 
        movb #$03 , t1state                         ;set the state to the appropriate number 
        rts

;check if its a digit 

        cmpa #$39                                   ;check if what in A is a number 
        bne skipDIGIT                               ;if its not a number, disregard the input 
        movb #$02 , t1state                         ;set the state to digit handler 
        rts

skipDIGIT: 

        rts

;___________________________________________________________________________________

t1s2: ;Digit Handler 

;checks if we should proceed with the digit handler state 

        tst F1_FLG                                  ;test F1 flag 
        bne skip_e                                  ;if not equal to 0, skip exiting 
        tst F2_FLG                                  ;test the F2 flag 
        bne skip_e                                  ;if not equal to 0, skip exiting 
        bra exit1                                   ;exit if equal to 0 

skip_e:

;now proceed with the digit handler
   
        ldy #BUFFER                                 ;load index register y with buffer 
        ldaa COUNT                                  ;load A with the current value of COUNT 
        ldab KEY_BUFF                               ;load b with KEY_BUFF 
        stab a,y                                    ;store the contents of b at the position of COUNT in BUFFER
       
        inc COUNT                                   ;increment count 
        movb #$00, KEY_FLG                          ;set key flag to 0 to acknowledge KEYPAD
        movb #$01 , t1state                         ;set the state back to 1 
        bra exit1                                   ;exit 
;________________________________________________________________________________________
t1s3: ;ENT 
 
       jsr conversion                              ;convert the contents of buffer to binary 
       clr COUNT                                   ;set count back to zero 
       clr BUFFER                                  ;clear the contents of the BUFFER
       
;check which flag to set 
 
       tst F1_FLG                                  ;test the F1 flag
       beq skip_F1_a                               ;if the flag is zero, skip the next steps 
       movb #01, ON1                               ;if the flag is 1, set ON1 to be true 
       clr F1_FLG                                  ;clear the F1 flag
       stx SPEED1                                  ;store the 
         

skip_F1_a:  
 
       tst F2_FLG                                  ;test the F2 flag
       beq skip_F2                               ;if the flag is zero, skip the next steps 
       movb #$01, ON2                              ;if the flag is 1, set ON2 to be true 
       clr F2_FLG                                  ;clear the F2 flag 

skip_F2: 

       movb #$01, tstate1                          ;set the state back to 1 
       
;check for error and set variables accordingly so that user has to start over 

       cmpa #$00                                   ;check whats in A 
       beq skipERROR                               ;check if an error was generated from conversion
       movb #$07, tstate1                         ;if there is an error code set the state to the 
                                                   ;error state  
;check which ON variable needs to be cleared 
      
      
      tst F1_FLG                                   ;test the F1 flag
      beq skip_F1_b                                ;if the flag is zero, skip the next steps 
      clr ON1
      
skip_F1_b: 
 
      tst F2_FLG                                   ;test the F2 flag
      beq skipERROR                                ;if the flag is zero, skip the next steps
      clr ON2 
                  
skipERROR: 
       
      clr F1_FLG                                   ;clear F1_FLG 
      clr F2_FLG                                   ;clear F2_FLG 
      bra exit1                                    ;exit
 ;________________________________________________________________________________________
t1s4: ;BS
 
       movb #$03 , t3state                         ;set the state in task 3 to the BS state   
       movb #$01 , t1state                         ;set the state back to 1
       bra exit1                                   ;exit
 ;________________________________________________________________________________________
t1s5: ;F1 state 
 
 
       movb #$01, F1_FLG                           ;set the F1_FLG to be true
       movb #$01 , t1state                         ;set the state back to 1 
       bra exit1                                   ;exit
       
 ;________________________________________________________________________________________
t1s6: ;F2 state 
 
 
       movb #$01, F2_FLG                           ;set the F2_FLG to be true
       movb #$01 , t1state                         ;set the state back to 1
       bra exit1                                   ;exit

;________________________________________________________________________________________
t1s7: ;Error state 


  ;setting the error number 



exit1:
        rts
;----------------------TASK 2-------------------------------------------; 
 
TASK_2:
 
       
        ldaa t2state ;get state
        beq t2s0
        deca
        beq t2s1
        deca
        beq t2s2
        rts


t2s0:

        ;init
        
        jsr INITKEY       ;initialize keypad
        movb #$01, t2state
        rts
        
t2s1:     
   
        tst LKEY_FLG
        beq exit2
        jsr GETCHAR
        stab #KEY_BUFF     ;stores the input char into key buffer
        set KEY_FLG        ;notifies MM of key input
        movb #$02, t2state
        bra exit2                                   ;exit
        
t2s2:

        tst KEY_FLG
        bne exit2
        movb #$01, t2state
        

exit2: rts        
        
        
;---------------------TASK 3------------------------------------------------;

TASK_3:

        ldaa t3state
        beq t3s0
        deca
        beq t3s1
        deca
        beq t3s2
        deca
        beq t3s3
        deca
        beq t3s4
        deca
        beq t3s5
        deca
        beq t3s6
        deca
        beq t3s7
        deca
        beq t3s8
        deca
        beq t3s9
        deca
        beq t3s10
        deca
        beq t3s11
        rts
        
t3s0:     ;init    
        
       jsr INITLCD       ;initialize LCD
       set FIRSTCH
       ldaa #$00         ;set LCD position to 0
       jsr SETADDR
       jsr CURSOR_ON     ;turn on cursor
       movb #$0B, t3state ; go to init state 
       rts
        
t3s1:

       ;hub
       set FIRSTCH
       ldab MSG_NUM            
       stab t3state            
       rts


t3s2:   ;backspace
        jsr backspace
        rts

        
t3s3:   ;full time1 message     
        ldaa #$00
        ldx #TIME1
        tst FIRSTCH
        bne char1
        jsr PUTCHAR
        rts
        
        
t3s4:   ;full time2 message
        ldaa #$40
        ldx #TIME2
        tst FIRSTCH
        bne char1
        jsr PUTCHAR
        rts


t3s5:   ;no digit 1 message
        ldaa #$00
        ldx #NODIG1
        tst FIRSTCH
        bne char1
        jsr PUTCHAR
        rts


t3s6:   ;no digit 2 message
        ldaa #$40
        ldx #NODIG2
        tst FIRSTCH
        bne char1
        jsr PUTCHAR
        rts
        

t3s7:   ;zero magnitude 1 message
        ldaa #$00
        ldx #ZMAG1
        tst FIRSTCH
        bne char1
        jsr PUTCHAR
        rts

t3s8:   ;zero magnitude 2 message
        ldaa #$40
        ldx #ZMAG2
        tst FIRSTCH
        bne char1
        jsr PUTCHAR
        rts

t3s9:   ;magnitude too large 1 message
        ldaa #$00
        ldx #MAGTL1
        tst FIRSTCH
        bne char1
        jsr PUTCHAR
        rts


t3s10:  ;magnitude too large 2 message
        ldaa #$40
        ldx #MAGTL2
        tst FIRSTCH
        bne char1
        jsr PUTCHAR
        rts

t3s11:  ;display full screen (init message)

       ldx #INITMSG
       tst FIRSTCHAR
       bne initmsg
       jsr ICHAR
       rts
       
initmsg: ;first char of init message
       
       jsr ICHAR1
       rts
       
char1:    ;first char of any message

       jsr PUTCHAR1
       rts 
        
exit3:

       rts
        
  
;/------------------------------------------------------------------------------------\
;| Subroutines                                                                        |
;\------------------------------------------------------------------------------------/
; General purpose subroutines go here

  
 ;---------------------------------------------------------------------------------------     
         
  backspace:
 
       jsr GETADDR                   ;get current position of LCR
       deca                          ;decrement one
       jsr SETADDR                   ;set address to new position
       ldx #BACKSPACE                ;
       jsr OUTSTRING                 ;output a blank character
       jsr GETADDR                   ;get current position of LCR
       deca                          ;decrement one
       jsr SETADDR                   ;set address to new position
       dec COUNT                     ;reset the value of count
     
       bra input_loop               ;branch back to the top of the loop
 
       
   input_exit:
 
       ldaa #$00
       ldx #RESPONSE      ;load message into x
       jsr OUTSTRING_AT     ;display message
       rts    ;return to main 
  
  ;------CONVERSIONS---------------------------------------------------------------------------;

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
        

;-------------------Cooperative Fixed Messaging-------------------------------------------;        

PUTCHAR1:    
          stx DPTR
          jsr SETADDR
          clr FIRSTCH
          
PUTCHAR:          
          ldx DPTR
          ldab 0,x
          beq mess_exit
          incw DPTR
          jsr OUTCHAR
          rts


mess_exit:

            movb #$01, t3state
            movb #$01, MSG_NUM
            rts

;-------------------Cooperative Fixed init message-----------------------

ICHAR1: 
          stx DPTR
          jsr SETADDR
          clr FIRSTCH
          
ICHAR:        
          ldx DPTR
          ldab 0,x
          beq mess_exit
          incw DPTR
          jsr OUTCHAR
          jsr GETADDR
          cmpa #$28
          beq changeline
          rts

changeline: 

          ldaa #$40
          jsr SETADDR
          rts




;/------------------------------------------------------------------------------------\
;| ASCII Messages and Constant Data                                                   |
;\------------------------------------------------------------------------------------/
; Any constants can be defined here

 INITMSG: DC.B 'TIME1 =     <F1> to update LED1 periodTIME2 =     <F2> to update LED1 period', $00
 TIME1:  DC.B 'TIME1 =     <F1> to update LED1 period', $00
 TIME2:  DC.B 'TIME2 =     <F2> to update LED1 period', $00
 NODIG1: DC.B 'TIME1 = NO DIGITS ENTERED             ', $00
 NODIG2: DC.B 'TIME2 = NO DIGITS ENTERED             ', $00
 ZMAG1:  DC.B 'TIME1 = ZERO MAGNITUDE INAPPROPRIATE  ', $00
 ZMAG2:  DC.B 'TIME2 = ZERO MAGNITUDE INAPPROPRIATE  ', $00
 MAGTL1: DC.B 'TIME1 = MAGNITUDE TOO LARGE           ', $00
 MAGTL2: DC.B 'TIME2 = MAGNITUDE TOO LARGE           ', $00
 BACKSPACE: DC.B ' ' , $00 
 
 
;/------------------------------------------------------------------------------------\
;| Vectors                                                                            |
;\------------------------------------------------------------------------------------/
; Add interrupt and reset vectors here

        ORG   $FFFE                    ; reset vector address
        DC.W  Entry

