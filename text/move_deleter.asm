_MoveDeleterGreetingText::
	text "Umm..."

	para "Oh, yes, I'm the"
	line "Move Deleter."

	para "I can make"
	line "#mon forget"
	cont "moves."

	para "Shall I make a"
	line "#mon forget?"
	done

_MoveDeleterSaidYesText::
	text "Which #mon"
	line "should forget a"
	cont "move?"
	prompt

_MoveDeleterWhichMoveText::
	text "Which move should"
	line "it forget, then?"
	done

_MoveDeleterConfirmText::
	text "Make it forget"
	line "@"
	text_ram wStringBuffer
	text "?"
	prompt

_MoveDeleterForgotText::
	text "@"
	text_ram wStringBuffer
	text " was"
	line "forgotten!"
	prompt

_MoveDeleterByeText::
	text "Come visit me"
	line "again!"
	done

_MoveDeleterOneMoveText::
	text "That #mon"
	line "knows only one"
	cont "move."
	done
