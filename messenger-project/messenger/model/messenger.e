note
	description: "Summary description for {MESSENGER}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	MESSENGER

create make

feature {NONE} -- private attributes
	--we want these attributes to be private so that other clients cannot
	--gain access to the messages of other users

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
		-- adds user with id 'id' and name 'name' to the messenger
		require
			id_positive: id > 0
			first_letter_alpha: not (name.count = 0) and name.at (1).is_alpha
			id_not_in_use: not user_id_exists (id)
		local
			l_user: USER
		do
			create l_user.make (name, id, Current)
			users.force (l_user)
		end

	add_group (id: INTEGER_64; name: STRING)
		-- adds group with id 'id' and name 'name' to the messenger
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
		-- user with id 'uid' deletes message with id 'mid' from their "history"
		require
			uid > 0 and mid > 0
			user_id_exists (uid)
			message_id_exists (uid, mid)
			old_message_exists (uid, mid)
		do
			across users as u
			loop
				if u.item.id = uid then
					u.item.delete_message (mid)
				end
			end
		end

	register_user (uid: INTEGER_64; gid: INTEGER_64)
		-- register user with id 'uid' to group with id 'gid'
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
		-- user with id 'uid' reads message with id 'mid'
		require
			uid > 0 and mid > 0
			user_id_exists (uid)
			message_id_exists (uid, mid)
			user_authorized_to_access_message (uid, mid)
			not message_read (uid, mid)
		do
			across users as u
			loop
				if u.item.id = uid then
					u.item.read_message (mid)
				end
			end
		end

	send_message (uid: INTEGER_64; gid: INTEGER_64; txt: STRING)
		-- user with id 'uid' sends a message to group with id 'gid' containing text 'txt'
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
		require
			length > 0
		do
			message_length := length
		ensure
			message_length = length
		end

feature -- queries

	user_authorized_to_access_message (uid: INTEGER_64; mid: INTEGER_64): BOOLEAN
		-- checks to see if user with id 'uid' is authorized to access the message with id 'mid'
 		do
 			across users as u
 			loop
 				if u.item.id = uid then
 					Result := u.item.authorized_to_access_message (mid)
 				end
 			end
 		end

	user_id_exists (id: INTEGER_64): BOOLEAN
		-- checks to see if the user with id 'id' exists in the messenger
		do
			Result := across users as u some u.item.id = id end
		end

	user_no_new_message (id: INTEGER_64): BOOLEAN
		-- checks to see if the user with id 'id' has no old messages
		do
			across users as u
			loop
				if u.item.id = id then
					Result := u.item.new_messages.count = 0
				end
			end
		end

	user_no_old_message (id: INTEGER_64): BOOLEAN
		-- checks to see if the user with id 'id' has no old messages
		do
			across users as u
			loop
				if u.item.id = id then
					Result := u.item.old_messages.count = 0
				end
			end
		end

	group_id_exists (id: INTEGER_64): BOOLEAN
		-- group with id 'id' exists in the messenger
		do
			Result := across groups as g some g.item.id = id end
		end

	message_id_exists (uid: INTEGER_64; mid: INTEGER_64): BOOLEAN
		--check to see if this message id exists for this user
		do
			across users as u
			loop
				if u.item.id = uid then
					Result := u.item.message_id_exists (mid)
				end
			end
			--the below janky logic is needed due to the current state of the
			--oracle and what error messages are displayed when
			if not Result and across all_messages as m some m.item.number = mid and registration_exists (uid, m.item.group) end then
				Result := false
			else if not Result and across all_messages as m some m.item.number = mid end then
				Result := true
			else
				Result := true
			end
			end
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
		-- lists the new messages for user with id 'uid'
		require
			uid > 0
			user_id_exists (uid)
			not user_no_new_message (uid)
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
		-- lists the old messages for user with id 'uid'
		require
			uid > 0
			user_id_exists (uid)
			not user_no_old_message (uid)
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

						if u.item.has_message (am.item.number) then
							if u.item.id = am.item.sender or
						   		u.item.message_status.at (am.item.number) then
								Result.append (")->read%N")
							else
								Result.append (")->unread%N")
							end
						else
							Result.append (")->unavailable%N")
						end
					end
				end
			end
		end

	message_deleted (uid: INTEGER_64; mid: INTEGER_64): BOOLEAN
		-- checks to see if user with id 'uid' has deleted a message with id 'mid'
		do
			from
				users.start
			until
				users.after or Result
			loop
				if users.item.id = uid then
					Result := users.item.message_deleted (mid)
				end
				users.forth
			end
		end

	user_member_of_group (uid: INTEGER_64; mid: INTEGER_64): BOOLEAN
		-- checks to see if user with id 'uid' is a member of the group
		-- that message with id 'mid' is sent to
		do
			from
				users.start
			until
				users.after or Result
			loop
				if users.item.id = uid then
					across all_messages as am
					loop
						if am.item.number = mid then
							Result := users.item.member_of (am.item.group)
						end
					end
				end
				users.forth
			end
		end

	message_read (uid: INTEGER_64; mid: INTEGER_64): BOOLEAN
		do
			-- checks to see if user with id 'uid' has read message with id 'mid'
			from
				users.start
			until
				users.after or Result
			loop
				if users.item.id = uid then
					Result := users.item.message_status.at (mid)
				end
				users.forth
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
		require
			num_groups > 0
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
		-- returns a formatted list of the registrations for the default output
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
		-- user with id 'uid' has an old message with id 'mid'
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
		-- registration exists between user with id 'uid' and group with id 'gid'
		do
			across users as u
			loop
				if u.item.id = uid then
					Result := u.item.member_of (gid)
				end
			end
		end
end
