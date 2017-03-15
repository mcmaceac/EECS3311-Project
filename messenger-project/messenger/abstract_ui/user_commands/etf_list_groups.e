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

			if model.m.num_groups = 0 then
				model.message.make_from_string ("  There are no groups registered in the system yet.%N")
			else
				model.message.make_from_string (model.m.list_groups_by_id)
			end
			etf_cmd_container.on_change.notify ([Current])
    	end

end
