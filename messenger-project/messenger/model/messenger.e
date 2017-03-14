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

	groups: HASH_TABLE[STRING, INTEGER_64]

	num_users: INTEGER_64
		do
			Result := users.count
		end

feature
	make
		do
			create users.make (0)
			create groups.make (0)
		end

feature -- commands

	add_user (id: INTEGER_64; name: STRING)
		require
			id_positive: id > 0
			first_letter_alpha: name.count > 0 and name.at (1).is_alpha
			id_not_in_use: across users.current_keys as ck all ck.item /= id end
		do
			users.force (name, id)
		end

	add_group (id: INTEGER_64; name: STRING)
		require
			id_positive: id > 0
			first_letter_alpha: name.count > 0 and name.at (1).is_alpha
			id_not_in_use: across groups.current_keys as ck all ck.item /= id end
		do
			groups.force (name, id)
		end

feature -- queries

	list_users (indent: STRING; order: BOOLEAN): STRING
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
				users.forth
			end
		end

	list_groups (indent: STRING; order: BOOLEAN): STRING
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
				groups.forth
			end
		end


end
