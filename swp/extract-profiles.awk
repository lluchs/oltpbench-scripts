#!/usr/bin/awk -f

/start swp/ {
	type = $5;
	i = 1;
}

/^\w.+ -> \w/ {
	if (!in_profile) {
		in_profile = 1;
		file = type sprintf("%02d", i++) ".txt";
	}
	print > file
	next
}

/^\t\w/ && in_profile {
	print > file
	next
}

{ in_profile = 0 }
