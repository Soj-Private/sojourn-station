//This is set of item created to work with Eris stat and perk systems
//The idea here is simple, you find oddities in random spawners, you use them, and they grant you stats, or even perks.
//After use, the object is claimed, and cannot be used by someone else
//If rebalancing is needed, keep in mind spawning rate of those items, it might be good idea to change that as well
//Clockrigger 2019

/obj/item/oddity
	name = "An Oddity"
	desc = "Strange item of uncertain origin."
	icon = 'icons/obj/oddities.dmi'
	icon_state = "techno_part3"
	item_state = "techno_part3"
	w_class = ITEM_SIZE_SMALL

//You choose what stat can be increased, and a maximum value that will be added to this stat
//The minimum is defined above. The value of change will be decided by random
	var/random_stats = TRUE
	var/list/oddity_stats
	var/sanity_value = 1
	var/datum/perk/oddity/perk
	var/prob_perk = 10


/obj/item/oddity/Initialize()
	. = ..()
	AddComponent(/datum/component/atom_sanity, sanity_value, "")
	if(!perk && prob(prob_perk))
		perk = get_oddity_perk()
	if(oddity_stats)
		if(random_stats)
			for(var/stat in oddity_stats)
				oddity_stats[stat] = rand(1, oddity_stats[stat])
		AddComponent(/datum/component/inspiration, oddity_stats, perk)

/proc/get_oddity_perk()
	return pick(subtypesof(/datum/perk/oddity))

/obj/item/oddity/examine(user)
	..()
	if(perk)
		to_chat(user, SPAN_NOTICE("<span style='color:orange'>A strange aura comes from this oddity, it is more than just a curio, its an anomaly...</span>"))
		if(usr.stats?.getPerk(PERK_STALKER))
			var/datum/perk/oddity/OD = GLOB.all_perks[perk]
			to_chat(user, SPAN_NOTICE("Instinct tells you more about this anomaly: <span style='color:orange'>[OD]. [OD.desc]</span>"))
	for(var/stat in oddity_stats)
		var/aspect
		switch(oddity_stats[stat])
			if(30 to INFINITY)
				aspect = "a <span style='color:#cd00ff;'>REALITY-BENDING</span>"
			if(10 to 30)
				aspect = "an <span style='color:#d0b050;'>overwhelming</span>"
			if(6 to 10)
				aspect = "a <span class='red'>strong</span>"
			if(3 to 6)
				aspect = "a <span class='green'>medium</span>"
			if(1 to 3)
				aspect = "a <span class='blue'>weak</span>"
			else
				continue
		to_chat(user, SPAN_NOTICE("This item has [aspect] aspect of [stat]"))


//Oddities are separated into categories depending on their origin. They are meant to be used both in maints and derelicts, so this is important
//This is done by subtypes, because this way even densiest code monkey will not able to misuse them
//They are meant to be put in appropriate random spawners

//Common - you can find those everywhere
/obj/item/oddity/common/blueprint
	name = "strange blueprint"
	desc = "There's no telling what this design is supposed to be. Whatever could be built from this likely wouldn't work yet the Greyson Positronic logo near the top makes one wonder."
	icon_state = "blueprint"
	oddity_stats = list(
		STAT_COG = 5,
		STAT_MEC = 7,
	)

/obj/item/oddity/common/coin
	name = "strange coin"
	desc = "It appears to be more of a collectible than any sort of actual currency. What metal it's made from seems to be a mystery."
	icon_state = "coin"
	oddity_stats = list(
		STAT_ROB = 5,
		STAT_TGH = 5,
	)

/obj/item/oddity/common/photo_landscape
	name = "alien landscape photo"
	desc = "There is some ire about the planet in this photograph."
	icon_state = "photo_landscape"
	oddity_stats = list(
		STAT_COG = 5,
		STAT_TGH = 5,
	)

