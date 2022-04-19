Route15Mons:
	def_grass_wildmons 15 ; encounter rate
IF DEF(_RED)
	db 24, ODDISH
	db 26, EXEGGCUTE
	db 23, PIDGEY
	db 26, VENONAT
	db 22, SCYTHER
	db 28, VENONAT
	db 26, ODDISH
	db 30, PINSIR
ENDC
IF DEF(_BLUE)
	db 24, BELLSPROUT
	db 26, EXEGGCUTE
	db 23, PIDGEY
	db 26, VENONAT
	db 22, PINSIR
	db 28, VENONAT
	db 26, BELLSPROUT
	db 30, SCYTHER
ENDC
	db 28, LICKITUNG
	db 30, CHANSEY
	end_grass_wildmons

	def_water_wildmons 0 ; encounter rate
	end_water_wildmons
