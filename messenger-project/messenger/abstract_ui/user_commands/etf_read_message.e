note
	description: ""
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	ETF_READ_MESSAGE
inherit 
	ETF_READ_MESSAGE_INTERFACE
		redefine read_message end
create
	make
feature -- command 
	read_message(uid: INTEGER_64 ; mid: INTEGER_64)
		require else 
			read_message_precond(uid, mid)
    	do
			-- perform some update on the model state
			model.default_update
			etf_cmd_container.on_change.notify ([Current])
    	end

end