/obj/item/oddity/common/photo_coridor
	name = "surreal maint photo"
	desc = "The corridor in this photograph looks familiar, though something seems wrong about it; it's as if everything in it was replaced with an exact replica of itself."
	icon_state = "photo_corridor"
	oddity_stats = list(
		STAT_MEC = 5,
		STAT_TGH = 5,
	)

/obj/item/oddity/common/photo_eyes
	name = "observer photo"
	desc = "Just looking at this photo sparks a primal fear in your heart."
	icon_state = "photo_corridor"
	oddity_stats = list(
		STAT_ROB = 6,
		STAT_TGH = 6,
		STAT_VIG = 6,
	)

/obj/item/oddity/common/old_newspaper
	name = "odd newspaper clipping" //Old old news papers are a good joke
	desc = "It contains a report on some old and strange phenomenon. Maybe it's lies, maybe it's corporate experiments gone wrong. The date listed on it is impossible, yet it bears the stamp of the Nadezhda."
	icon_state = "old_newspaper"
	oddity_stats = list(
		STAT_MEC = 4,
		STAT_COG = 4,
		STAT_BIO = 4,
	)

/obj/item/oddity/common/paper_crumpled
	name = "turn-out page"
	desc = "This ALMOST makes sense, it details connections and similarities between groups, yet the nonsensical phrasing makes it seem like one huge conspiracy."
	icon_state = "paper_crumpled"
	oddity_stats = list(
		STAT_MEC = 6,
		STAT_COG = 6,
		STAT_BIO = 6,
	)

/obj/item/oddity/common/broken_glass
	name = "smashed glass jar"
	desc = "A broken glass jar, covered in dust and left with a stained rim."
	icon_state = "broken_glassjar"
	oddity_stats = list(
		STAT_BIO = 10,
		STAT_ROB = 5,
	)

/obj/item/oddity/common/paper_omega
	name = "collection of obscure reports"
	desc = "Even the authors seem to be rather skeptical about their findings. The reports are not connected to each other, but their results are similar. The logo is faded, making it hard to tell if this was Greyson, Soteria, or an independent group."
	icon_state = "paper_omega"
	oddity_stats = list(
		STAT_MEC = 8,
		STAT_COG = 8,
		STAT_BIO = 8,
	)

/obj/item/oddity/common/book_eyes
	name = "observer book"
	desc = "This book details information on some cybernetic creatures. Who did this? How is this even possible? The illustrations bear uncomfortable likeness to hivemind abominations."
	icon_state = "book_eyes"
	oddity_stats = list(
		STAT_ROB = 9,
		STAT_TGH = 9,
		STAT_VIG = 9,
	)

/obj/item/oddity/common/book_omega
	name = "occult book"
	desc = "Most of the stories in this book seem to be the writings of madmen, but at least the stories are interesting. Some of the phrases are written in Latin, an odd thing in this day and age."
	icon_state = "book_omega"
	oddity_stats = list(
		STAT_BIO = 6,
		STAT_ROB = 6,
		STAT_VIG = 6,
	)

/obj/item/oddity/common/broken_key
	name = "broken key"
	desc = "A yellow or golden key that goes to who knows what. The end bit broken off..."
	icon_state = "broken_key"
	oddity_stats = list(
		STAT_COG = 15,
	)

/obj/item/oddity/common/book_bible
	name = "old bible"
	desc = "Oh, how quickly we forgot."
	icon_state = "book_bible"
	oddity_stats = list(
		STAT_ROB = 5,
		STAT_VIG = 5,
	)

/obj/item/oddity/common/book_log
	name = "forgotten logs"
	desc = "A once detailed book containing information on all manner of things, slashes and now ruined pages are whats left..."
	icon_state = "book_log"
	oddity_stats = list(
		STAT_TGH = 8,
		STAT_ROB = 5,
		STAT_MEC = 5,
	)

/obj/item/oddity/common/old_money
	name = "old money"
	desc = "It's not like the organization that issued this exists anymore."
	icon_state = "old_money"
	oddity_stats = list(
		STAT_ROB = 4,
		STAT_TGH = 4,
	)

