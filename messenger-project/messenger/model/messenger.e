note
	description: "Summary description for {MESSENGER}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	MESSENGER

create make

feature -- attributes

	users: HASH_TABLE[STRING, INTEGER_64]
	user_key_order: SORTED_TWO_WAY_LIST[INTEGER_64]

	groups: HASH_TABLE[STRING, INTEGER_64]
	group_key_order: SORTED_TWO_WAY_LIST[INTEGER_64]

	num_users: INTEGER_64
		do
			Result := users.count
		end

feature
	make
		do
			create users.make (0)
			create user_key_order.make
			create groups.make (0)
			create group_key_order.make
		end

feature -- commands

	add_user (id: INTEGER_64; name: STRING)
		require
			id_positive: id > 0
			first_letter_alpha: name.count > 0 and name.at (1).is_alpha
			id_not_in_use: across users.current_keys as ck all ck.item /= id end
		do
			users.force (name, id)
			user_key_order.extend (id)
		end

	add_group (id: INTEGER_64; name: STRING)
		require
			id_positive: id > 0
			first_letter_alpha: name.count > 0 and name.at (1).is_alpha
			id_not_in_use: across groups.current_keys as ck all ck.item /= id end
		do
			groups.force (name, id)
			group_key_order.extend (id)
		end

feature -- queries

	list_users (indent: STRING): STRING
		--if order is set to true, then we are calling from etf_list_users,
		--in which case we should order by name. Otherwise we order by ID
		do
			create Result.make_empty
			from
				users.start
			until
				users.after
			loop
				Result.append (indent)
				Result.append (users.key_for_iteration.out)
				Result.append ("->")
				Result.append (users.item_for_iteration.out)
				Result.append ("%N")
				users.forth
			end
		end

	list_users_by_id (indent: STRING): STRING
		do
			create Result.make_empty
			from
				user_key_order.start
			until
				user_key_order.after
			loop
				Result.append (indent)
				Result.append (user_key_order.item_for_iteration.out)
				Result.append ("->")
				if attached users.at (user_key_order.item_for_iteration) as u then
					Result.append (u.out)
				end
				Result.append ("%N")
				user_key_order.forth
			end
		end

	list_groups (indent: STRING): STRING
		--if order is set to true, then we are calling from etf_list_users,
		--in which case we should order by name. Otherwise we order by ID
		do
			create Result.make_empty
			from
				groups.start
			until
				groups.after
			loop
				Result.append (indent)
				Result.append (groups.key_for_iteration.out)
				Result.append ("->")
				Result.append (groups.item_for_iteration.out)
				Result.append ("%N")
				groups.forth
			end
		end

	list_groups_by_id (indent: STRING): STRING
		do
			create Result.make_empty
			from
				group_key_order.start
			until
				group_key_order.after
			loop
				Result.append (indent)
				Result.append (group_key_order.item_for_iteration.out)
				Result.append ("->")
				if attached users.at (group_key_order.item_for_iteration) as g then
					Result.append (g.out)
				end
				Result.append ("%N")
				group_key_order.forth
			end
		end


end
