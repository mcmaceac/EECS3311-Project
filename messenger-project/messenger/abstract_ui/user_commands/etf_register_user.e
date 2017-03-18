note
	description: ""
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	ETF_REGISTER_USER
inherit
	ETF_REGISTER_USER_INTERFACE
		redefine register_user end
create
	make
feature -- command
	register_user(uid: INTEGER_64 ; gid: INTEGER_64)
		require else
			register_user_precond(uid, gid)
    	do 
			-- perform some update on the model state
			model.default_update

			if uid <= 0 or gid <= 0 then
				model.e.make_from_string ("  ID must be a positive integer.%N")
			else if not model.m.user_id_exists (uid) then
				model.e.make_from_string ("  User with this ID does not exist.%N")
			else if not model.m.group_id_exists (gid) then
				model.e.make_from_string ("  Group with this ID does not exist.%N")
			else if model.m.registration_exists (uid, gid) then
				model.e.make_from_string ("  This registration already exists.%N")
			else
				model.m.register_user (uid, gid)
			end
			end
			end
			end

			etf_cmd_container.on_change.notify ([Current])
    	end

end
