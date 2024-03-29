note
	description: ""
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	ETF_LIST_USERS
inherit
	ETF_LIST_USERS_INTERFACE
		redefine list_users end
create
	make
feature -- command
	list_users
    	do
			-- perform some update on the model state
			model.default_update

			if model.m.num_users = 0 then
				model.message.make_from_string ("  There are no users registered in the system yet.%N")
			else
				model.message.make_from_string (model.m.list_users)
			end
			etf_cmd_container.on_change.notify ([Current])
    	end

end
