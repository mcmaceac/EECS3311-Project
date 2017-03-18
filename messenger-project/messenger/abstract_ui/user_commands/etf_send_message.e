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

			if uid <= 0 or gid <= 0 then
				model.e.make_from_string ("  ID must be a positive integer.%N")
			else if not model.m.user_id_exists (uid) then
				model.e.make_from_string ("  User with this ID does not exist.%N")
			else if not model.m.group_id_exists (gid) then
				model.e.make_from_string ("  Group with this ID does not exist.%N")
			else if txt.is_empty then
				model.e.make_from_string ("  A message may not be an empty string.%N")
			else if not model.m.registration_exists (uid, gid) then
				model.e.make_from_string ("  User not authorized to send messages to the specified group.%N")
			else
				model.m.send_message (uid, gid, txt)
			end
			end
			end
			end
			end


			etf_cmd_container.on_change.notify ([Current])
    	end

end
