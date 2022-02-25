_TM29PreReceiveText::
	text "...Wait! Don't"
	line "say a word!"

	para "You wanted this!"
	prompt

_ReceivedTM29Text::
	text "<PLAYER> received"
	line "@"
	text_ram wcf4b
	text "!@"
	text_end

_TM29ExplanationText::
	text "TM29 is PSYCHIC!"

	para "It can lower the"
	line "target's SPECIAL"
	cont "abilities."
	
	para"Your first reading"
	line "is free,"
	cont "if you want more"
	cont "it'll cost you."
	done
	
_TM29NoRoomText::
	text "Where do you plan"
	line "to put this?"
	done

	
_MrPsychicText1::
	text "I predicted you'd"
	line "be back for more."

	para "Would you like"
	line "another TM29"
	cont "for just ¥4000?"
	done

_MrPsychicNoText::
	text "You'll be back,"
	line "the psychic power"
	cont "calls to you!"
	done

_MrPsychicNoMoneyText::
	text "You don't have"
	line "enough money."
	done