/obj/item/oddity/common/healthscanner
	name = "odd health scanner"
	desc = "It's broken and stuck on some really strange readings. Was this even human?"
	icon_state = "healthscanner"
	item_state = "electronic"
	oddity_stats = list(
		STAT_COG = 8,
		STAT_BIO = 8,
	)

/obj/item/oddity/common/old_pda
	name = "broken pda"
	desc = "An old unknown era PDA. These were issued to their employees all throughout the galaxy."
	icon_state = "old_pda"
	item_state = "electronic"
	oddity_stats = list(
		STAT_COG = 6,
		STAT_MEC = 6,
	)

/obj/item/oddity/common/towel
	name = "trustworthy towel"
	desc = "It's always good to have one with you."
	icon_state = "towel"
	oddity_stats = list(
		STAT_ROB = 6,
		STAT_TGH = 6,
	)

/obj/item/oddity/common/teddy
	name = "teddy bear"
	desc = "He will be there for you, even in tough times."
	icon_state = "teddy"
	oddity_stats = list(
		STAT_ROB = 7,
		STAT_TGH = 7,
		STAT_VIG = 7,
	)

/obj/item/oddity/common/old_knife
	name = "old knife"
	desc = "Is this blood older than you? You can't tell and will never know."
	icon_state = "old_knife"
	item_state = "knife"
	structure_damage_factor = STRUCTURE_DAMAGE_BLADE
	tool_qualities = list(QUALITY_CUTTING = 20,  QUALITY_WIRE_CUTTING = 10, QUALITY_SCREW_DRIVING = 5)
	force = WEAPON_FORCE_DANGEROUS
	attack_verb = list("slashed", "stabbed", "sliced", "torn", "ripped", "diced", "cut")
	hitsound = 'sound/weapons/bladeslice.ogg'
	slot_flags = SLOT_BELT
	sharp = 1
	edge = 1

	oddity_stats = list(
		STAT_ROB = 10,
		STAT_TGH = 10,
		STAT_VIG = 10,
	)

/obj/item/oddity/common/rusted_sword
	name = "rusted sword" //Sword was never maintained or used
	desc = "A withered sword hilt with a rusted blade still barely slotted in place. Was this just for show?"
	icon_state = "rusted_sword"
	item_state = "knife"
	structure_damage_factor = STRUCTURE_DAMAGE_BLADE
	tool_qualities = list(QUALITY_CUTTING = 20,  QUALITY_WIRE_CUTTING = 10, QUALITY_SCREW_DRIVING = 5)
	force = WEAPON_FORCE_ROBUST
	attack_verb = list("slashed", "stabbed", "sliced", "torn", "ripped", "diced", "cut")
	hitsound = 'sound/weapons/bladeslice.ogg'
	slot_flags = SLOT_BELT
	sharp = 1
	edge = 1

	oddity_stats = list(
		STAT_MEC = 10, //What maintance prevents
		STAT_BIO = 10, //Understanding rot and rust
		STAT_VIG = 10, //Showings of degrading
	)

/obj/item/oddity/common/old_id
	name = "old id"
	desc = "There is a story behind this name. Untold and cruel in fate."
	icon_state = "old_id"
	oddity_stats = list(
		STAT_VIG = 9,
	)

/obj/item/oddity/techno
	name = "Unknown technological part"
	desc = "A technological part made by Artificer Perfection Cube."
	icon_state = "techno_part1"

/obj/item/oddity/techno/Initialize()
	icon_state = "techno_part[rand(1,7)]"
	.=..()

/obj/item/oddity/common/old_radio
	name = "old radio"
	desc = "Close your eyes, bring it closer and listen. You can almost hear it, in the edge of your consciousness. The world is ticking."
	icon_state = "old_radio"
	oddity_stats = list(
		STAT_COG = 9,
		STAT_VIG = 9,
	)

