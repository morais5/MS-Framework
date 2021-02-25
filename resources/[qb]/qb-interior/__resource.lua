resource_manifest_version '44febabe-d386-4d18-afbe-5e627f4af937'

client_scripts {
	'client/main.lua',
	'client/shells.lua',
	'client/furnished.lua',
}
 
files {
	'playerhouse_hotel/playerhouse_hotel.ytyp',
	'stream/playerhouse_hotel/playerhouse_hotel.ytyp',
	'stream/playerhouse_hotel/playerhouse_hote2.ytyp',
	'stream/playerhouse_tier3/playerhouse_tier3.ytyp',
	'stream/playerhouse_appartment_motel/playerhouse_appartment_motel.ytyp',
	'stream/micheal_shell/micheal_shell.ytyp',
	'stream/trevors_shell/trevors_shell.ytyp',
	'stream/gunshop_shell/gunshop_shell.ytyp',
	'stream/traphouse_shell/traphouse_shell.ytyp',
	'stream/appartment/appartment.ytyp',
	'stream/caravan_shell/caravan.ytyp',
	'stream/frankelientje/frankelientje.ytyp',
	'stream/tante_shell/tante.ytyp',
	'stream/methlab_shell/methlab_shell.ytyp',
}

data_file 'DLC_ITYP_REQUEST' 'stream/v_int_20.ytyp'
data_file 'DLC_ITYP_REQUEST' 'stream/playerhouse_hotel/playerhouse_hotel.ytyp'
data_file 'DLC_ITYP_REQUEST' 'stream/playerhouse_tier1/playerhouse_tier1.ytyp'
data_file 'DLC_ITYP_REQUEST' 'stream/playerhouse_tier1/playerhouse_tier2.ytyp'
data_file 'DLC_ITYP_REQUEST' 'stream/playerhouse_tier3/playerhouse_tier3.ytyp'
data_file 'DLC_ITYP_REQUEST' 'stream/playerhouse_appartment_motel/playerhouse_appartment_motel.ytyp'
data_file 'DLC_ITYP_REQUEST' 'stream/micheal_shell/micheal_shell.ytyp'
data_file 'DLC_ITYP_REQUEST' 'stream/trevors_shell/trevors_shell.ytyp'
data_file 'DLC_ITYP_REQUEST' 'stream/gunshop_shell/gunshop_shell.ytyp'
data_file 'DLC_ITYP_REQUEST' 'stream/traphouse_shell/traphouse_shell.ytyp'
data_file 'DLC_ITYP_REQUEST' 'stream/appartment/appartment.ytyp'
data_file 'DLC_ITYP_REQUEST' 'stream/caravan_shell/caravan.ytyp'
data_file 'DLC_ITYP_REQUEST' 'stream/frankelientje/frankelientje.ytyp'
data_file 'DLC_ITYP_REQUEST' 'stream/tante_shell/tante.ytyp'
data_file 'DLC_ITYP_REQUEST' 'stream/methlab_shell/methlab_shell.ytyp'

exports {
	'DespawnInterior',
	'CreateHotel',
	'CreateTier1House',
	'CreateTier2House',
	'CreateTier3House',
	'CreateMichaelShell',
	'CreateTrevorsShell',
	'CreateLesterShell',
	'CreateGunshopShell',
	'CreateTrapHouseShell',
	'CreateMethlabShell',
	
	'CreateApartmentShell',
	'CreateCaravanShell',
	'CreateFranklinShell',
	'CreateFranklinAuntShell',

	'CreateTier1HouseFurnished',
	'CreateHotelFurnished',
	'CreateApartmentFurnished',
}