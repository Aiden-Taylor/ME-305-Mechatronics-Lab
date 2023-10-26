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

;subroutines
RESULT DS.W 1
COUNT DS.B 1 
BUFFER DS.B 5 
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
        rts
        
        
t2s2:

        tst KEY_FLG
        bne exit2
        movb #$01, t2state
        

exit2: rts        
        
        
;---------------------TASK 3------------------------------------------------;

TASK_3

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

input:
       
;create loop to load buffer with inputted variables
     
       clr COUNT
       ldy #BUFFER
       
  input_loop:
 
       ldaa COUNT              ;load accumulator a with the value of COUNT
       cmpa #$05               ;accumulator a - $5    check if COUNT is 5
       beq input_exit          ;if count is 5 then we are done and exit the loop
       
       
       jsr GETCHAR             ;load accumulator b with the keypad input
       cmpb #$08               ;accumulator b - $08    check if input is a backspace
       beq backspace           ;if it was a backspace, branch to the backspace routine
       
       
       
       cmpb #$39               ;accumulator b - $39    check if input is a number
       bgt input_loop         ;if input is not a number, go to the top of the loop
       
       stab a, y               ;load the contents of accumulator b into buffer
       jsr OUTCHAR             ;display the input charater on the LCD
       
       inc COUNT               ;increment count
       bra input_loop         ;branch back to the top of the loop
       
       
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
  
  ;-------------------------------------------------------------------------------------

convert:

        clrw RESULT              ;sets RESULT to zero
        clr TMP  
                       ;sets TMP to zero
                      
 ldx #BUFFER            ;load index register x with the contents of BUFFER                       
                       
                       
convert_loop:
       
;check status of loop
       
        ldaa COUNT             ;load accumulator a with the value of COUNT
        beq convert_exit       ;if count is 0 then we are done and exit the loop
       
;multiply current result value by 10

        ldy RESULT             ;load index register y with the contents of RESULT
        ldd #$000A             ;load accumulator d with the hex value for 10
        emul                   ;multiply the contents of d with the contents of y
        std RESULT             ;store the contents of accumulator d in result
       
;get the next number to be added

  
        ldaa TMP               ;load index register A with the position value TMP
        ldab a,x               ;load accumulator b with the contents of buffer at position a
        subb #$30              ;subtract #$30 to get the digital value of the numnber
               
;add the number to the multiplied result value and store the result
 
        clra                   ;clear the contents of accumulator a
        addd RESULT            ;add the contents of accumulator d to result
        std RESULT             ;store the contents of accumulator d in result
        inc TMP                ;increment so the next position can be reached
        dec COUNT              ;decrement count to keep tack of the loop
        bra convert_loop       ;loop back to the top  
 
 convert_exit:
     
        rts ; return to main

        
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

