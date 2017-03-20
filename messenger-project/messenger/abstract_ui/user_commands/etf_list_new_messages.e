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

			if uid <= 0 then
				model.e.make_from_string ("  ID must be a positive integer.%N")
			else if not model.m.user_id_exists (uid) then
				model.e.make_from_string ("  User with this ID does not exist.%N")
			else if model.m.user_no_new_message (uid) then
				model.message.make_from_string ("  There are no new messages for this user.%N")
			else
				model.message.make_from_string (model.m.list_new_messages (uid))
			end
			end
			end
			etf_cmd_container.on_change.notify ([Current])
    	end

end
