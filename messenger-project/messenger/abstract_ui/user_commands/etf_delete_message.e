note
	description: ""
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	ETF_DELETE_MESSAGE
inherit 
	ETF_DELETE_MESSAGE_INTERFACE
		redefine delete_message end
create
	make
feature -- command 
	delete_message(uid: INTEGER_64 ; mid: INTEGER_64)
		require else 
			delete_message_precond(uid, mid)
    	do
			-- perform some update on the model state
			model.default_update
			etf_cmd_container.on_change.notify ([Current])
    	end

end
