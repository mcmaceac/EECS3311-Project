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

			if gid <= 0 then
				model.e.make_from_string ("  ID must be a positive integer.")
--			else if across model.m.groups.current_keys as ck some ck.item = gid end then
--				model.e.make_from_string ("  ID already in use.")
			else if model.m.group_id_exists (gid) then
				model.e.make_from_string ("  ID already in use.")
			else if group_name.count > 0 and not group_name.at (1).is_alpha then
				model.e.make_from_string ("  Group name must start with a letter.")
			else
				model.m.add_group (gid, group_name)
			end
			end
			end
			--end

			etf_cmd_container.on_change.notify ([Current])
    	end

end
