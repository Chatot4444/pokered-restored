Route23Mons:
	def_grass_wildmons 10 ; encounter rate
IF DEF(_RED)
	db 26, EKANS
ENDC
IF DEF(_BLUE)
	db 26, SANDSHREW
ENDC
	db 33, DITTO
	db 26, SPEAROW
	db 38, FEAROW
	db 38, DITTO
	db 38, FEAROW
IF DEF(_RED)
	db 41, ARBOK
ENDC
IF DEF(_BLUE)
	db 41, SANDSLASH
ENDC
	db 41, HITMONCHAN
	db 41, HITMONLEE
	db 41, HITMONTOP
	end_grass_wildmons

	def_water_wildmons 0 ; encounter rate
	end_water_wildmons
