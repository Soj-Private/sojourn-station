//** Shield Helpers
//These are shared by various items that have shield-like behaviour

//bad_arc is the ABSOLUTE arc of directions from which we cannot block. If you want to fix it to e.g. the user's facing you will need to rotate the dirs yourself.
/proc/check_shield_arc(mob/user, var/bad_arc, atom/damage_source = null, mob/attacker = null)
	//check attack direction
	var/attack_dir = 0 //direction from the user to the source of the attack
	if(istype(damage_source, /obj/item/projectile))
		var/obj/item/projectile/P = damage_source
		attack_dir = get_dir(get_turf(user), P.starting)
	else if(attacker)
		attack_dir = get_dir(get_turf(user), get_turf(attacker))
	else if(damage_source)
		attack_dir = get_dir(get_turf(user), get_turf(damage_source))

	if(!(attack_dir && (attack_dir & bad_arc)))
		return 1
	return 0

/proc/default_parry_check(mob/user, mob/attacker, atom/damage_source)
	//parry only melee attacks
	if(istype(damage_source, /obj/item/projectile) || (attacker && get_dist(user, attacker) > 1) || user.incapacitated())
		return 0

	//block as long as they are not directly behind us
	var/bad_arc = reverse_direction(user.dir) //arc of directions from which we cannot block
	if(!check_shield_arc(user, bad_arc, damage_source, attacker))
		return 0

	return 1

/obj/item/shield
	name = "shield"
	var/base_block_chance = 50
	var/max_durability = 500
	var/durability = 500

/obj/item/shield/proc/breakShield(mob/user)
	if(user)
		to_chat(user, SPAN_DANGER("Your [src] broke!"))
		new /obj/item/material/shard/shrapnel(user.loc)
	else
		new /obj/item/material/shard/shrapnel(get_turf(src))
	playsound(get_turf(src), 'sound/effects/impacts/thud1.ogg', 50, 1 -3)
	spawn(10) qdel(src)
	return

/obj/item/shield/proc/adjustShieldDurability(amount, user)
	durability = CLAMP(durability + amount, 0, max_durability)
	if(durability == 0)
		breakShield(user)

/obj/item/shield/attackby(obj/item/I, mob/user)
	if(I.has_quality(QUALITY_ADHESIVE))
		if(src.durability)
			user.visible_message(SPAN_NOTICE("[user] begins repairing \the [src] with the [I]!"))
			if(I.use_tool(user, src, WORKTIME_NORMAL, QUALITY_ADHESIVE, FAILCHANCE_EASY, required_stat = STAT_MEC))
				src.adjustShieldDurability(src.max_durability * 0.8 + (user.stats.getStat(STAT_MEC)/2)/100, user)

/obj/item/shield/examine(mob/user)
	if(!..(user,2))
		return

	if (durability)
		if (durability > max_durability * 0.95)
			return
		else if (durability > max_durability * 0.80)
			to_chat(user, "It has a few light scratches.")
		else if (durability > max_durability * 0.40)
			to_chat(user, SPAN_NOTICE("It shows minor signs of stress and wear."))
		else if (durability > max_durability * 0.20)
			to_chat(user, SPAN_WARNING("It looks a bit cracked and worn."))
		else if (durability > max_durability * 0.10)
			to_chat(user, SPAN_WARNING("Whatever use this tool once had is fading fast."))
		else if (durability > max_durability * 0.05)
			to_chat(user, SPAN_WARNING("Attempting to use this thing as a tool is probably not going to work out well."))
		else
			to_chat(user, SPAN_DANGER("It's falling apart. This is one slip away from just being a pile of assorted trash."))

/obj/item/shield/handle_shield(mob/user, var/damage, atom/damage_source = null, mob/attacker = null, var/def_zone = null, var/attack_text = "the attack")
	if(user.incapacitated())
		return 0
	//block as long as they are not directly behind us
	var/bad_arc = reverse_direction(user.dir)
	if(istype(attacker, /mob/living/simple_animal/hostile) || istype(attacker, /mob/living/carbon/superior_animal/))
		var/mob/living/carbon/human/defender = user
		if(check_shield_arc(defender, bad_arc, damage_source, attacker))
			if(defender.halloss >= 50)
				defender.visible_message(SPAN_DANGER("\The [defender] is too tired to block!"))
				return 0
			else
				var/damage_received = CLAMP(damage * (CLAMP(100-user.stats.getStat(STAT_TGH)/2,0,100) / 100) - user.stats.getStat(STAT_TGH)/5,1,100)
				src.durability = src.durability -  CLAMP(damage_received,10,100) // Shields still take some damage, can't have it go unscathed
				defender.adjustHalLoss(damage_received)
				defender.visible_message(SPAN_DANGER("\The [defender] blocks [attack_text] with \the [src]!"))
				return 1
	if(check_shield_arc(user, bad_arc, damage_source, attacker))
		if(prob(get_block_chance(user, damage, damage_source, attacker)))
			user.visible_message(SPAN_DANGER("\The [user] blocks [attack_text] with \the [src]!"))
			return 1
	return 0

