pcm: MACRO
; All of the pcm data has one trailing byte that is never processed.
	dw .End - .Start - 1
.Start
\1
.End
ENDM


SECTION "Pikachu Cries 1", ROMX

PikachuCry1::
	pcm INCBIN "audio/pikachu_cries/media_cries_old_439.pcm"
;	pcm INCBIN "audio/pikachu_cries/pikachu_cry_1.pcm"

PikachuCry2::
	pcm INCBIN "audio/pikachu_cries/media_cries_old_440.pcm"

PikachuCry3::
	pcm INCBIN "audio/pikachu_cries/media_cries_old_446.pcm"

PikachuCry4::
	pcm INCBIN "audio/pikachu_cries/media_cries_old_462.pcm"


SECTION "Pikachu Cries 2", ROMX

PikachuCry5::
	pcm INCBIN "audio/pikachu_cries/media_cries_old_463.pcm"

PikachuCry6::
	pcm INCBIN "audio/pikachu_cries/media_cries_old_464.pcm"

PikachuCry7::
	pcm INCBIN "audio/pikachu_cries/media_cries_old_465.pcm"


SECTION "Pikachu Cries 3", ROMX

PikachuCry8::
	pcm INCBIN "audio/pikachu_cries/media_cries_old_466.pcm"

PikachuCry9::
	pcm INCBIN "audio/pikachu_cries/media_cries_old_467.pcm"

PikachuCry10::
	pcm INCBIN "audio/pikachu_cries/media_cries_old_470.pcm"


SECTION "Pikachu Cries 4", ROMX

PikachuCry11::
	pcm INCBIN "audio/pikachu_cries/media_cries_old_471.pcm"

PikachuCry12::
	pcm INCBIN "audio/pikachu_cries/media_cries_old_474.pcm"

PikachuCry13::
	pcm INCBIN "audio/pikachu_cries/media_cries_700.pcm"


SECTION "Pikachu Cries 5", ROMX

PikachuCry14::
	pcm INCBIN "audio/pikachu_cries/863Perrserker.pcm"
	
PikachuCry15::
	pcm INCBIN "audio/pikachu_cries/865Sirfetchd.pcm"
	
PikachuCry16::
	pcm INCBIN "audio/pikachu_cries/866Mr_Rime.pcm"
	