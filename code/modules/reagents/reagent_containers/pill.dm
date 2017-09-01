////////////////////////////////////////////////////////////////////////////////
/// Pills.
////////////////////////////////////////////////////////////////////////////////

//randomizing pill icons
var/global/list/randomized_pill_icons


/obj/item/weapon/reagent_containers/pill
	name = "pill"
	icon = 'icons/obj/chemical.dmi'
	icon_state = null
	item_state = "pill"
	possible_transfer_amounts = null
	w_class = 1
	volume = 60
	var/pill_desc = "An unknown pill." //the real description of the pill, shown when examined by a medically trained person

	New()
		..()
		if(!randomized_pill_icons)
			var/allowed_numbers = list(1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20)
			randomized_pill_icons = list()
			for(var/i = 1 to 20)
				randomized_pill_icons += "pill[pick_n_take(allowed_numbers)]"
		if(!icon_state)
			icon_state = "pill[rand(1,20)]"


	examine(mob/user)
		..()
		if(!user.mind || !user.mind.skills_list || user.mind.skills_list["medical"] >= SKILL_MEDICAL_CHEM)
			user << pill_desc
		else
			user << "You don't know what's in it."

	attack_self(mob/user as mob)
		return

	attack(mob/M, mob/user, def_zone)

		if(M == user)

			if(istype(M, /mob/living/carbon/human))
				var/mob/living/carbon/human/H = M
				if(H.species.flags & IS_SYNTHETIC)
					H << "\red You can't eat pills."
					return

			M << "\blue You swallow [src]."
			M.drop_inv_item_on_ground(src) //icon update
			if(reagents.total_volume)
				reagents.trans_to_ingest(M, reagents.total_volume)
				cdel(src)
			else
				cdel(src)
			return 1

		else if(istype(M, /mob/living/carbon/human) )

			var/mob/living/carbon/human/H = M
			if(H.species.flags & IS_SYNTHETIC)
				H << "\red They have a monitor for a head, where do you think you're going to put that?"
				return

			for(var/mob/O in viewers(world.view, user))
				O.show_message("\red [user] attempts to force [M] to swallow [src].", 1)

			if(!do_mob(user, M, 30, BUSY_ICON_CLOCK, BUSY_ICON_MED)) return

			user.drop_inv_item_on_ground(src) //icon update
			for(var/mob/O in viewers(world.view, user))
				O.show_message("\red [user] forces [M] to swallow [src].", 1)

			M.attack_log += text("\[[time_stamp()]\] <font color='orange'>Has been fed [src.name] by [user.name] ([user.ckey]) Reagents: [reagentlist(src)]</font>")
			user.attack_log += text("\[[time_stamp()]\] <font color='red'>Fed [M.name] by [M.name] ([M.ckey]) Reagents: [reagentlist(src)]</font>")
			msg_admin_attack("[user.name] ([user.ckey]) fed [M.name] ([M.ckey]) with [src.name] Reagents: [reagentlist(src)] (INTENT: [uppertext(user.a_intent)]) (<A HREF='?_src_=holder;adminplayerobservecoodjump=1;X=[user.x];Y=[user.y];Z=[user.z]'>JMP</a>)")

			if(reagents.total_volume)
				reagents.trans_to_ingest(M, reagents.total_volume)
				cdel(src)
			else
				cdel(src)

			return 1

		return 0

	afterattack(obj/target, mob/user, proximity)
		if(!proximity) return

		if(target.is_open_container() != 0 && target.reagents)
			if(!target.reagents.total_volume)
				user << "\red [target] is empty. Cant dissolve pill."
				return
			user << "\blue You dissolve the pill in [target]"

			user.attack_log += text("\[[time_stamp()]\] <font color='red'>Spiked \a [target] with a pill. Reagents: [reagentlist(src)]</font>")
			msg_admin_attack("[user.name] ([user.ckey]) spiked \a [target] with a pill. Reagents: [reagentlist(src)] (INTENT: [uppertext(user.a_intent)]) (<A HREF='?_src_=holder;adminplayerobservecoodjump=1;X=[user.x];Y=[user.y];Z=[user.z]'>JMP</a>)")

			reagents.trans_to(target, reagents.total_volume)
			for(var/mob/O in viewers(2, user))
				O.show_message("\red [user] puts something in \the [target].", 1)

			spawn(5)
				cdel(src)

		return

////////////////////////////////////////////////////////////////////////////////
/// Pills. END
////////////////////////////////////////////////////////////////////////////////

//Pills
/obj/item/weapon/reagent_containers/pill/antitox
	pill_desc = "An anti-toxins pill (25u), it neutralizes many common toxins."
	New()
		..()
		icon_state = randomized_pill_icons[1]
		reagents.add_reagent("anti_toxin", 25)

/obj/item/weapon/reagent_containers/pill/tox
	pill_desc = "A toxins pill, it's highly toxic."
	New()
		..()
		icon_state = randomized_pill_icons[2]
		reagents.add_reagent("toxin", 50)

