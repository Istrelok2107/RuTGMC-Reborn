/obj/item/implanter
	name = "implanter"
	icon = 'icons/obj/items/implants.dmi'
	icon_state = "implanter0"
	item_icons = list(
		slot_l_hand_str = 'icons/mob/inhands/equipment/medical_left.dmi',
		slot_r_hand_str = 'icons/mob/inhands/equipment/medical_right.dmi',
	)
	item_state = "syringe_0"
	throw_speed = 1
	throw_range = 5
	w_class = WEIGHT_CLASS_TINY
	var/obj/item/implant/imp = null

/obj/item/implanter/Initialize(mapload, ...)
	. = ..()
	if(imp)
		imp = new imp(src)
		update_icon()

/obj/item/implanter/Destroy()
	QDEL_NULL(imp)
	return ..()

/obj/item/implanter/update_icon_state()
	. = ..()
	icon_state = "implanter[imp?"1":"0"]"

/obj/item/implanter/examine(mob/user, distance, infix, suffix)
	. = ..()
	. += "it contains [imp ? "a [imp.name]" : "no implant"]!"

/obj/item/implanter/attack(mob/target, mob/user)
	. = ..()
	if(!ishuman(target))
		return FALSE
	if(!imp)
		to_chat(user, span_warning("There is no implant in the [src]!"))
		return FALSE
	user.visible_message(span_warning("[user] is attemping to implant [target]."), span_notice("You're attemping to implant [target]."))

	if(!do_after(user, 5 SECONDS, NONE, target, BUSY_ICON_GENERIC) || !imp)
		to_chat(user, span_notice("You failed to implant [target]."))
		return

	if(imp.try_implant(target, user))
		target.visible_message(span_warning("[target] has been implanted by [user]."))
		log_combat(user, target, "implanted", src)
		imp = null
		update_icon()
		return TRUE
	to_chat(user, span_notice("You fail to implant [target]."))

/obj/item/implanter/neurostim
	name = "neurostim implanter"
	imp = /obj/item/implant/neurostim

/obj/item/implanter/chem
	name = "chem implant implanter"
	imp = /obj/item/implant/chem

/obj/item/implanter/chem/blood
	name = "blood recovery implant implanter"
	imp = /obj/item/implant/chem/blood

/obj/item/implanter/cloak
	name = "cloak implant implanter"
	imp = /obj/item/implant/cloak

/obj/item/implanter/blade
	name = "blade implant implanter"
	imp = /obj/item/implant/deployitem/blade

/obj/item/implanter/suicide_dust
	name = "Self-Gibbing implant"
	imp = /obj/item/implant/suicide_dust

/obj/item/implanter/cargo
	name = "implanter"
	icon_state = "cargo"
	var/spent = FALSE
	var/allowed_limbs
	var/list/implants

/obj/item/implanter/cargo/Initialize(mapload, ...)
	. = ..()
	update_icon_state()
	if(imp)
		update_icon_state()
		desc = imp.desc
		imp = new imp(src)
	if(!allowed_limbs)
		allowed_limbs = GLOB.human_body_parts

/obj/item/implanter/cargo/update_icon_state()
	. = ..()
	icon_state = "cargo"
	if(imp)
		icon_state = "cargo_full"
	if(!imp)
		icon_state = "cargo_s"

/obj/item/implanter/cargo/proc/has_implant(datum/limb/targetlimb)
	for (var/obj/item/implant/skill/I in targetlimb.implants)
		if(!is_type_in_list(I, GLOB.known_implants))
			return TRUE
	return FALSE

/obj/item/implanter/cargo/attack(mob/living/target, mob/living/user, list/implants, datum/limb/targetlimb, var/obj/item/implant/skill/i)
	. = ..()
	if(!ishuman(target))
		return FALSE
	if(spent == TRUE)
		balloon_alert(user, "already used!")
		return FALSE
	if(!imp)
		to_chat(user, span_warning("There is no implant in the [src]!"))
		return FALSE
	if(!(user.zone_selected in allowed_limbs))
		balloon_alert(user, "wrong limb!")
		return FALSE
	for(i in user.zone_selected)
		has_implant(targetlimb)
		balloon_alert(user, "limb already implanted!")
		return FALSE
	user.visible_message(span_warning("[user] is attemping to implant [target]."), span_notice("You're attemping to implant [target]."))
	if(!do_after(user, 5 SECONDS, NONE, target, BUSY_ICON_GENERIC) || !imp)
		to_chat(user, span_notice("You failed to implant [target]."))
		return FALSE
	if(imp.try_implant(target, user))
		target.visible_message(span_warning("[target] has been implanted by [user]."))
		log_combat(user, target, "implanted", src)
		imp = null
		spent = TRUE
		update_icon_state()
		return TRUE
	to_chat(user, span_notice("You fail to implant [target]."))
