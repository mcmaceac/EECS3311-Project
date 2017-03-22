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

			if uid <= 0 or mid <= 0 then
				model.e.make_from_string ("  ID must be a positive integer.%N")
			else if not model.m.user_id_exists (uid) then
				model.e.make_from_string ("  User with this ID does not exist.%N")
			else if not model.m.message_id_exists (uid, mid) then
				model.e.make_from_string ("  Message with this ID does not exist.%N")
			else if not model.m.user_authorized_to_access_message (uid, mid) then
				model.e.make_from_string ("  User not authorized to access this message.%N")
			else if model.m.message_read (uid, mid) then
				model.e.make_from_string ("  Message has already been read. See `list_old_messages'.%N")
			else
				model.m.read_message (uid, mid)
			end
			end
			end
			end
			end
			etf_cmd_container.on_change.notify ([Current])
    	end

end
