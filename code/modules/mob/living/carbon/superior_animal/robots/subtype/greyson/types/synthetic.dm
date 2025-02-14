/mob/living/carbon/superior_animal/robot/greyson/synthetic
	name = "Greyson Positronic FBP-Utility unit"
	desc = "A full body positronic, tasked with carrying out a variety of duties. This one is unarmed."
	icon = 'icons/mob/mobs-humanoid.dmi'
	icon_state = "nanotrasen"
	attacktext = "punched"
	turns_per_move = 7
	move_to_delay = 2
	health = 125
	maxHealth = 125
	cleaning = FALSE

/mob/living/carbon/superior_animal/robot/greyson/synthetic/epistol
	name = "Greyson Positronic FBP-SEC Mark I unit"
	desc = "A full body positronic, tasked with carrying out security duty without emotion, remorse, or questions. This one is has an old style energy pistol built into its arm."
	icon_state = "nanotrasenranged"
	ranged = 1

/mob/living/carbon/superior_animal/robot/greyson/synthetic/epistol/New()
	..()
	if(prob(20))
		drop2 = /obj/item/gun/energy/retro
	if(prob(30))
		cell_drop = /obj/item/cell/medium

/mob/living/carbon/superior_animal/robot/greyson/synthetic/epistol/esmg
	name = "Greyson Positronic FBP-SEC Mark II unit"
	desc = "A full body positronic, tasked with carrying out security duty without emotion, remorse, or questions. This one is has a modified burst fire cog laser rifle built into its arm."
	icon_state = "nanotrasenrangedsmg"
	rapid = 1
	ranged_cooldown = 3
	projectiletype = /obj/item/projectile/beam/pulse/drone

/mob/living/carbon/superior_animal/robot/greyson/synthetic/epistol/rifle
	name = "Greyson Positronic FBP-SEC Mark III unit"
	desc = "A full body positronic, tasked with carrying out security duty without emotion, remorse, or questions. This one is has a modified heavy duty cog carbine built into its arm."
	icon_state = "nanotrasenrangedassault"
	projectiletype = /obj/item/projectile/beam/midlaser

/mob/living/carbon/superior_animal/robot/greyson/synthetic/epistol/heavy
	name = "Greyson Positronic FBP-SEC Heavy unit"
	desc = "A full body positronic, tasked with carrying out security duty without emotion, remorse, or questions. This one is has an overclocked super cog laser rifle built in his arm."
	icon_state = "nanotrasen_ert"
	projectiletype = /obj/item/projectile/beam/heavylaser
	armor = list(melee = 35, bullet = 25, energy = 40, bomb = 60, bio = 100, rad = 100) //We want to be gunned down, not lasered
