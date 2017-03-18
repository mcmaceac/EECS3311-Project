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
		end

feature --attributes
	name: STRING
	id: INTEGER_64
	messenger: MESSENGER
	groups: SORTED_TWO_WAY_LIST[GROUP]

feature --commands
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
