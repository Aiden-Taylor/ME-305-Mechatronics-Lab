;**************************************************************************************
;* Blank Project Main [includes LibV2.2]                                              *
;**************************************************************************************
;* Summary:  PS 3                                                                     *
;*   -                                                                                *
;*                                                                                    *
;* Author: Julia Fay                                                                  *
;*   Cal Poly University                                                              *
;*   Spring 2022                                                                      *
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

COUNT DS.B 1 
BUFFER DS.B 5 
INPUT DS.B 1 
RESULT DS.B 1 
TMP DS.B 1 

;/------------------------------------------------------------------------------------\
;|  Main Program Code                                                                 |
;\------------------------------------------------------------------------------------/
; Your code goes here

MyCode:       SECTION
main:   
       
       ;initialization 
         
       jsr INITLCD       ;initialize LCD 
       ldaa #$00         ;set LCD position to 0
       ldx #MESSAGE      ;load message into x 
       jsr OUTSTRING     ;display message 
       jsr INITKEY       ;initialize keypad 
       jsr CURSOR_ON     ;turn on cursor 
       
       jsr input 
       jsr convert 
       
       
 spin: bra spin  
       
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

        clr RESULT              ;sets RESULT to zero 
        clr TMP  
                       ;sets TMP to zero 
convert_loop:
        
;check status of loop 
        
        ldaa COUNT             ;load accumulator a with the value of COUNT 
        beq convert_exit       ;if count is 0 then we are done and exit the loop
        
;multiply current result value by 10 

        ldy RESULT             ;load index register y with the contents of RESULT
        ldd #$000A             ;load accumulator d with the hex value for 10 
        emul                   ;multiply the contents of d with the contents of y 
        sty RESULT             ;store the contents of accumulator d in result
       
;get the next number to be added 

        ldx #BUFFER            ;load index register x with the contents of BUFFER
        ldaa TMP               ;load index register A with the position value TMP 
        ldab a,X               ;load accumulator b with the contents of buffer at position a 
        subb #$30              ;subtract #$30 to get the digital value of the numnber 
               
;add the number to the multiplied result value and store the result 
  
        clra                   ;clear the contents of accumulator a 
        addb RESULT            ;add the contents of accumulator d to result 
        stab RESULT            ;store the contents of accumulator d in result 
        inc TMP                ;increment so the next position can be reached 
        dec COUNT              ;decrement count to keep tack of the loop 
        bra convert_loop       ;loop back to the top   
 
 convert_exit: 
      
        rts ; return to main  
         
        

;/------------------------------------------------------------------------------------\
;| Subroutines                                                                        |
;\------------------------------------------------------------------------------------/
; General purpose subroutines go here


;/------------------------------------------------------------------------------------\
;| ASCII Messages and Constant Data                                                   |
;\------------------------------------------------------------------------------------/
; Any constants can be defined here

 MESSAGE: DC.B  'please enter a number: ', $00
 RESPONSE: DC.B 'that was a great choice' , $00
 BACKSPACE: DC.B ' ' , $00 
 
;/------------------------------------------------------------------------------------\
;| Vectors                                                                            |
;\------------------------------------------------------------------------------------/
; Add interrupt and reset vectors here

        ORG   $FFFE                    ; reset vector address
        DC.W  Entry

