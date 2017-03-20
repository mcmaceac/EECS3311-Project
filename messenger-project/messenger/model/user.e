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
	message_status: HASH_TABLE[BOOLEAN, INTEGER] --message id to read status for this user

	registered: BOOLEAN
		do
			Result := not groups.is_empty
		end

feature --commands
	add_message (m: MESSAGE)
		do
			messages.force (m)
			if m.sender = id then --this user sent this message
				message_status.force (true, m.number.as_integer_32)
			else
				message_status.force (false, m.number.as_integer_32)
			end
		end

	register (g: GROUP) --register this user to group g
		do
			groups.force (g)
		end

feature --queries
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
			across messages as m
			loop
				if not message_status.at (m.item.number.as_integer_32) then
					Result.append ("      ")
					Result.append (m.item.out)
				end
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
