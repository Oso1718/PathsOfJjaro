extends Node


# final M1 weapon order should be: fist, magnum, fusion, AR, alien gun, flamethrower, rocket launcher; this ensures that when alien gun/flamethrower runs empty, the Player switches to less powerful, more general-purpose weapon (typically AR) and avoids Classic's annoying flaw of auto-switching from alien gun to SPNKR (very dangerous!)


# note: these currently use timings appropriate for the greybox weapon animations; setting final timings to replicate M2 can be done later


const WEAPON_DEFINITIONS := [ # TO DO: add remaining definitions in order of previous/next weapon switching (Arrival Demo requires FIST, MAGNUM_PISTOL, and ASSAULT_RIFLE; the rest can be added later)
	{
		# TO DO: add a separate Enums.WeaponType? for now, just use PickableType to identify weapons by enum
		"pickable": Enums.PickableType.FIST,
		#"weapon_class": "melee", # how does this influence weapon behaviors? (e.g. I think melee affects run-punch damage; what else?)
		
		"activating_time":   0.25,
		"deactivating_time": 0.25,
		
		"flags": {
			
			#"is_dual_wield": true, # not needed as InventoryItem.max_count indicates single-wield or dual-wield
			
			"is_automatic": false, # TO DO: check AO code for behavior; all Classic weapons are automatic, except possibly SPNKR, as holding a trigger repeats firing (a true semi-automatic requires a fresh trigger pull for each shot - holding the trigger would only shoot once)
			
			"fires_out_of_phase": false, # allows one pistol to fire before other finishes its firing animation # TO DO: this should be timing
			"reloads_in_one_hand": false, # was reloads_in_one_hand`; allows one shotgun to reload before the other finishes its firing animation (TO DO: if both shotguns require reloading, should they reload one at a time before either starts firing? or can the first reload and then start firing as the second reloads?)
			"triggers_share_magazine": false, # was `triggers_share_ammo`; this is always false for dual-wield; for single-wield it is true for fusion and alien gun, false for AR
			
			"fires_under_media": true,
			"fires_in_vacuum": true, # added
			
			"has_random_ammo_on_pickup": false,
			"disappears_after_use": false,
		},
		
		"primary_trigger": {
			"pickable": Enums.PickableType.FIST,
			"max_count": 1, # number of bullets the trigger's magazine can hold
			"count": 1, # number of bullets currently in its magazine; while it seems odd to put this on the trigger, not on the ammo pickable, this is how Classic did it; these values will be assigned to the newly instanced Magazine
			
			# note: this may be made more granular in future ("normal_projectile":{...}, "special_projectile":{...}) but for now KISS
			"projectile_type": Enums.ProjectileType.MINOR_FIST,
			"special_projectile_type": Enums.ProjectileType.MAJOR_FIST, # TO DO: how best to hook special behavior into WeaponTrigger? best to keep special condition detection separate (plugin class, callback function, or WeaponTrigger subclass); for fists, this detects if Player is running (user is pressing forward key, player is on ground with >=Z velocity)
			"ammo_consumption": 0,
			"projectile_count": 1,
			"theta_error": 0.0,
			"origin_delta": [0.0, -0.09765625, 0.3],
			
			"recoil_magnitude": 0.0,
			
			"shooting_time": 0.33,
			"reloading_time": 0.0,
			
			"charging_time":    0.0,
			"overloading_time": 0.0,
			"overload_damage_type": Enums.DamageType.NONE,
			
			"angular_spread": null, # was secondary_has_angular_flipping:bool; now Array[Vector3], which is directions for sequential shots, or null
		},
		"secondary_trigger": {
			"pickable": Enums.PickableType.FIST,
			"max_count": 1,
			"count": 1,
			
			"projectile_type": Enums.ProjectileType.MINOR_FIST,
			"special_projectile_type": Enums.ProjectileType.MAJOR_FIST,
			"ammo_consumption": 0,
			"projectile_count": 1,
			"theta_error": 0.0,
			"origin_delta": [0.0, -0.09765625, 0.3],
			
			"recoil_magnitude": 0.0,
			
			"shooting_time": 0.33,
			"reloading_time": 0.0,
			
			"charging_time":  0.0,
			"overloading_time": 0.0,
			"overload_damage_type": Enums.DamageType.NONE,
			
			"angular_spread": null,
		}
	},
	
	
	{
		"pickable": Enums.PickableType.MAGNUM_PISTOL,
		#"weapon_class": "dual wield",
		
		"activating_time": 0.5, # 0.167,
		"deactivating_time": 0.5, # 0.167,
		
		#"ready_ticks":          0.167,
		#"await_reload_ticks":   0.083,
		#"loading_ticks":        0.083,
		#"finish_loading_ticks": 0.083,
		#"powerup_ticks": 0,
		
		
		"flags": {
			
			"is_automatic": false,
			
			"fires_out_of_phase": true,# allows one pistol to start firing before other finishes its firing animation; in effect this shortens the delay between repeat firing so it's shorter than the firing anination; we should be able to handle the overlap in WIH by defining left/right/both firing loops where the 'both' loop starts and ends on one hand about to fire while the other is 50% through its own 'fire-then-rest' cycle; we can then freely switch between 1- and 2- handed firing animations at the appropriate time indexes; alternatively, we might subclass AnimationPlayer with `@export hand_path` so we can set up a single hand's animations then duplicate that player so we have one player for each hand, and both can run singly or synchronized
			"reloads_in_one_hand": false,
			"triggers_share_magazine": false,
			
			"fires_under_media": false,
			"fires_in_vacuum": false,
			
			"has_random_ammo_on_pickup": false,
			"disappears_after_use": false,
			#"secondary_has_angular_flipping": false,
		},
		
		
		"primary_trigger": {
			"pickable": Enums.PickableType.MAGNUM_MAGAZINE,
			"max_count": 8,
			"count": 8,
			
			"projectile_type": Enums.ProjectileType.PISTOL_BULLET,
			"special_projectile_type": null,
			"ammo_consumption": 1,
			"projectile_count": 1,
			"theta_error": 0.703125,
			"origin_delta": [-0.041015625, -0.01953125, 0.3], # TO DO: update WU
			
			"recoil_magnitude": 0.009765625,
			
			"shooting_time": 0.5, # this must be >= shooting animation
			"reloading_time": 1.5, # this must be >= reloading animation
			#"recovery_time": 0.167,
			
			"charging_time": 0.0,
			"overloading_time": 0.0,
			"overload_damage_type": Enums.DamageType.NONE,
			
			"angular_spread": null,
		},
		"secondary_trigger": {
			"pickable": Enums.PickableType.MAGNUM_MAGAZINE,
			"max_count": 8,
			"count": 8,
			
			"projectile_type": Enums.ProjectileType.PISTOL_BULLET,
			"special_projectile_type": null,
			"ammo_consumption": 1,
			"projectile_count": 1,
			"theta_error": 0.703125,
			"origin_delta": [0.041015625, -0.01953125, 0.3], # TO DO: update WU
			
			"recoil_magnitude": 0.009765625,
			
			"shooting_time": 0.0,
			"recovery_time": 0.167,
			"reloading_time": 0.75,
			
			"charging_time": 0.0,
			"overloading_time": 0.0,
			"overload_damage_type": Enums.DamageType.NONE,
			
			"angular_spread": null,
		}
	},
	
	{
		"pickable": Enums.PickableType.ASSAULT_RIFLE,
		#"long_name": "MA75C Assault Rifle", # show this in Inventory overlay
		#"short_name": "MA75C", # show this in HUD
		#"max_count": 1,
		#"count": 1,
		#"powerup_type": null,
		#"weapon_class": "multipurpose", # how does this influence weapon behaviors? (e.g. I think melee affects run-punch damage; what else?)
		
		"activating_time": 0.5, # 0.25, # (Classic MacOS used 60tick/sec) # TO DO: rename 'ticks' to 'time' in all weapon definitions and convert values to seconds (divide ticks by 60)
		"deactivating_time": 0.5, # 0.25,
		
		"flags": {
			
			"is_automatic": true, # true for AR, SPNKR, flamethrower, alien gun, flechette gun; not sure what it does though as other weapons also fire repeatedly when trigger key is held down
			"triggers_share_magazine": false, # true for fusion pistol and alien gun, false for others; if true, both triggers share the same Magazine instance, else each trigger receives its own Magazine instance when Weapon is configured
			
			"fires_out_of_phase": false, # true for pistol; allows one pistol to start firing before other finishes its firing animation; probably best expressed as a `time_before_switching_trigger` float and move on both triggers which is normally 0 but can be +ve or -ve to control the interlock between end of one hand firing and start of other
			"reloads_in_one_hand": false, # true for shotgun; should this move to triggers too?
			
			"fires_under_media": false, # true for fists, fusion pistol, flechette gun (note that firing fusion underwater causes radius damage, though not sure if this is the Projectile or Weapon which does this; Q. does firing fusion into water also do radius damage to nearby bodies in the water, or does fusion blowback only occur when weapon itself is submerged?)
			"fires_in_vacuum": false, # does exactly what it says; in addition to G4 Sunbathing, we might turn some short sections of maps into vacuum to vary gameplay a bit more: vacuum forces user to abandon AR and switch to fist and fusion, and optionally change tactics to evade instead of kill where possible (note: we don't want to change gameplay too much though, so oxygen chargers should be provided so user is at little risk of suffocation outside of G4 where this is a gameplay feature)
			
			"has_random_ammo_on_pickup": false, # true for alien gun; note pickable ammo objects *always* have full ammo (); while some games randomize the number of rounds per ammo box and track the total number of bullets in inventory, allowing weapon to be manually reloaded at any time, we will stick to the Classic Marathon behavior here (in future, if other games use this engine then this can all be made configurable, but for now we only implement the features MCR requires, not features it doesn't)
			"disappears_after_use": false, # true for alien gun
			#"plays_instant_shell_casing_sound": false, # always false
			#"powerup_is_temporary": false, # always false
			"secondary_has_angular_flipping": false, # true for alien gun, TO DO: move this onto triggers and replace with options for specifying spread behavior: probably make it an array of [[x,y],...] which is the angles at which repeating shots fire when trigger is held; we'll set up single projectile as primary trigger and 3-way spread as secondary trigger (there's no benefit to Classic's trigger behaviors where secondary is useless on its own and both triggers must be held for full spread), making alien gun a dual-mode weapon same as fusion
		},
		
		# TO DO: move these settings to WeaponInHand's shooting and reloading animations
		#"idle_height": 1.1666565,
		#"bob_amplitude": 0.028564453,
		#"idle_width": 0.5,
		#"horizontal_amplitude": 0.0,
		#"kick_height": 0.0625, # presumably M2 WU
		#"reload_height": 0.75,
		
		"primary_trigger": {
			"pickable": Enums.PickableType.AR_MAGAZINE,
			"max_count": 12, # was: rounds_per_magazine # TO DO: 52
			"count": 12,
			
			"projectile_type": Enums.ProjectileType.RIFLE_BULLET,
			"special_projectile_type": null,
			
			# note: these 2 properties replace Classic's confusing weapon settings, where fusion and alien gun primary and secondary triggers' rounds_per_magazine and burst_count bore little resemblance to what actually got fired per trigger pull (I suspect the secondary trigger's increased consumption was hardcoded to the `overload` flag as only fusion actually seems to do it)
			"ammo_consumption": 1, 
			"projectile_count": 1, # 10 for shotgun, 2 for flechette
			
			"theta_error": 7.03125, # projectile's accuracy
			# offset from Player's center to Projectile's origin # TO DO: this is M2 WU(?) - update to Godot dimensions
			#"dx": 0.0,
			#"dz": -0.01953125,
			"origin_delta": [0.0, -0.01953125, 0.3], # TO DO: I’m guessing what Classic calls dz is the y-axis offset, which I'm guessing is relative to center of camera; also ensure projectile always originate *inside* the Player's capsule body, never outside it, as we don't want projectiles originating inside walls or scenery when squeezing along tight service corridors
			
			"recoil_magnitude": 0.0048828125, # applies backward impulse to Player
			#"shell_casing_type": 0, # pistol, AR primary, flechette # TO DO: this is purely cosmetic so belongs in WeaponInHand's shoot animation
			
			# timings affect Weapon/WeaponTrigger behavior so remain here; the corresponding weapon-in-hand animations should not exceed these timings to avoid visual jitters when transitioning from one animation to another
			"shooting_time": 0.18,
			"reloading_time": 1.5,
			
			"charging_time": 0.0, # time before trigger can fire, but wait until trigger key is released to dispatch
			"overloading_time": 0.0, # if charging_time>0, the delay before the weapon explodes (0=never explode)
			"overload_damage_type": Enums.DamageType.NONE, # if overloading_time>0, the type and size of explosion
			
			"angular_spread": null,
			
			#"powerup_time": 0, # is always 0 so presumably we don't need it
			
			# TO DO: for now, let's leave firing illumination to weapon assets; it is, arguably, a gameplay feature: in effect, Player momentarily acts as an omni-/semi-directional light source illuminating both weapon-in-hand model and the local environment (lights up the room); while the WiH glow is a visual effect the environment illumination is a gameplay feature (i.e. user may fire a gun to see in a pitch-black environment) so there is an argument for keeping it here and signalling to Player to emit light flash/emit light directly; OTOH, leaving WeaponInHand to manage the shoot light source (which it currently does) simplifies engine code and it ensures the light emits at the front of the barrel (the light might also be semi-directional, with most of the light being thrown forward; remember too that grenade, rocket, M2-style alien gun, and flamethrower projectiles are also light sources)
			
			#"firing_light_intensity": 0.75,
			#"firing_intensity_decay_time": 6,
			# TO DO: also allow Color to be specified, e.g. yellowish-white for magnum and AR primary; bluish-white for fusion; saturated orange for flamethrower and alien gun
		},
		
		"secondary_trigger": { # must be null for single-wield single-mode weapons (TOZT, SPNKR, SMG)
			
			"pickable": Enums.PickableType.AR_GRENADE_MAGAZINE,
			"max_count": 3, # TO DO: 7
			"count": 3,
			
			"projectile_type": Enums.ProjectileType.GRENADE,
			"special_projectile_type": null,
			
			"ammo_consumption": 1,
			"projectile_count": 1,
			
			"theta_error": 0.0,
			#"dx": 0.0,
			#"dz": -0.09765625,
			"origin_delta": [0.0, -0.09765625, 0.3],
			"recoil_magnitude": 0.0390625,
			
			"shooting_time": 0.8,
			"reloading_time": 1.5,
			
			"charging_time": 0.0,
			"overloading_time": 0.0,
			"overload_damage_type": Enums.DamageType.NONE,
			
			"angular_spread": null, # for alien gun secondary trigger's 3-way spread will be something like [Vector2(0,0), Vector2(-0.3,0), Vector(0.3,0)]; so pressing and holding the trigger fires first projectile straight, second to its left, third to its right, repeating the cycle until trigger is released
			
			#"powerup_ticks": 0, # is always 0 so presumably we don't need it
			
			# TO DO: as above
			#"firing_light_intensity": 0.75,
			#"firing_intensity_decay_ticks": 6,
		}
	},
]

