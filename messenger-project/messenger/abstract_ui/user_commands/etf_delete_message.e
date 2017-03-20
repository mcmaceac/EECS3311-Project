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

			if uid <= 0 or mid <= 0 then
				model.e.make_from_string ("  ID must be a positive integer.%N")
			else if not model.m.user_id_exists (uid) then
				model.e.make_from_string ("  User with this ID does not exist.%N")
			else if not model.m.message_id_exists (mid) then
				model.e.make_from_string ("  Message with this ID does not exist.%N")
			--else if model.m.old_messages (uid, mid)  then
			--	model.e.make_from_string ("  Message with this ID not found in old/read messages.")
			else
				model.m.delete_message (uid, mid)
			--end
			end
			end
			end
			etf_cmd_container.on_change.notify ([Current])
    	end

end