/obj/item/oddity/common/paper_bundle
	name = "paper bundle"
	desc = "Somewhere there is a truth, hidden under all of this scrap."
	icon_state = "paper_bundle"
	oddity_stats = list(
		STAT_BIO = 6,
		STAT_ROB = 6,
		STAT_VIG = 6,
	)

/obj/item/oddity/common/disk
	name = "broken design disk"
	desc = "This disk is corrupted and completely unusable. It has a hand-drawn picture of some strange mechanism on it - looking at it for too long makes your head hurt."
	icon_state = "disc"
	oddity_stats = list(
		STAT_MEC = 10,
	)

/obj/item/oddity/common/mirror
	name = "cracked mirror"
	desc = "A thousand mirror images stare back at you as you examine the trinket. What if you're the reflection, staring back out at the real world? At the real you?"
	icon_state = "mirror"
	oddity_stats = list(
		STAT_COG = 4,
		STAT_VIG = 4,
	)

/obj/item/oddity/common/lighter
	name = "rusted lighter"
	desc = "This zippo lighter is rusted shut. It smells faintly of sulphur and blood."
	icon_state = "syndicate_lighter"
	oddity_stats = list(
		STAT_TGH = 10,
	)

/obj/item/oddity/common/device
	name = "odd device"
	desc = "Something about this gadget both disturbs and interests you. Its manufacturer's name has been mostly smudged away, but you can see a strange mechanism as their logo."
	icon_state = "device"
	oddity_stats = list(
		STAT_MEC = 8,
		STAT_COG = 8,
	)

/obj/item/oddity/common/book_unholy
	name = "unholy book"
	desc = "The writings inside entail some strange ritual. Pages have been torn out or smudged to illegibility."
	icon_state = "book_skull"
	oddity_stats = list(
		STAT_COG = 7,
		STAT_MEC = 7,
	)

/obj/item/oddity/common/photo_crime
	name = "crime scene photo"
	desc = "It is unclear whether this is a victim of suicide or murder. His face is frozen in a look of agony and terror, and you shudder to think at what his last moments might have been."
	icon_state = "photo_crime"
	oddity_stats = list(
		STAT_COG = 7,
		STAT_VIG = 7,
	)

/obj/item/oddity/rare/eldritch_tie
	name = "Horrifying tie"
	desc = "A tie no one would be caught dead wearing!"
	icon_state = "eldritch_tie"
	oddity_stats = list(
		STAT_COG = 6,
		STAT_TGH = 6,
		STAT_BIO = 6,
		STAT_ROB = 6,
	)
	price_tag = 2000 //Its a good tie for a collector
	perk = /datum/perk/sure_step //Insainly rare and ok stats, but really its the perk. In Disco-E this perk would save you so much making this the perfect joke

//Non-Spawn
//Odditys that are event only or spawned in on map gen
/obj/item/oddity/rare/golden_cup
	name = "Plasma Tag Trophy"
	desc = "A trophy earned during the monthly plasma tag competitions between various factions. The gold is fashioned from anomalous metal, giving it beneficial properties to carry with you. Hold your factions achievement high!"
	icon_state = "golden_cup"
	oddity_stats = list(
		STAT_ROB = 9,
		STAT_TGH = 9,
		STAT_VIG = 9,
		STAT_BIO = 9,
		STAT_ROB = 9,
		STAT_VIG = 9,
	)
	perk = /datum/perk/oddity/gunslinger

/obj/item/oddity/broken_necklace
	name = "Broken necklace"
	desc = "A broken necklace that has a blue crystal as a trinket."
	icon_state = "broken_necklace"
	origin_tech = list(TECH_BLUESPACE = 9)
	oddity_stats = list(
		STAT_COG = 9,
		STAT_VIG = 9,
		STAT_ROB = 9,
		STAT_TGH = 9,
		STAT_BIO = 9,
		STAT_MEC = 9
	)
	var/cooldown
	var/entropy_value = 5
	var/blink_range = 8

/obj/item/oddity/broken_necklace/New()
	..()
	GLOB.bluespace_gift++
	GLOB.bluespace_entropy -= rand(30, 50)

