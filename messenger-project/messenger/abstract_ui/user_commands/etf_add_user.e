note
	description: ""
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	ETF_ADD_USER
inherit
	ETF_ADD_USER_INTERFACE
		redefine add_user end
create
	make
feature -- command
	add_user(uid: INTEGER_64 ; user_name: STRING)
		require else
			add_user_precond(uid, user_name)
    	do
			-- perform some update on the model state
			model.default_update

			if uid <= 0 then
				model.e.make_from_string ("  ID must be a positive integer.%N")
			else if model.m.user_id_exists (uid) then
				model.e.make_from_string ("  ID already in use.%N")
			else if user_name.count = 0 or not (user_name.at (1).is_alpha) then
				model.e.make_from_string ("  User name must start with a letter.%N")
			else
				model.m.add_user (uid, user_name)
			end
			end
			end
			--end

			etf_cmd_container.on_change.notify ([Current])
    	end

end
