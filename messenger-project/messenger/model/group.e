note
	description: "Summary description for {GROUP}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	GROUP
inherit
	COMPARABLE

create make

feature --creation
	make (l_name: STRING; l_id: INTEGER_64; l_m: MESSENGER)
		do
			name := l_name
			id := l_id
			messenger := l_m
		end

feature --attributes
	name: STRING
	id: INTEGER_64
	messenger: MESSENGER

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
