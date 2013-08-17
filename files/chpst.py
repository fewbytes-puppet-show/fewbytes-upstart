#! /usr/bin/env python

import optparse, sys, os
import pwd, grp

parser = optparse.OptionParser()
parser.add_option("-u", default=None, dest="user", help="user to run command as")
parser.add_option("-g", default=None, dest="group", help="group to run command as")
(opts, args) = parser.parse_args()

if opts.group:
	gid = grp.getgrnam(opts.group).gr_gid
	os.setregid(gid, gid)

if opts.user:
	uid = pwd.getpwnam(opts.user).pw_uid
	os.setresuid(uid, uid, uid)

os.execvp(args[0], args)