/obj/item/oddity/broken_necklace/examine(user, distance)
	. = ..()
	var/area/my_area = get_area(src)
	switch(my_area.bluespace_entropy)
		if(0 to my_area.bluespace_hazard_threshold*0.3)
			to_chat(user, SPAN_NOTICE("This feels cold to the touch."))

		if(my_area.bluespace_hazard_threshold*0.7 to INFINITY)
			to_chat(user, SPAN_NOTICE("This feels warm to the touch."))

	if(GLOB.bluespace_entropy > GLOB.bluespace_hazard_threshold*0.7)
		to_chat(user, SPAN_NOTICE("Has it always shone so brightly?"))

	if(my_area.bluespace_entropy > my_area.bluespace_hazard_threshold*0.95 || GLOB.bluespace_hazard_threshold > GLOB.bluespace_hazard_threshold*0.95)
		to_chat(user, SPAN_NOTICE("You can see an inscription in some language unknown to you."))


/obj/item/oddity/broken_necklace/Destroy()
	var/turf/T = get_turf(src)
	if(T)
		bluespace_entropy(80,T)
		new /obj/item/bluespace_dust(T)
	GLOB.bluespace_gift--
	return ..()

/obj/item/oddity/broken_necklace/attack_self(mob/user)
	if(world.time < cooldown)
		return
	cooldown = world.time + 3 SECONDS
	user.visible_message(SPAN_WARNING("[user] crushes [src]!"), SPAN_DANGER("You crush [src]!"))
	var/datum/effect/effect/system/spark_spread/sparks = new /datum/effect/effect/system/spark_spread()
	sparks.set_up(3, 0, get_turf(user))
	sparks.start()
	var/turf/T = get_random_secure_turf_in_range(user, blink_range, 2)
	go_to_bluespace(get_turf(user), entropy_value, TRUE, user, T)
	for(var/obj/item/grab/G in user.contents)
		if(G.affecting)
			go_to_bluespace(get_turf(user), entropy_value, FALSE, G.affecting, locate(T.x+rand(-1,1),T.y+rand(-1,1),T.z))
	if(prob(1))
		qdel(src)

/obj/item/oddity/broken_necklace/throw_impact(atom/movable/hit_atom)
	if(!..()) // not caught in mid-air
		visible_message(SPAN_NOTICE("[src] fizzles upon impact!"))
		var/turf/T = get_turf(hit_atom)
		var/datum/effect/effect/system/spark_spread/sparks = new /datum/effect/effect/system/spark_spread()
		sparks.set_up(3, 0, T)
		sparks.start()
		if(!hit_atom.anchored)
			var/turf/NT = get_random_turf_in_range(hit_atom, blink_range, 2)
			go_to_bluespace(T, entropy_value, TRUE, hit_atom, NT)
		if(prob(1))
			qdel(src)

/obj/item/oddity/blackbox_nanoforge
	name = "Matter Nano-Forge Black Box"
	desc = "The core and data of all the designs for the Matter Nano-Forge. The craftsmanship being some of the best possible by hand tools alone."
	icon = 'icons/obj/stationobjs.dmi'
	icon_state = "blackcube"
	oddity_stats = list(
		STAT_COG = 15,
		STAT_MEC = 15
	)
	perk = /datum/perk/guild/blackbox_insight

//A randomized oddity with random stats, meant for artist job project
/obj/item/oddity/artwork
	name = "Strange Device"
	desc = "You can't find out how to turn it on. Maybe it's already working?"
	icon_state = "artwork_1"
	price_tag = 200
	prob_perk = 0//no perks for artwork oddities

/obj/item/oddity/artwork/Initialize()
	name = get_weapon_name(capitalize = TRUE)
	icon_state = "artwork_[rand(1,6)]"
	. = ..()

/obj/item/oddity/artwork/get_item_cost(export)
	. = ..()
	GET_COMPONENT(comp_sanity, /datum/component/atom_sanity)
	. += comp_sanity.affect * 100
	GET_COMPONENT(comp_insp, /datum/component/inspiration)
	var/list/true_stats = comp_insp.calculate_statistics()
	for(var/stat in true_stats)
		. += true_stats[stat] * 50

