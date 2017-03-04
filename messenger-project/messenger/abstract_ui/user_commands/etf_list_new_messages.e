note
	description: ""
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	ETF_LIST_NEW_MESSAGES
inherit 
	ETF_LIST_NEW_MESSAGES_INTERFACE
		redefine list_new_messages end
create
	make
feature -- command 
	list_new_messages(uid: INTEGER_64)
		require else 
			list_new_messages_precond(uid)
    	do
			-- perform some update on the model state
			model.default_update
			etf_cmd_container.on_change.notify ([Current])
    	end

end
