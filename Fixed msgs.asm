TOP:  		DC.B '1: SAW, 2: SINE-7, 3: SQUARE, 4: SINE-15', $00	;message for the top of the screen

SAW:  		DC.B 'SAWTOOTH WAVE        NINT:     [1-->255]', $00	;message for when SAWTOOTH is chosen
SAWE1: 		DC.B 'SAWTOOTH WAVE        MAGNITUDE TOO LARGE', $00	;message for when SAWTOOTH MAGNITUDE TOO LARGE
SAWE2:  	DC.B 'SAWTOOTH WAVE        INVALID MAGNITUDE  ', $00	;message for when SAWTOOTH INVALID MAGNITUDE  
SAWE3:  	DC.B 'SAWTOOTH WAVE        NO DIGITS ENTERED  ', $00	;message for when SAWTOOTH NO DIGITS ENTERED  

SEG7:		DC.B '7-SEGMENT SINE WAVE  NINT:     [1-->255]', $00	;message for when 7 Seg sine is chosen
SEG7E1:		DC.B '7-SEGMENT SINE WAVE  MAGNITUDE TOO LARGE', $00	;message for when 7 Seg sine MAGNITUDE TOO LARGE
SEG7E2:		DC.B '7-SEGMENT SINE WAVE  INVALID MAGNITUDE  ', $00	;message for when 7 Seg sine INVALID MAGNITUDE  
SEG7E3:		DC.B '7-SEGMENT SINE WAVE  NO DIGITS ENTERED  ', $00	;message for when 7 Seg sine NO DIGITS ENTERED  

SQUARE:		DC.B 'SQUARE WAVE          NINT:     [1-->255]', $00	;message for when SQUARE is chosen
SQUAREE1:	DC.B 'SQUARE WAVE          MAGNITUDE TOO LARGE', $00	;message for when SQUARE MAGNITUDE TOO LARGE
SQUAREE2:	DC.B 'SQUARE WAVE          INVALID MAGNITUDE  ', $00	;message for when SQUARE INVALID MAGNITUDE  
SQUAREE3:	DC.B 'SQUARE WAVE          NO DIGITS ENTERED  ', $00	;message for when SQUARE is chosen

SEG15:		DC.B '15-SEGMENT SINE WAVE NINT:     [1-->255]', $00	;message for when 15 seg sine is chosen
SEG15E1:	DC.B '15-SEGMENT SINE WAVE MAGNITUDE TOO LARGE', $00	;message for when 15 seg sine MAGNITUDE TOO LARGE
SEG15E2:	DC.B '15-SEGMENT SINE WAVE INVALID MAGNITUDE  ', $00	;message for when 15 seg sine INVALID MAGNITUDE  
SEG15E3:	DC.B '15-SEGMENT SINE WAVE NO DIGITS ENTERED  ', $00	;message for when 15 seg sine NO DIGITS ENTERED  

SAWTOOTH:
		DC.B 2 		; number of segments for SAWTOOTH
		DC.W 0	 	; initial DAC input value
		DC.B 19	 	; length for segment_1
		DC.W 172 	; increment for segment_1
		DC.B 1	 	; length for segment_2
		DC.W -3268 	; increment for segment_2
		
SQUARE:
		DC.B 4 		; number of segments for TRIANGLE
		DC.W 0	 	; initial DAC input value
		DC.B 9	 	; length for segment_1
		DC.W 0 		; increment for segment_1
		DC.B 1	 	; length for segment_2
		DC.W 3268 	; increment for segment_2
		DC.B 9	 	; length for segment_3
		DC.W 0	 	; increment for segment_3
		DC.B 9	 	; length for segment_4
		DC.W -3268 	; increment for segment_4
		
SINE_7:
		DC.B 7		; number of segments for SINE_7
		DC.W 2048	; initial DAC input value
		DC.B 25		; length for segment_1
		DC.W 33		; increment for segment_1
		DC.B 50		; length for segment_2
		DC.W 8		; increment for segment_2
		DC.B 50		; length for segment_3
		DC.W -8		; increment for segment_3
		DC.B 50		; length for segment_4
		DC.W -33	; increment for segment_4
		DC.B 50		; length for segment_5
		DC.W -8		; increment for segment_5
		DC.B 50		; length for segment_6
		DC.W 8		; increment for segment_6
		DC.W 33		; length for segment_7
		DC.B 25		; increment for segment_7
		
SINE_15:
		DC.B 15 	; number of segments for SINE
		DC.W 2048 	; initial DAC input value
		DC.B 10		; length for segment_1
		DC.W 41 	; increment for segment_1
		DC.B 21 	; length for segment_2
		DC.W 37 	; increment for segment_2
		DC.B 21 	; length for segment_3
		DC.W 25 	; increment for segment_3
		DC.B 21 	; length for segment_4
		DC.W 9 		; increment for segment_4
		DC.B 21 	; length for segment_5
		DC.W -9 	; increment for segment_5
		DC.B 21 	; length for segment_6
		DC.W -25 	; increment for segment_6
		DC.B 21 	; length for segment_7
		DC.W -37 	; increment for segment_7
		DC.B 20 	; length for segment_8
		DC.W -41 	; increment for segment_8
		DC.B 21 	; length for segment_9
		DC.W -37 	; increment for segment_9
		DC.B 21 	; length for segment_10
		DC.W -25 	; increment for segment_10
		DC.B 21 	; length for segment_11
		DC.W -9 	; increment for segment_11
		DC.B 21 	; length for segment_12
		DC.W 9 		; increment for segment_12
		DC.B 21 	; length for segment_13
		DC.W 25 	; increment for segment_13
		DC.B 21 	; length for segment_14
		DC.W 37 	; increment for segment_14
		DC.B 10 	; length for segment_15
		DC.W 41 	; increment for segment_15