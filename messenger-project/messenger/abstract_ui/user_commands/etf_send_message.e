note
	description: ""
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	ETF_SEND_MESSAGE
inherit 
	ETF_SEND_MESSAGE_INTERFACE
		redefine send_message end
create
	make
feature -- command 
	send_message(uid: INTEGER_64 ; gid: INTEGER_64 ; txt: STRING)
		require else 
			send_message_precond(uid, gid, txt)
    	do
			-- perform some update on the model state
			model.default_update
			etf_cmd_container.on_change.notify ([Current])
    	end

end
