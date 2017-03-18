note
	description: "Summary description for {MESSENGER}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	MESSENGER

create make

feature {NONE} -- private attributes

	users: SORTED_TWO_WAY_LIST[USER]
	groups: SORTED_TWO_WAY_LIST[GROUP]
	all_messages: LINKED_LIST[TUPLE[m_number: INTEGER_64; sender: INTEGER_64; group: INTEGER_64; content: STRING]]

feature -- attributes

	message_number: INTEGER_64
	sort_by_id: BOOLEAN

	num_users: INTEGER_64
		do
			Result := users.count
		end

	num_groups: INTEGER_64
		do
			Result := groups.count
		end

feature -- creation
	make
		do
			create users.make
			create groups.make
			create all_messages.make
			message_number := 1
		end

feature -- commands

	add_user (id: INTEGER_64; name: STRING)
		require
			id_positive: id > 0
			first_letter_alpha: name.count > 0 and name.at (1).is_alpha
			id_not_in_use: not user_id_exists (id)
		local
			l_user: USER
		do
			create l_user.make (name, id, Current)
			users.force (l_user)
		end

	add_group (id: INTEGER_64; name: STRING)
		require
			id_positive: id > 0
			first_letter_alpha: name.count > 0 and name.at (1).is_alpha
			id_not_in_use: not group_id_exists (id)
		local
			l_group: GROUP
		do
			create l_group.make (name, id, Current)
			groups.force (l_group)
		end

	register_user (uid: INTEGER_64; gid: INTEGER_64)
		require
			uid > 0 and gid > 0
			user_id_exists (uid)
			group_id_exists (gid)
			not registration_exists (uid, gid)
		do
			across users as u
			loop
				if u.item.id = uid then
					across groups as g
					loop
						if g.item.id = gid then
							u.item.register (g.item)
							g.item.subscribe (u.item)
						end
					end
				end
			end
		end

	send_message (uid: INTEGER_64; gid: INTEGER_64; txt: STRING)
		require
			uid > 0 and gid > 0
			user_id_exists (uid)
			group_id_exists (gid)
			no_empty_message: not txt.is_empty
			authorization: registration_exists (uid, gid)
		local
			l_m: TUPLE[INTEGER_64, INTEGER_64, INTEGER_64, STRING]
		do
			l_m := [message_number, uid, gid, txt]
			across groups as g
			loop
				if g.item.id = gid then
					g.item.broadcast_message (txt)
				end
			end
			all_messages.force (l_m)
		end

feature -- queries

	user_id_exists (id: INTEGER_64): BOOLEAN
		do
			Result := across users as u some u.item.id = id end
		end

	group_id_exists (id: INTEGER_64): BOOLEAN
		do
			Result := across groups as g some g.item.id = id end
		end

	list_all_messages: STRING
		--lists all of the messages sent
		do
			create Result.make_empty
--			across all_messages as a
--			all
--				Result.append ("      ")
--				Result.append (a.item[1].out)
--				Result.append ("->[sender: ")
--				Result.append (a.item[2].out)
--				Result.append (", group: ")
--				Result.append (a.item[3].out)
--				Result.append (", content: %"")
--				Result.append (a.item[4].out)
--				Result.append ("...%"]")
--			end
		end

	list_users_by_id: STRING
		--lists the users in order of their id
		do
			sort_by_id := true
			users.sort
			create Result.make_empty
			from
				users.start
			until
				users.after
			loop
				Result.append ("      ")
				Result.append (users.item_for_iteration.out)
				Result.append ("%N")
				users.forth
			end
		end

	list_users: STRING
		--lists the users in order of their name
		do
			sort_by_id := false
			users.sort
			create Result.make_empty
			from
				users.start
			until
				users.after
			loop
				Result.append ("  ")
				Result.append (users.item_for_iteration.out)
				Result.append ("%N")
				users.forth
			end
		end

	list_groups_by_id: STRING
		--lists the groups in order of their id
		do
			sort_by_id := true
			groups.sort
			create Result.make_empty
			from
				groups.start
			until
				groups.after
			loop
				Result.append ("      ")
				Result.append (groups.item_for_iteration.out)
				Result.append ("%N")
				groups.forth
			end
		end

	list_groups: STRING
		--lists the users in order of their name
		do
			sort_by_id := false
			groups.sort
			create Result.make_empty
			from
				groups.start
			until
				groups.after
			loop
				Result.append ("  ")
				Result.append (groups.item_for_iteration.out)
				Result.append ("%N")
				groups.forth
			end
		end

	list_registrations: STRING
		do
			create Result.make_empty
			from
				users.start
			until
				users.after
			loop
				if users.item_for_iteration.number_of_groups /= 0 then
					Result.append ("      ")
					Result.append (users.item_for_iteration.list_registrations)
					Result.append ("%N")
				end
				users.forth
			end
		end

	registration_exists (uid: INTEGER_64; gid: INTEGER_64): BOOLEAN
		do
			across users as u
			loop
				if u.item.id = uid then
					Result := u.item.member_of (gid)
				end
			end
		end
end
