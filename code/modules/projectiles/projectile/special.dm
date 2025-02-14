/obj/item/projectile/ion
	name = "ion bolt"
	icon_state = "ion"
	damage_types = list(BURN = 0)
	nodamage = TRUE
	check_armour = ARMOR_ENERGY

/obj/item/projectile/ion/on_impact(atom/target)
	empulse(target, 1, 1)
	return TRUE

/obj/item/projectile/bullet/gyro
	name = "explosive bolt"
	icon_state = "bolter"
	damage_types = list(BRUTE = 50)
	check_armour = ARMOR_BULLET
	sharp = TRUE
	edge = TRUE

/obj/item/projectile/bullet/gyro/on_impact(atom/target)
	explosion(target, 0, 1, 2)
	return TRUE

/obj/item/projectile/bullet/rocket
	name = "high explosive rocket"
	icon_state = "rocket"
	damage_types = list(BRUTE = 70)
	armor_penetration = 100
	check_armour = ARMOR_BULLET

/obj/item/projectile/bullet/rocket/launch(atom/target, target_zone, x_offset, y_offset, angle_offset)
	set_light(2.5, 0.5, "#dddd00")
	..(target, target_zone, x_offset, y_offset, angle_offset)

/obj/item/projectile/bullet/rocket/on_impact(atom/target)
	explosion(loc, 0, 1, 2, 4)
	set_light(0)
	return TRUE

/obj/item/projectile/temp
	name = "freeze beam"
	icon_state = "ice_2"
	damage_types = list(BURN = 0)
	nodamage = 1
	check_armour = ARMOR_ENERGY
	var/temperature = 300

/obj/item/projectile/temp/on_impact(atom/target)//These two could likely check temp protection on the mob
	if(isliving(target))
		var/mob/M = target
		M.bodytemperature = temperature
	return TRUE

/obj/item/projectile/temp/cold
	temperature = 200

/obj/item/projectile/temp/ice
	temperature = 10 //balance wise this will be 10 rather then 0

/obj/item/projectile/temp/hot
	temperature = 400

/obj/item/projectile/temp/boil
	temperature = 500


/obj/item/projectile/slime_death
	name = "core stopper beam"
	icon_state = "ice_2"
	damage_types = list(BURN = 0)
	nodamage = TRUE
	check_armour = ARMOR_ENERGY
	pass_flags = PASSTABLE | PASSGLASS | PASSGRILLE
	hitscan = TRUE

/obj/item/projectile/slime_death/on_impact(atom/target)//These two could likely check temp protection on the mob
	if(isliving(target))
		if(isslime(target))
			var/mob/living/carbon/slime/cute = target
			nodamage = FALSE
			cute.death() // The cute slime dies.

/obj/item/projectile/meteor
	name = "meteor"
	icon = 'icons/obj/meteor.dmi'
	icon_state = "smallf"
	damage_types = list(BRUTE = 0)
	nodamage = TRUE
	check_armour = ARMOR_BULLET

/obj/item/projectile/meteor/Bump(atom/A as mob|obj|turf|area, forced)
	if(A == firer)
		loc = A.loc
		return

	sleep(-1) //Might not be important enough for a sleep(-1) but the sleep/spawn itself is necessary thanks to explosions and metoerhits

	if(src)//Do not add to this if() statement, otherwise the meteor won't delete them
		if(A)

			A.ex_act(2)
			playsound(src.loc, 'sound/effects/meteorimpact.ogg', 40, 1)

			for(var/mob/M in range(10, src))
				if(!M.stat && !isAI(M))
					shake_camera(M, 3, 1)
			qdel(src)
			return 1
	else
		return 0

/obj/item/projectile/energy/floramut
	name = "alpha somatoray"
	icon_state = "energy"
	damage_types = list(TOX = 0)
	nodamage = TRUE
	check_armour = ARMOR_ENERGY

/obj/item/projectile/energy/floramut/on_impact(atom/target)
	var/mob/living/M = target
	if(ishuman(target))
		var/mob/living/carbon/human/H = M
		if((H.species.flags & IS_PLANT) && (H.nutrition < 500))
			if(prob(15))
				H.apply_effect((rand(30,80)),IRRADIATE)
				H.Weaken(5)
				for (var/mob/V in viewers(src))
					V.show_message("\red [M] writhes in pain as \his vacuoles boil.", 3, "\red You hear the crunching of leaves.", 2)
			if(prob(35))
				if(prob(80))
					randmutb(M)
					domutcheck(M,null)
				else
					randmutg(M)
					domutcheck(M,null)
			else
				M.adjustFireLoss(rand(5,15))
				M.show_message("\red The radiation beam singes you!")
	else if(istype(target, /mob/living/carbon/))
		M.show_message("\blue The radiation beam dissipates harmlessly through your body.")
	else
		return 1

/obj/item/projectile/energy/florayield
	name = "beta somatoray"
	icon_state = "energy2"
	damage_types = list(TOX = 0)
	nodamage = TRUE
	check_armour = ARMOR_ENERGY

/obj/item/projectile/energy/florayield/on_impact(atom/target)
	var/mob/M = target
	if(ishuman(target)) //These rays make plantmen fat.
		var/mob/living/carbon/human/H = M
		if((H.species.flags & IS_PLANT) && (H.nutrition < 500))
			H.nutrition += 30
	else if (istype(target, /mob/living/carbon/))
		M.show_message("\blue The radiation beam dissipates harmlessly through your body.")
	else
		return 1

/obj/item/projectile/energy/floraevolve
	name = "gamma somatoray"
	icon_state = "plasma"
	damage_types = list(TOX = 0)
	nodamage = TRUE
	check_armour = ARMOR_ENERGY

/obj/item/projectile/energy/floraevolve/on_impact(atom/target)
	var/mob/M = target
	if(ishuman(target)) //These rays make plantmen fat.
		var/mob/living/carbon/human/H = M
		if((H.species.flags & IS_PLANT) && (H.nutrition < 500))
			H.nutrition += 30
	else if (istype(target, /mob/living/carbon/))
		M.show_message("\blue The evolution beam dissipates harmlessly through your body.")
	else
		return 1


/obj/item/projectile/beam/mindflayer
	name = "flayer ray"

/obj/item/projectile/beam/mindflayer/on_impact(atom/target)
	if(ishuman(target))
		var/mob/living/carbon/human/M = target
		M.confused += rand(5,8)

/obj/item/projectile/chameleon
	name = "bullet"
	icon_state = "bullet"
	damage_types = list(HALLOS = 1)
	embed = 0 // nope
	nodamage = TRUE
	muzzle_type = /obj/effect/projectile/bullet/muzzle


/obj/item/projectile/flamer_lob
	name = "blob of fuel"
	icon_state = "fireball"
	damage_types = list(BURN = 16)
	check_armour = ARMOR_MELEE
	var/life = 3
	var/fire_stacks = 1 //10 pain a fire proc through ALL armor!

/obj/item/projectile/flamer_lob/on_hit(atom/target, blocked = FALSE)
	. = ..()
	if(isliving(target))
		var/mob/living/M = target
		M.adjust_fire_stacks(fire_stacks)
		M.IgniteMob()

/obj/item/projectile/flamer_lob/New()
	.=..()

/obj/item/projectile/flamer_lob/Move(atom/A)
	.=..()
	life--
	var/turf/T = get_turf(src)
	if(T)
		new/obj/effect/decal/cleanable/liquid_fuel(T, 1 , 1)
		T.hotspot_expose((T20C*2) + 380,500)
	if(!life)
		qdel(src)

/obj/item/projectile/flamer_lob/flamethrower
	life = 5
