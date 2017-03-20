note
	description: "Summary description for {MESSAGE}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	MESSAGE

inherit
	COMPARABLE
		redefine
			out
		end

create make

feature	--creation
	make (num: INTEGER_64; s: INTEGER_64; g: INTEGER_64; c: STRING; m: MESSENGER)
		do
			number := num
			sender := s
			group := g
			content := c
			messenger := m
		end

feature --attributes
	number: INTEGER_64
	sender: INTEGER_64
	group: INTEGER_64
	content: STRING
	messenger: MESSENGER

feature --queries
	is_less alias "<" (other: like Current): BOOLEAN
		do
			Result := number < other.number
		end

	out: STRING
		do
			create Result.make_empty
			Result.append (number.out)
			Result.append ("->[sender: ")
			Result.append (sender.out)
			Result.append (", group: ")
			Result.append (group.out)
			Result.append (", content: %"")
			if content.count <= messenger.message_length then
				Result.append (content)
			else
				Result.append (content.substring (1, messenger.message_length.as_integer_32))
				Result.append ("...")
			end
			Result.append ("%"]%N")
		end
end
