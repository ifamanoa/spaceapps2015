riskprop.des:
	oorb --conf=oorb.nbody.conf --task=propagation --orb-in=risk.des --orb-out=riskprop.des --epoch-mjd-utc=57000

risk.des:
	getorb.pl < ast.des > risk.des
