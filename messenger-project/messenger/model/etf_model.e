note
	description: "A default business model."
	author: "Jackie Wang"
	date: "$Date$"
	revision: "$Revision$"

class
	ETF_MODEL

inherit
	ANY
		redefine
			out
		end

create {ETF_MODEL_ACCESS}
	make

feature {NONE} -- Initialization
	make
			-- Initialization for `Current'.
		do
			i := 0
			create m.make
			create e.make_empty
			create message.make_empty
		end

feature -- model attributes
	i : INTEGER
	m : MESSENGER
	e : STRING			-- error message
	message : STRING			-- warning message

feature -- model operations
	default_update
			-- Perform update to the model state.
		do
			i := i + 1
		end

	reset
			-- Reset model state.
		do
			make
		end

feature -- queries
	out : STRING
		do
			create Result.make_from_string ("  ")
			if m.num_users = 0 and e.count = 0 and message.count = 0 then		--start
				Result.append (i.out)
				Result.append (":  OK%N")
			else if e.count > 0 then
				Result.append (i.out)
				Result.append (":  ERROR %N")
				Result.append (e)
				e.wipe_out						--clearing the error
			else if message.count > 0 then
				Result.append (i.out)
				Result.append (":  OK%N")
				Result.append (message)
				message.wipe_out				--clearing the message
			else
				Result.append (i.out)
				Result.append (":  OK%N")
				Result.append ("  Users:%N")
				Result.append (m.list_users_by_id)
				Result.append ("  Groups:%N")
				Result.append (m.list_groups_by_id)
				Result.append ("  Registrations:%N")
				Result.append (m.list_registrations)
				Result.append ("  All messages:%N")
				Result.append (m.list_all_messages)
				Result.append ("  Message state:%N")
				Result.append (m.message_status)
			end
			end
			end
		end

end