/obj/item/weapon/reagent_containers/pill/cyanide
	pill_desc = "A cyanide pill, don't swallow this!"
	New()
		..()
		icon_state = randomized_pill_icons[2]
		reagents.add_reagent("cyanide", 50)

/obj/item/weapon/reagent_containers/pill/adminordrazine
	pill_desc = "An Adminordrazine pill, it's magic. We don't have to explain it."
	New()
		..()
		icon_state = randomized_pill_icons[3]
		reagents.add_reagent("adminordrazine", 50)

/obj/item/weapon/reagent_containers/pill/stox
	pill_desc = "A sleeping pill, commonly used to treat insomnia."
	New()
		..()
		icon_state = randomized_pill_icons[4]
		reagents.add_reagent("stoxin", 15)

/obj/item/weapon/reagent_containers/pill/kelotane
	pill_desc = "A Kelotane pill (15u), Used to treat burns."
	New()
		..()
		icon_state = randomized_pill_icons[5]
		reagents.add_reagent("kelotane", 15)

/obj/item/weapon/reagent_containers/pill/paracetamol
	pill_desc = "A Paracetamol pill, painkiller for the ages."
	New()
		..()
		icon_state = randomized_pill_icons[6]
		reagents.add_reagent("paracetamol", 15)

/obj/item/weapon/reagent_containers/pill/tramadol
	pill_desc = "A Tramadol pill (15u), simple painkiller."
	New()
		..()
		icon_state = randomized_pill_icons[7]
		reagents.add_reagent("tramadol", 15)


/obj/item/weapon/reagent_containers/pill/methylphenidate
	pill_desc = "A Methylphenidate pill, improves the ability to concentrate."
	New()
		..()
		icon_state = randomized_pill_icons[8]
		reagents.add_reagent("methylphenidate", 15)

/obj/item/weapon/reagent_containers/pill/citalopram
	pill_desc = "A Citalopram pill, mild anti-depressant."
	New()
		..()
		icon_state = randomized_pill_icons[9]
		reagents.add_reagent("citalopram", 15)


/obj/item/weapon/reagent_containers/pill/inaprovaline
	pill_desc = "A Inaprovaline pill (30u), used to stabilize patients."
	New()
		..()
		icon_state = randomized_pill_icons[10]
		reagents.add_reagent("inaprovaline", 30)

/obj/item/weapon/reagent_containers/pill/dexalin
	pill_desc = "A Dexalin pill (15u), used to treat oxygen deprivation."
	New()
		..()
		icon_state = randomized_pill_icons[11]
		reagents.add_reagent("dexalin", 15)

/obj/item/weapon/reagent_containers/pill/spaceacillin
	pill_desc = "A Spaceacillin pill (10u), used to treat infected wounds and slow down viral infections."
	New()
		..()
		icon_state = randomized_pill_icons[12]
		reagents.add_reagent("spaceacillin", 10)

/obj/item/weapon/reagent_containers/pill/happy
	pill_desc = "A Happy Pill! Happy happy joy joy!"
	New()
		..()
		icon_state = randomized_pill_icons[13]
		reagents.add_reagent("space_drugs", 15)
		reagents.add_reagent("sugar", 15)

/obj/item/weapon/reagent_containers/pill/zoom
	pill_desc = "A Zoom Pill! Zoooom!"
	New()
		..()
		icon_state = randomized_pill_icons[14]
		reagents.add_reagent("impedrezene", 10)
		reagents.add_reagent("synaptizine", 5)
		reagents.add_reagent("hyperzine", 5)



/obj/item/weapon/reagent_containers/pill/russianRed
	pill_desc = "A Russian Red (10u) pill, an EXTREME radiation countering pill. VERY dangerous"
	New()
		..()
		icon_state = randomized_pill_icons[15]
		reagents.add_reagent("russianred", 10)


/obj/item/weapon/reagent_containers/pill/peridaxon
	pill_desc = "A Peridaxon (10u) pill, heals internal organ damage"
	New()
		..()
		icon_state = randomized_pill_icons[16]
		reagents.add_reagent("peridaxon", 10)


/obj/item/weapon/reagent_containers/pill/imidazoline
	pill_desc = "A Imidazoline (10u) pill, heals eye damage"
	New()
		..()
		icon_state = randomized_pill_icons[17]
		reagents.add_reagent("imidazoline", 10)


/obj/item/weapon/reagent_containers/pill/alkysine
	pill_desc = "A Alkysine (10u) pill, heals brain damage"
	New()
		..()
		icon_state = randomized_pill_icons[18]
		reagents.add_reagent("alkysine", 10)


/obj/item/weapon/reagent_containers/pill/bicaridine
	pill_desc = "A Bicaridine (10u) pill, heals Brute damage."
	New()
		..()
		icon_state = randomized_pill_icons[19]
		reagents.add_reagent("bicaridine", 10)
