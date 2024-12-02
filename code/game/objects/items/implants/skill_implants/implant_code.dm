/obj/item/implant/skill
	name = "skill" //teeeeeest.
	desc = "Hey! You dont see it!"
	icon = 'icons/obj/items/implants.dmi'
	icon_state = "implant"
	w_class = WEIGHT_CLASS_TINY
	var/list/max_skills
	var/storage_skill = null
//pamplet copy-past. :clueless:
	var/cqc
	var/melee_weapons
	var/firearms
	var/pistols
	var/shotguns
	var/rifles
	var/smgs
	var/heavy_weapons
	var/swordplay
	var/smartgun
	var/engineer
	var/construction
	var/leadership
	var/medical
	var/surgery
	var/pilot
	var/police
	var/powerloader
	var/large_vehicle
	var/stamina

/obj/item/implant/skill/Initialize()
	. = ..()
	name = name + " implant"
	if(!allowed_limbs)
		allowed_limbs = GLOB.human_body_parts

/obj/item/implant/skill/on_initialize()
	return

/obj/item/implant/skill/try_implant(mob/living/carbon/human/target, mob/living/user)
	if(!ishuman(target))
		return
	if(!(user.zone_selected in allowed_limbs))
		to_chat(user, span_warning("You cannot implant this into that limb!"))
		return FALSE
	implanted = TRUE
	return implant(target, user)

/obj/item/implant/skill/implant(mob/living/carbon/human/target, mob/living/user)
	forceMove(target)
	implant_owner = target
	implanted = TRUE
	var/limb_targeting = (user ? user.zone_selected : BODY_ZONE_CHEST)
	var/datum/limb/affected = target.get_limb(limb_targeting)
	if(!affected)
		CRASH("[src] implanted into [target] [user ? "by [user]" : ""] but had no limb, despite being set to implant in [limb_targeting].")
	affected.implants += src
	part = affected
	activation_action?.give_action(target)
	embed_into(target, limb_targeting, TRUE)
	target.set_skills(target.skills.modifyRating(cqc, melee_weapons, firearms, pistols, shotguns, rifles, smgs, heavy_weapons, swordplay, smartgun,\
	engineer, construction, leadership, medical, surgery, pilot, police, powerloader, large_vehicle, stamina))
	return TRUE

/obj/item/implant/skill/unimplant()
	if(!implanted)
		return FALSE
	activation_action?.remove_action(implant_owner)
	implanted = FALSE
	part.implants -= src
	part = null
	implant_owner.set_skills(implant_owner.skills.modifyRating(-cqc, -melee_weapons, -firearms, -pistols, -shotguns, -rifles, -smgs, -heavy_weapons, -swordplay, -smartgun,\
	-engineer, -construction, -leadership, -medical, -surgery, -pilot, -police, -powerloader, -large_vehicle, -stamina))
	forceMove(get_turf(implant_owner))
	implant_owner = null

/obj/item/implant/skill/combat
	name = "combat implants"
	desc = "Non-game"
	icon_state = "combat_implant"
	allowed_limbs = list(BODY_ZONE_L_ARM, BODY_ZONE_R_ARM)

/obj/item/implant/skill/codex
	name = "CODEX"
	desc = "A support skill update-shit."
	icon_state = "support_implant"
	allowed_limbs = list(BODY_ZONE_CHEST, BODY_ZONE_PRECISE_GROIN)

/obj/item/implant/skill/oper_system
	name = "HEAD SLOT!"
	desc = "All non-sorted special shit (leadership, probaly SG and more)"
	icon_state = "skill_implant"
	allowed_limbs = list(BODY_ZONE_HEAD)
