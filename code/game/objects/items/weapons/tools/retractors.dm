/obj/item/tool/retractor
	name = "retractor"
	desc = "Retracts stuff."
	icon_state = "retractor"
	matter = list(MATERIAL_STEEL = 2)
	flags = CONDUCT
	origin_tech = list(TECH_MATERIAL = 1, TECH_BIO = 1)
	tool_qualities = list(QUALITY_RETRACTING = 35)

/obj/item/tool/retractor/adv
	name = "extended retractor"
	desc = "Retracts surgical incisions with greater precision and speed than normal."
	matter = list(MATERIAL_STEEL = 8, MATERIAL_PLASTEEL = 1)
	tool_qualities = list(QUALITY_RETRACTING = 60)

/obj/item/tool/retractor/adv/si
	icon_state = "retractor_SI"