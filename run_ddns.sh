#!/bin/sh
#!/bin/bash
#----------------------------------------------------
# File name : run_ddns.sh
# Author (s) : Hossein Ebrahimi - @he71.com,
#-----------------------------------------------------
# * license AGPL-3.0 
#
# * This code is free software: you can redistribute it and/or modify
# * it under the terms of the GNU Affero General Public License, version 3,
# * as published by the Free Software Foundation.
# *
# * This program is distributed in the hope that it will be useful,
# * but WITHOUT ANY WARRANTY; without even the implied warranty of
# * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
# * GNU Affero General Public License for more details.
# *
# * You should have received a copy of the GNU Affero General Public License, version 3,
# * along with this program.  If not, see <http://www.gnu.org/licenses/>
#-----------------------------------------------------

host=$(hostname) 
domainnamehost=godaddy.sh
dnsupdaterpath=./

# debug setting
#Debugflag = true
# End settings

clonestate=""
case "$host" in
        "YOURCOMPUTERNAME")
		${dnsupdaterpath}${domainnamehost} YOURDOMAIN SUBDOMAIN 
            ;;
        "YOURCOMPUTERNAMEClone")
                #-----------------
                ping -c 1 -t 1 SUBDOMAIN.YOURDOMAIN> /dev/null 2> /dev/null;
                if [ $? -ne 0 ]
                then
                	${dnsupdaterpath}${domainnamehost} YOURDOMAIN SUBDOMAIN
                fi
            ;;
        *)

esac

[ -z "${Debugflag}" ] || [ "${Debugflag}" -ne true ] && echo "${clonestate}"

exit 0