/obj/item/shield/proc/get_block_chance(mob/user, var/damage, atom/damage_source = null, mob/attacker = null)
	return base_block_chance

//TODOKAZ: add ballistic shield

/obj/item/shield/riot
	name = "riot shield"
	desc = "A shield adept at blocking blunt objects from connecting with the torso of the shield wielder."
	icon = 'icons/obj/weapons.dmi'
	icon_state = "riot"
	item_state = "riot"
	flags = CONDUCT
	slot_flags = SLOT_BACK
	force = WEAPON_FORCE_PAINFUL
	throwforce = WEAPON_FORCE_PAINFUL
	throw_speed = 1
	throw_range = 4
	w_class = ITEM_SIZE_BULKY
	origin_tech = list(TECH_MATERIAL = 2)
	matter = list(MATERIAL_GLASS = 3, MATERIAL_STEEL = 10)
	price_tag = 500
	attack_verb = list("shoved", "bashed")
	var/cooldown = 0 //shield bash cooldown. based on world.time

/obj/item/shield/riot/handle_shield(mob/user)
	. = ..()
	if(.) playsound(user.loc, 'sound/weapons/Genhit.ogg', 50, 1)

/obj/item/shield/riot/get_block_chance(mob/user, var/damage, atom/damage_source = null, mob/attacker = null)
	if(istype(damage_source, /obj/item/projectile))
		var/obj/item/projectile/P = damage_source
		//thin metal shields do not stop bullets or most lasers, even in space. Will block beanbags, rubber bullets, and stunshots at normal rates tho.
		//Lasers it can block - AP weak laser beams, laser tag, taser bolts, emitter and practic
		if((is_sharp(P) && damage > 15))
			return 0
	return base_block_chance

/obj/item/shield/riot/attackby(obj/item/W as obj, mob/user as mob)
	if(istype(W, /obj/item/melee/baton))
		on_bash(W, user)
	else
		..()

/obj/item/shield/riot/proc/on_bash(var/obj/item/W, var/mob/user)
	if(cooldown < world.time - 25)
		user.visible_message(SPAN_WARNING("[user] bashes [src] with [W]!"))
		playsound(user.loc, 'sound/effects/shieldbash.ogg', 50, 1)
		cooldown = world.time

/obj/item/shield/riot/crusader
	name = "crusader tower shield"
	desc = "A traditional tower shield meeting the materials and design of the future. It's made from durasteel and the craftsmanship is the highest quality, setting it apart from regular shields. It bears the insignia of the Church. Deus Vult."
	icon = 'icons/obj/nt_melee.dmi'
	icon_state = "nt_shield"
	item_state = "nt_shield"
	price_tag = 2000
	max_durability = 1200
	durability = 1200
	matter = list(MATERIAL_GLASS = 3, MATERIAL_STEEL = 10, MATERIAL_DURASTEEL = 20)

/obj/item/shield/riot/crusader/handle_shield(mob/user)
	. = ..()
	if(.) playsound(user.loc, 'sound/weapons/Genhit.ogg', 50, 1)

/obj/item/shield/riot/crusader/get_block_chance(mob/user, var/damage, atom/damage_source = null, mob/attacker = null)
	if(istype(damage_source, /obj/item/projectile))
		var/obj/item/projectile/P = damage_source
		if((is_sharp(P) && damage > 15) || istype(P, /obj/item/projectile/beam))
			return (base_block_chance - round(damage / 3)) //block bullets and beams using the old block chance
	return base_block_chance

/*
 * Handmade shield
 */

/obj/item/shield/riot/handmade
	name = "round handmade shield"
	desc = "A handmade stout shield, but with a small size."
	icon_state = "buckler"
	item_state = "buckler"
	flags = null
	throw_speed = 2
	throw_range = 6
	max_durability = 350
	durability = 350
	matter = list(MATERIAL_STEEL = 6)
	base_block_chance = 35


/obj/item/shield/riot/handmade/get_block_chance(mob/user, var/damage, atom/damage_source = null, mob/attacker = null)
	return base_block_chance


/obj/item/shield/riot/handmade/attackby(obj/item/W as obj, mob/user as mob)
	if(istype(W, /obj/item/extinguisher) || istype(W, /obj/item/storage/toolbox) || istype(W, /obj/item/melee))
		on_bash(W, user)
	else
		..()

/obj/item/shield/riot/handmade/tray
	name = "tray shield"
	desc = "This one is thin, but compensate it with a good size."
	icon_state = "tray_shield"
	item_state = "tray_shield"
	flags = CONDUCT
	throw_speed = 2
	throw_range = 4
	max_durability = 300
	durability = 300
	matter = list(MATERIAL_STEEL = 4)
	base_block_chance = 30


