note
	description: ""
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	ETF_LIST_OLD_MESSAGES
inherit 
	ETF_LIST_OLD_MESSAGES_INTERFACE
		redefine list_old_messages end
create
	make
feature -- command 
	list_old_messages(uid: INTEGER_64)
		require else 
			list_old_messages_precond(uid)
    	do
			-- perform some update on the model state
			model.default_update
			etf_cmd_container.on_change.notify ([Current])
    	end

end
