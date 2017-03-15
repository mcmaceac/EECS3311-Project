note
	description: "Summary description for {USER}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	USER
create make

feature --creation
	make (l_name: STRING; l_id: INTEGER_64)
		do
			name := l_name
			id := l_id
		end

feature --attributes
	name: STRING
	id: INTEGER_64

feature --queries


end
