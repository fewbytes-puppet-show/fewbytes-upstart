#! /usr/bin/env python

import argparse, sys, os
import pwd, grp

parser = argparse.ArgumentParser("chpst.py")
parser.add_argument("-u", default=None, dest="user", help="user to run command as")
parser.add_argument("-g", default=None, dest="group", help="group to run command as")
parser.add_argument("executable", nargs=1, help="Command executable")
parser.add_argument('command_args', nargs='*', help="Command arguments")
opts = parser.parse_args()

if opts.group:
	gid = grp.getgrnam(opts.group).gr_gid
	os.setregid(gid, gid)

if opts.user:
	uid = pwd.getpwnam(opts.user).pw_uid
	os.setresuid(uid, uid, uid)

os.execvp(opts.executable[0], opts.command_args)