note
	description: "Summary description for {MESSENGER}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	MESSENGER

create make

feature -- attributes

	users: SORTED_TWO_WAY_LIST[USER]
	groups: SORTED_TWO_WAY_LIST[GROUP]

	--users: HASH_TABLE[STRING, INTEGER_64]
	--user_key_order: SORTED_TWO_WAY_LIST[INTEGER_64]

	--groups: HASH_TABLE[STRING, INTEGER_64]
	--group_key_order: SORTED_TWO_WAY_LIST[INTEGER_64]

	num_users: INTEGER_64
		do
			Result := users.count
		end

feature
	make
		do
			create users.make
			--create user_key_order.make
			create groups.make
			--create group_key_order.make
		end

feature -- commands

	add_user (id: INTEGER_64; name: STRING)
		require
			id_positive: id > 0
			first_letter_alpha: name.count > 0 and name.at (1).is_alpha
			--id_not_in_use: across users.current_keys as ck all ck.item /= id end
			id_not_in_use: not user_id_exists (id)
		local
			l_user: USER
		do
			create l_user.make (name, id)
			users.force (l_user)
			--user_key_order.extend (id)
		end

	add_group (id: INTEGER_64; name: STRING)
		require
			id_positive: id > 0
			first_letter_alpha: name.count > 0 and name.at (1).is_alpha
			--id_not_in_use: across groups.current_keys as ck all ck.item /= id end
			id_not_in_use: not group_id_exists (id)
		local
			l_group: GROUP
		do
			create l_group.make (name, id)
			groups.force (l_group)
			--group_key_order.extend (id)
		end

feature -- queries

	user_id_exists (id: INTEGER_64): BOOLEAN
		do
			Result := across users as u some u.item.id = id end
		end

	group_id_exists (id: INTEGER_64): BOOLEAN
		do
			Result := across groups as g some g.item.id = id end
		end

	list_users_by_id: STRING
		--lists the users in order of their id
		do
			create Result.make_empty
			from
				users.start
			until
				users.after
			loop
				Result.append ("      ")
				Result.append (users.item_for_iteration.id.out)
				Result.append ("->")
				Result.append (users.item_for_iteration.name)
				Result.append ("%N")
				users.forth
			end
		end

	list_groups_by_id: STRING
		--lists the groups in order of their id
		do
			create Result.make_empty
			from
				groups.start
			until
				groups.after
			loop
				Result.append ("      ")
				Result.append (groups.item_for_iteration.id.out)
				Result.append ("->")
				Result.append (groups.item_for_iteration.name)
				Result.append ("%N")
				groups.forth
			end
		end
end
