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
	all_messages: LINKED_LIST[MESSAGE]

feature -- attributes

	message_to_read: STRING
	message_number: INTEGER_64
	message_length: INTEGER_64
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
			create message_to_read.make_empty
			create users.make
			create groups.make
			create all_messages.make
			message_number := 1
			message_length := 15
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

	delete_message (uid: INTEGER_64; mid: INTEGER_64)
		do
			across users as u
			loop
				if u.item.id = uid then
					u.item.delete_message (mid)
				end
			end
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

	read_message (uid: INTEGER_64; mid: INTEGER_64)
		do
			across users as u
			loop
				if u.item.id = uid then
					u.item.read_message (mid)
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
			l_m: MESSAGE
		do
			create l_m.make (message_number, uid, gid, txt, Current)
			message_number := message_number + 1
			across groups as g
			loop
				if g.item.id = gid then
					g.item.broadcast_message (l_m)
				end
			end
			all_messages.force (l_m)
		end

	set_message_preview (length: INTEGER_64)
		--sets the preview length of all messages in the messenger to length
		do
			message_length := length
		end

feature -- queries

	user_authorized_to_access_message (uid: INTEGER_64; mid: INTEGER_64): BOOLEAN
		do
			across users as u
			loop
				if u.item.id = uid then
					Result := u.item.authorized_to_access_message (mid)
				end
			end
		end

	user_id_exists (id: INTEGER_64): BOOLEAN
		do
			Result := across users as u some u.item.id = id end
		end

	user_no_new_message (id: INTEGER_64): BOOLEAN
		do
			across users as u
			loop
				if u.item.id = id then
					Result := u.item.new_messages.count = 0
				end
			end
		end

	user_no_old_message (id: INTEGER_64): BOOLEAN
		do
			across users as u
			loop
				if u.item.id = id then
					Result := u.item.old_messages.count = 0
				end
			end
		end

	group_id_exists (id: INTEGER_64): BOOLEAN
		do
			Result := across groups as g some g.item.id = id end
		end

	message_id_exists (id: INTEGER_64): BOOLEAN
		do
			Result := across all_messages as am some am.item.number = id end
		end

	list_all_messages: STRING
		--lists all of the messages sent
		do
			create Result.make_empty
			across all_messages as am
			loop
				Result.append ("      ")
				Result.append (am.item.out)
			end
		end

	list_new_messages (uid: INTEGER_64): STRING
		do
			create Result.make_empty
			across users as u
			loop
				if u.item.id = uid then
					Result := u.item.list_new_messages
				end
			end
		end

	list_old_messages (uid: INTEGER_64): STRING
		do
			create Result.make_empty
			across users as u
			loop
				if u.item.id = uid then
					Result := u.item.list_old_messages
				end
			end
		end

	message_status: STRING
		--lists the message status for each message and each user
		do
			create Result.make_empty
			across all_messages as am
			loop
				across users as u
				loop
					if u.item.registered then
						Result.append ("      (")
						Result.append (u.item.id.out)
						Result.append (", ")
						Result.append (am.item.number.out)

						if u.item.id = am.item.sender or
						   u.item.message_status.at (am.item.number) then
							Result.append (")->read%N")
						else if not registration_exists (u.item.id, am.item.group) then
							Result.append (")->unavailable%N")
						else
							Result.append (")->unread%N")
						end
						end
					end
				end
			end
		end

	message_read (uid: INTEGER_64; mid: INTEGER_64): BOOLEAN
		do
			across users as u
			loop
				if u.item.id = uid then
					Result := u.item.message_status.at (mid)
				end
			end
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

	old_message_exists (uid: INTEGER_64; mid: INTEGER_64): BOOLEAN
		do
			across users as u
			loop
				if u.item.id = uid then
					across u.item.old_messages as om
					loop
						if om.item.number = mid then
							Result := true
						end
					end
				end
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
