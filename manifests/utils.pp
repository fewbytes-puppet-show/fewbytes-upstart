class upstart::utils {
	file{"/usr/local/sbin/chpst.py": 
		source => "puppet:///modules/upstart/chpst.py",
		mode => 755
	}
}