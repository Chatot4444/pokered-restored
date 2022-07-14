CeruleanCave1FWildMons:
	def_grass_wildmons 10 ; encounter rate
	db 46, GOLBAT
	db 46, HYPNO
	db 46, MAGNETON
	db 49, DODRIO
	db 49, VENOMOTH
IF DEF(_RED)
	db 52, ARBOK
ENDC
IF DEF(_BLUE)
	db 52, SANDSLASH
ENDC
	db 49, KADABRA
	db 52, PARASECT
	db 53, RAICHU
	db 53, DITTO
	end_grass_wildmons

	def_water_wildmons 5 ; encounter rate
	db 46, KABUTO
	db 46, OMANYTE
	db 46, KABUTO
	db 46, OMANYTE
	db 49, KABUTO
	db 49, OMANYTE
	db 46, OMANYTE
	db 52, AERODACTYL
	db 53, AERODACTYL
	db 53, AERODACTYL
	end_water_wildmons
