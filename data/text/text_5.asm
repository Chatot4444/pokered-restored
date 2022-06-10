_CableClubNPCPleaseComeAgainText::
	text "Please come again!"
	done

_CableClubNPCMakingPreparationsText::
	text "We're making"
	line "preparations."
	cont "Please wait."
	done

_UsedStrengthText::
	text_ram wcd6d
	text " used"
	line "STRENGTH.@"
	text_end

_CanMoveBouldersText::
	text_ram wcd6d
	text " can"
	line "move boulders."
	prompt

_CurrentTooFastText::
	text "The current is"
	line "much too fast!"
	prompt

_CyclingIsFunText::
	text "Cycling is fun!"
	line "Forget SURFing!"
	prompt

_FlashLightsAreaText::
	text "A blinding FLASH"
	line "lights the area!"
	prompt

_WarpToLastPokemonCenterText::
	text "Warp to the last"
	line "#MON CENTER?"
	done

_DigToEntranceText::
	text "DIG to go back"
	line "to entrance?"
	done
	
_CannotUseTeleportNowText::
	text_ram wcd6d
	text " can't"
	line "use TELEPORT now."
	prompt

_CannotFlyHereText::
	text_ram wcd6d
	text " can't"
	line "FLY here."
	prompt

_NotHealthyEnoughText::
	text "Not healthy"
	line "enough."
	prompt

_NewBadgeRequiredText::
	text "No! A new BADGE"
	line "is required."
	prompt

_NewHMRequiredText::
	text "No! @"
	text_ram wcd6d
	text " is"
	line "required."
	prompt

_CannotUseItemsHereText::
	text "You can't use items"
	line "here."
	prompt

_CannotGetOffHereText::
	text "You can't get off"
	line "here."
	prompt

_RegisteredItemText::
	text "Registered the"
	line "@"
	text_ram wcf4b
	text " to"
	cont "SELECT Button."
	prompt

_GotMonText::
	text "<PLAYER> got"
	line "@"
	text_ram wcd6d
	text "!@"
	text_end

_SentToBoxText::
	text "There's no more"
	line "room for #MON!"
	cont "@"
	text_ram wBoxMonNicks
	text " was"
	cont "sent to #MON"
	cont "BOX @"
	text_ram wcf4b
	text " on PC!"
	done

_BoxIsFullText::
	text "There's no more"
	line "room for #MON!"

	para "The #MON BOX"
	line "is full and can't"
	cont "accept any more!"

	para "Change the BOX at"
	line "a #MON CENTER!"
	done

_BoxFilledText::
	text "The #MON BOX"
	line "is now full!"
	
	para "You will be"
	line "unable to catch"
	cont "any more #MON!"
	
	para "Change the BOX at"
	line "a #MON CENTER!"
	prompt
	