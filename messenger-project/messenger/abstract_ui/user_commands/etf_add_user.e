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
			etf_cmd_container.on_change.notify ([Current])
    	end

end
