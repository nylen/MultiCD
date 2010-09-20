#!/bin/sh
set -e
#Windows 7 Recovery Disc plugin for multicd.sh
#version 5.8
#Copyright for this script (c) 2010 maybeway36
#
#Permission is hereby granted, free of charge, to any person obtaining a copy
#of this software and associated documentation files (the "Software"), to deal
#in the Software without restriction, including without limitation the rights
#to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
#copies of the Software, and to permit persons to whom the Software is
#furnished to do so, subject to the following conditions:
#
#The above copyright notice and this permission notice shall be included in
#all copies or substantial portions of the Software.
#
#THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
#IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
#FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
#AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
#LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
#OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
#THE SOFTWARE.
if [ $1 = scan ];then
	if [ -f win7recovery.iso ];then
		echo "Windows 7 Recovery Disc (Not open source - do not distribute)"
	fi
elif [ $1 = copy ];then
	if [ -f win7recovery.iso ];then
		echo "Copying Windows 7 Recovery Disc..."
		if [ ! -d win7recovery ];then
			mkdir win7recovery
		fi
		if grep -q "`pwd`/win7recovery" /etc/mtab ; then
			umount win7recovery
		fi
		mount -o loop win7recovery.iso win7recovery/
		cp win7recovery/boot/* multicd-working/boot/
		cp -r win7recovery/sources multicd-working/
		cp win7recovery/bootmgr multicd-working/
		umount win7recovery;rmdir win7recovery
	fi
elif [ $1 = writecfg ];then
if [ -f win7recovery.iso ];then
echo "label win7recovery
menu label Windows ^7 Recovery Disc
kernel chain.c32
append boot ntldr=/bootmgr">>multicd-working/boot/isolinux/isolinux.cfg
fi
else
	echo "Usage: $0 {scan|copy|writecfg}"
	echo "Use only from within multicd.sh or a compatible script!"
	echo "Don't use this plugin script on its own!"
fi