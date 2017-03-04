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
			etf_cmd_container.on_change.notify ([Current])
    	end

end
