note
	description: ""
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	ETF_LIST_GROUPS
inherit 
	ETF_LIST_GROUPS_INTERFACE
		redefine list_groups end
create
	make
feature -- command 
	list_groups
    	do
			-- perform some update on the model state
			model.default_update
			etf_cmd_container.on_change.notify ([Current])
    	end

end
