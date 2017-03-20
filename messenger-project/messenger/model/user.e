note
	description: "Summary description for {USER}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	USER
inherit
	COMPARABLE
		redefine
			out
		end

create make

feature --creation
	make (l_name: STRING; l_id: INTEGER_64; l_m: MESSENGER)
		do
			name := l_name
			id := l_id
			messenger := l_m
			create groups.make
			create messages.make
			create message_status.make (0)
		end

feature --attributes
	name: STRING
	id: INTEGER_64
	messenger: MESSENGER
	groups: SORTED_TWO_WAY_LIST[GROUP]
	messages: SORTED_TWO_WAY_LIST[MESSAGE]
	message_status: HASH_TABLE[BOOLEAN, INTEGER_64] --message id to read status for this user

	old_messages: SORTED_TWO_WAY_LIST[MESSAGE]
		do
			create Result.make
			across messages as m
			loop
				if message_status.at (m.item.number) then
					Result.force (m.item)
				end
			end
		end

	new_messages: SORTED_TWO_WAY_LIST[MESSAGE]
		do
			create Result.make
			across messages as m
			loop
				if not message_status.at (m.item.number) then
					Result.force (m.item)
				end
			end
		end

	registered: BOOLEAN
		do
			Result := not groups.is_empty
		end

feature --commands
	add_message (m: MESSAGE)
		do
			messages.force (m)
			if m.sender = id then --this user sent this message
				message_status.force (true, m.number)			--true means the message has been read 1
			else
				message_status.force (false, m.number)			--false means the message has not been read
			end
		end

	delete_message (mid: INTEGER_64)
		do

		end

	read_message (mid: INTEGER_64)
		do
			message_status.force (true, mid) --changing the message_status to read
			across messages as m
			loop
				if m.item.number = mid then
					messenger.message_to_read.make_empty
					messenger.message_to_read.append ("  Message for user [")
					messenger.message_to_read.append (id.out)
					messenger.message_to_read.append (", ")
					messenger.message_to_read.append (name)
					messenger.message_to_read.append ("]: [")
					messenger.message_to_read.append (mid.out)
					messenger.message_to_read.append (", %"")
					messenger.message_to_read.append (m.item.content)
					messenger.message_to_read.append ("%"]%N")
				end
			end
		end

	register (g: GROUP) --register this user to group g
		do
			groups.force (g)
		end

feature --queries

	authorized_to_access_message (mid: INTEGER_64): BOOLEAN
		do
			Result := across messages as m some m.item.number = mid end
		end

	no_new_message: BOOLEAN
		do
			Result := new_messages.count = 0
		end

	no_old_message: BOOLEAN
		do
			Result := old_messages.count = 0
		end

	out: STRING
		do
			create Result.make_empty
			Result.append (id.out)
			Result.append ("->")
			Result.append (name)
		end

	list_new_messages: STRING
		do
			create Result.make_empty
			Result.append ("  New/unread messages for user [")
			Result.append (id.out)
			Result.append (", ")
			Result.append (name)
			Result.append ("]:%N")
			across new_messages as m
			loop
				Result.append ("      ")
				Result.append (m.item.out)
			end
		end

	list_old_messages: STRING
		do
			create Result.make_empty
			Result.append ("  Old/read messages for user [")
			Result.append (id.out)
			Result.append (", ")
			Result.append (name)
			Result.append ("]:%N")
			across old_messages as m
			loop
				Result.append ("      ")
				Result.append (m.item.out)
			end
		end

	list_registrations: STRING
		do
			create Result.make_empty
			Result.append ("[")
			Result.append (id.out)
			Result.append (", ")
			Result.append (name)
			Result.append ("]->{")
			from
				groups.start
			until
				groups.after
			loop
				Result.append (groups.item_for_iteration.out)
				groups.forth
				if groups.after then		--end of group list
					Result.append ("}")
				else						--not end yet, comma sep
					Result.append (", ")
				end
			end
		end

	number_of_groups: INTEGER_64
		--number of groups this user is a part of
		do
			Result := groups.count
		end

	member_of (gid: INTEGER_64): BOOLEAN
		--is this user a member of group with id gid?
		do
			Result := across groups as g some g.item.id = gid end
		end

	message_read (mid: INTEGER_64): BOOLEAN
		do
			Result := message_status.at (mid)
		end

feature --comparable
	is_less alias "<" (other: like Current): BOOLEAN
		do
			if messenger.sort_by_id then		--flag to see what we are comparing by
				Result := id < other.id
			else
				Result := name < other.name
			end
		end

end