//Faction Oddities
/obj/item/oddity/nt
	random_stats = FALSE

/obj/item/oddity/nt/seal
	name = "Cartographer's Seal"
	desc = "A badge carrying the seal of the cartographer of the Church of Absolute, said to be marked with a tithe of blood as proof of its sacred nature. An extremely rare sight, as many of these seals are thought to be lost. Merely holding one is said to inspire divine right. The church would be immensely interested in this."
	icon_state = "nt_seal"
	oddity_stats = list(
		STAT_TGH = 12,
		STAT_VIG = 12,
		STAT_ROB = 12
	)
	price_tag = 8000
	perk = /datum/perk/nt_oddity/holy_light

/obj/item/oddity/chimeric_fang_trophy
	name = "Chimera Fang Trophy"
	desc = "A scrimshaw carved chimera fang turned into a trophy, the bone either taken from a butchered chimera or hunting companion fallen in battle. In either case, its very presence hardens the holder's resolve."
	icon_state = "chimera_trophy"
	oddity_stats = list(
		STAT_ROB = 12,
		STAT_TGH = 12,
		STAT_BIO = 8
	)
	price_tag = 800 //Its a good trophy for a collector
	perk = /datum/perk/oddity/harden

/obj/item/oddity/si_bluespace_scanner
	name = "Bluespace Tuning Device"
	desc = "A tool used by SI to stablize and get readings of bluespace entropy." //TODO get a better desc, this is horrable the worst even
	icon_state = "si_scan"
	item_state = "si_scan"
	matter = list(MATERIAL_PLASTIC = 15, MATERIAL_STEEL = 10, MATERIAL_PLASMAGLASS = 2, MATERIAL_GOLD = 10, MATERIAL_SILVER = 10, MATERIAL_PLASMA = 5, MATERIAL_DIAMOND = 1)
	oddity_stats = list(
		STAT_COG = 2, //trash stats for mass-printed trash
		STAT_MEC = 2
	)
	perk = /datum/perk/oddity/sharp_mind //TODO: fix /datum/perk/bluespace

/obj/item/oddity/si_bluespace_scanner/examine(mob/living/user, distance)
	. = ..()
	if(!iscarbon(user) || !issilicon(user))
		return//Prevents ghosts form making a runtime
	if(!user.stats?.getPerk(PERK_SI_SCI) || !usr.stat_check(STAT_COG, 90)) //got to be smarts
		to_chat(usr, SPAN_WARNING("This tool is far to complex to read let alone use."))
		return
	var/area/my_area = get_area(src)
	switch(my_area.bluespace_entropy)
		if(0 to my_area.bluespace_hazard_threshold*0.3)
			to_chat(user, SPAN_NOTICE("The scanner reads the room to not be in danger of annomlies bluespace."))

		if(my_area.bluespace_hazard_threshold*0.7 to INFINITY)
			to_chat(user, SPAN_NOTICE("The scanner reads the room to have some level of danger form annomlies bluespace."))

	if(GLOB.bluespace_entropy > GLOB.bluespace_hazard_threshold*0.7)
		to_chat(user, SPAN_NOTICE("The scanner is giving off several warnings of entropy in area being to high!"))

	if(my_area.bluespace_entropy > my_area.bluespace_hazard_threshold*0.95 || GLOB.bluespace_hazard_threshold > GLOB.bluespace_hazard_threshold*0.95)
		to_chat(user, SPAN_NOTICE("Entropy in area has its readings off the chart..."))

/obj/item/oddity/code_book
	name = "Marshal Code Handbook"
	desc = "A heavy book with details and translations of the Marshal codes."
	icon_state = "book_code"
	oddity_stats = list(
		STAT_COG = 0
	)
	price_tag = 3200 //So we have a reason for stealing it
	perk = /datum/perk/codespeak
