DungeonMonsB1:
	def_grass_wildmons 25 ; encounter rate
	db 55, RHYDON
	db 55, MAROWAK
	db 55, ELECTRODE
	db 64, CHANSEY
	db 64, PARASECT
	db 64, RAICHU
IF DEF(_RED)
	db 57, ARBOK
ENDC
IF DEF(_BLUE)
	db 57, SANDSLASH
ENDC
	db 54, DITTO
	db 54, DITTO
	db 57, DITTO
	end_grass_wildmons

	def_water_wildmons 5 ; encounter rate
	db 51, KABUTO
	db 51, OMANYTE
	db 51, KABUTO
	db 52, OMANYTE
	db 52, KABUTO
	db 52, OMANYTE
	db 56, OMANYTE
	db 54, AERODACTYL
	db 55, AERODACTYL
	db 60, AERODACTYL
	end_water_wildmons
