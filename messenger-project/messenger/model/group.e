note
	description: "Summary description for {GROUP}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	GROUP
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
			create subscribers.make
		end

feature --attributes
	name: STRING
	id: INTEGER_64
	messenger: MESSENGER
	subscribers: LINKED_LIST[USER]

feature --queries
	out: STRING
		do
			create Result.make_empty
			Result.append (id.out)
			Result.append ("->")
			Result.append (name)
		end

feature --commands
	subscribe (u: USER)
	--subscribe user u to this group
		do
			subscribers.force (u)
		end

	broadcast_message (m: MESSAGE)
	--broadcast a message sent to this group to all of the subscribers	
		do
			across subscribers as s
			loop
				s.item.add_message (m)
			end
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
