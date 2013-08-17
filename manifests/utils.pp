class upstart::utils {
	file{"/usr/local/sbin/chpst.py": 
		source => "puppet:///upstart/chpst.py",
		mode => 755
	}
}