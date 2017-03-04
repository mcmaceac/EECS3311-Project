note
	description: ""
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	ETF_SET_MESSAGE_PREVIEW
inherit 
	ETF_SET_MESSAGE_PREVIEW_INTERFACE
		redefine set_message_preview end
create
	make
feature -- command 
	set_message_preview(n: INTEGER_64)
    	do
			-- perform some update on the model state
			model.default_update
			etf_cmd_container.on_change.notify ([Current])
    	end

end
