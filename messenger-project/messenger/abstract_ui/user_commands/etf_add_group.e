note
	description: ""
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	ETF_ADD_GROUP
inherit 
	ETF_ADD_GROUP_INTERFACE
		redefine add_group end
create
	make
feature -- command 
	add_group(gid: INTEGER_64 ; group_name: STRING)
		require else 
			add_group_precond(gid, group_name)
    	do
			-- perform some update on the model state
			model.default_update
			etf_cmd_container.on_change.notify ([Current])
    	end

end
