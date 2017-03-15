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
	sort_by_id: BOOLEAN

	num_users: INTEGER_64
		do
			Result := users.count
		end

	num_groups: INTEGER_64
		do
			Result := groups.count
		end

feature
	make
		do
			create users.make
			create groups.make
		end

feature -- commands

	add_user (id: INTEGER_64; name: STRING)
		require
			id_positive: id > 0
			first_letter_alpha: name.count > 0 and name.at (1).is_alpha
			id_not_in_use: not user_id_exists (id)
		local
			l_user: USER
		do
			create l_user.make (name, id, Current)
			users.force (l_user)
		end

	add_group (id: INTEGER_64; name: STRING)
		require
			id_positive: id > 0
			first_letter_alpha: name.count > 0 and name.at (1).is_alpha
			id_not_in_use: not group_id_exists (id)
		local
			l_group: GROUP
		do
			create l_group.make (name, id, Current)
			groups.force (l_group)
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
			sort_by_id := true
			users.sort
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

	list_users: STRING
		do
		--lists the users in order of their name
			sort_by_id := false --indicating we need to sort by name instead
			users.sort
			create Result.make_empty
			from
				users.start
			until
				users.after
			loop
				Result.append ("  ")
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
			sort_by_id := true
			groups.sort
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

	list_groups: STRING
		do
		--lists the groups in order of their name
			sort_by_id := false
			groups.sort
			create Result.make_empty
			from
				groups.start
			until
				groups.after
			loop
				Result.append ("  ")
				Result.append (groups.item_for_iteration.id.out)
				Result.append ("->")
				Result.append (groups.item_for_iteration.name)
				Result.append ("%N")
				groups.forth
			end
		end
end