/obj/item/shield/riot/handmade/tray/get_block_chance(mob/user, var/damage, atom/damage_source = null, mob/attacker = null)
	if(istype(damage_source, /obj/item))
		var/obj/item/I = damage_source
		if((is_sharp(I) && damage > 15) || istype(damage_source, /obj/item/projectile/beam))
			return 20
	return base_block_chance


/obj/item/shield/riot/handmade/lid
	name = "lid shield"
	desc = "A detached lid from a trash cart, that works well as shield."
	icon_state = "lid_shield"
	flags = CONDUCT
	throw_speed = 2
	throw_range = 2
	max_durability = 300
	durability = 300
	matter = list(MATERIAL_STEEL = 8)
	base_block_chance = 40

/obj/item/shield/riot/handmade/bone
	name = "bone shield"
	desc = "A handmade stout shield, but with a small size crafted entirely of bone. Exceptionally good at enduring melee attacks due to its light weight and high density."
	icon_state = "buckler_bone"
	item_state = "buckler_bone"
	flags = null
	throw_speed = 2
	throw_range = 6
	matter = list(MATERIAL_BONE = 6)
	base_block_chance = 50

/*
 * Energy Shield
 */

/obj/item/shield/energy
	name = "energy combat shield"
	desc = "A shield capable of stopping most projectile and melee attacks. It can be retracted, expanded, and stored anywhere."
	icon = 'icons/obj/weapons.dmi'
	icon_state = "eshield0" // eshield1 for expanded
	flags = CONDUCT
	force = 3.0
	throwforce = 5.0
	throw_speed = 1
	throw_range = 4
	max_durability = 700
	durability = 700
	w_class = ITEM_SIZE_SMALL
	origin_tech = list(TECH_MATERIAL = 4, TECH_MAGNET = 3, TECH_ILLEGAL = 4)
	attack_verb = list("shoved", "bashed")
	var/active = 0

/obj/item/shield/energy/reaver
	name = "reaver combat shield"
	desc = "A shield capable of stopping most projectile and melee attacks. It can be retracted, expanded, and stored anywhere. This one was created for void wolves, generally employed by reavers."
	icon_state = "voidwolfshield0" // eshield1 for expanded

/obj/item/shield/energy/reaver/update_icon()
	icon_state = "voidwolfshield[active]"
	update_wear_icon()
	if(active)
		set_light(1.5, 1.5, COLOR_LIGHTING_RED_BRIGHT)
	else
		set_light(0)

/obj/item/shield/energy/handle_shield(mob/user)
	if(!active)
		return 0 //turn it on first!
	. = ..()

	if(.)
		var/datum/effect/effect/system/spark_spread/spark_system = new
		spark_system.set_up(5, 0, user.loc)
		spark_system.start()
		playsound(user.loc, 'sound/weapons/blade1.ogg', 50, 1)

/obj/item/shield/energy/get_block_chance(mob/user, var/damage, atom/damage_source = null, mob/attacker = null)
	if(istype(damage_source, /obj/item/projectile))
		var/obj/item/projectile/P = damage_source
		if((is_sharp(P) && damage > 15) || istype(P, /obj/item/projectile/beam))
			return (base_block_chance - round(damage / 3)) //block bullets and beams using the old block chance
	return base_block_chance

/obj/item/shield/energy/attack_self(mob/living/user as mob)
	if ((CLUMSY in user.mutations) && prob(50))
		to_chat(user, SPAN_WARNING("You beat yourself in the head with [src]."))
		user.take_organ_damage(5)
	active = !active
	if (active)
		force = WEAPON_FORCE_PAINFUL
		update_icon()
		w_class = ITEM_SIZE_BULKY
		playsound(user, 'sound/weapons/saberon.ogg', 50, 1)
		to_chat(user, SPAN_NOTICE("\The [src] is now active."))

	else
		force = 3
		update_icon()
		w_class = ITEM_SIZE_TINY
		playsound(user, 'sound/weapons/saberoff.ogg', 50, 1)
		to_chat(user, SPAN_NOTICE("\The [src] can now be concealed."))

	add_fingerprint(user)
	return

/obj/item/shield/energy/update_icon()
	icon_state = "eshield[active]"
	update_wear_icon()
	if(active)
		set_light(1.5, 1.5, COLOR_LIGHTING_BLUE_BRIGHT)
	else
		set_light(0)

/obj/item/shield/energy/reaver/update_icon()
	icon_state = "voidwolfshield[active]"
	update_wear_icon()
	if(active)
		set_light(1.5, 1.5, COLOR_LIGHTING_RED_BRIGHT)
	else
		set_light(0)