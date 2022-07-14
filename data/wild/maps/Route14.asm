Route14WildMons:
	def_grass_wildmons 15 ; encounter rate
IF DEF(_RED)
	db 24, ODDISH
	db 26, PIDGEY
	db 23, ODDISH
	db 24, VENONAT
	db 22, SCYTHER
	db 26, VENONAT
	db 26, ODDISH
	db 30, PINSIR
ENDC
IF DEF(_BLUE)
	db 24, BELLSPROUT
	db 26, PIDGEY
	db 23, BELLSPROUT
	db 24, VENONAT
	db 22, PINSIR
	db 26, VENONAT
	db 26, BELLSPROUT
	db 30, SCYTHER
ENDC
	db 28, CHANSEY
	db 30, LICKITUNG
	end_grass_wildmons

	def_water_wildmons 0 ; encounter rate
	end_water_wildmons
