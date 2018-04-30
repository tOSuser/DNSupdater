#!/bin/bash
 
#----------------------------------------------------
# File name : GoDaddy.sh
# Author (s) : Hossein Ebrahimi - @he71.com,
# Based on GoDaddy.sh by Nazar78 @ TeaNazaR.com v1.0 - 20160513 - 1st release.
# Adapted to work with log file and multi domains
# Hossein Ebrahimi - @he71.com
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
# av 0.51 25-04-2018 - Fixing cached ip bug for multiple calls
# av 0.5 21-04-2018 - The data structuer had been changed by Godday so the code was updated to support the new structur
#			Old structure was  : {\"data\":\"${IP}\",\"ttl\":${TTL}}
#			New structure : [{\"data\":\"${IP}\",\"name\":\"${Name}\",\"ttl\":${TTL},\"type\":\"A\"}]
#			* some lines were added to debug the code marked by #-----/debug ...... #-----debug/
#
# av 0.43 23-02-2018 - now Sends desktop notifies
# av 0.42 04-02-2018 - now Show domain names when an IP is updated
# av 0.41 16-01-2018 - Setting servernames automatically
# av 0.4 15-01-2018 - Useing servernames as variables instead stering within messages 
# av 0.31 28-11-2017 - Fixing paths
# av 0.3 17-11-2017 - Supporting notification on Telegram
# av 0.2 26-07-2017 - Supporting multiple record names
# av 0.1 09-08-2016
###########################################
#---------------------------------------------------- 
# Begin settings
# Get the Production API key/secret from https://developer.godaddy.com/keys/.
# Ensure it's for "Production" as first time it's created for "Test".
Servername=$(hostname)
Key=YOURGODDADYKEY
Secret=YOURGODDADYSECRET
 
# Domain to update.
Domain=$1
 
# Advanced settings - change only if you know what you're doing :-)
# Record type, as seen in the DNS setup page, default A.
Type=A
 
# Record name, as seen in the DNS setup page, default @.
if [ -z "$2" ] ;then
  Name=@
else
  Name=$2
fi
 
# Time To Live in seconds, minimum default 600 (10mins).
# If your public IP seldom changes, set it to 3600 (1hr) or more for DNS servers cache performance.
TTL=600
 
# Writable path to last known Public IP record cached. Best to place in tmpfs.
if [ -z "$2" ] ;then
  CachedIP=/tmp/current_ip
else
  CachedIP="/tmp/${Domain}.${Name}_ip"
fi

# External URL to check for current Public IP, must contain only a single plain text IP.
# Default http://api.ipify.org.
CheckURL=http://api.ipify.org
 
# Optional scripts/programs/commands to execute on successful update. Leave blank to disable.
# This variable will be evaluated at runtime but will not be parsed for errors nor execution guaranteed.
# Take note of the single quotes. If it's a script, ensure it's executable i.e. chmod 755 ./script.
# Example: SuccessExec='/bin/echo "$(date): My public IP changed to ${PublicIP}!">>/var/log/GoDaddy.sh.log'

# to send updaing messeage via telegram (telegram-cli required)
#SuccessExec='tele.sh "${Servername}/${Domain} :: ${Name} - $(date): My public IP (${Check}) changed to ${PublicIP}!"'
# simple updating messeage
SuccessExec='echo "${Servername}/${Domain} :: ${Name} - $(date): My public IP (${Check}) changed to ${PublicIP}!"'
SuccessMsg="${Servername}/${Domain} :: ${Name} - $(date): My public IP (${Check}) changed to ${PublicIP}!"

# Optional scripts/programs/commands to execute on update failure. Leave blank to disable.
# This variable will be evaluated at runtime but will not be parsed for errors nor execution guaranteed.
# Take note of the single quotes. If it's a script, ensure it's executable i.e. chmod 755 ./script.
# Example: FailedExec='/some/path/something-went-wrong.sh ${Update} && /some/path/email-script.sh ${PublicIP}'

# to send updaing messeage via telegram (telegram-cli required)
#FailedExec='tele.sh "${Servername}/${Domain} :: ${Name} - Current Public IP (${PublicIP}) matches Cached IP recorded. No update required!"' 
# simple updating messeage
FailedExec='echo "${Servername}/${Domain} :: ${Name} - Current Public IP (${PublicIP}) matches Cached IP recorded. No update required!"'
FailedMsg="${Servername}/${Domain} :: ${Name} - Current Public IP (${PublicIP}) matches Cached IP recorded. No update required!"

# log setting
#Logflag = true
# End settings

# debug setting
#Debugflag = true
# End settings
 
# notification setting
#Notificationflag = true
# End settings
 
Curl=$(/usr/bin/which curl 2>/dev/null)
[ "${Curl}" = "" ] &&
echo "Error: Unable to find 'curl CLI'." && exit 1
[ -z "${Key}" ] || [ -z "${Secret}" ] &&
echo "Error: Requires API 'Key/Secret' value." && exit 1
[ -z "${Domain}" ] &&
echo "Error: Requires 'Domain' value." && exit 1
[ -z "${Type}" ] && Type=A
[ -z "${Name}" ] && Name=@
[ -z "${TTL}" ] && TTL=600
[ "${TTL}" -lt 600 ] && TTL=600
/usr/bin/touch ${CachedIP} 2>/dev/null
[ $? -ne 0 ] && echo "Error: Can't write to ${CachedIP}." && exit 1
[ -z "${CheckURL}" ] && CheckURL=http://api.ipify.org

[ -z "${Debugflag}" ] || [ "${Debugflag}" -ne true ] && echo -e "Checking current 'Public IP' from '${CheckURL}'..."

PublicIP=$(${Curl} -kLs ${CheckURL})
if [ $? -eq 0 ] && [[ "${PublicIP}" =~ [0-9]{1,3}\.[0-9]{1,3} ]];then

  #-----/debug
  [ -z "${Debugflag}" ] || [ "${Debugflag}" -ne true ] && echo -e "'Public IP' :  ${PublicIP}!" 
  #-----debug/

  [ -z "${Logflag}" ] || [ "${Logflag}" -ne true ] && echo -n "$(date) >> (${Domain}'- ${PublicIP}) : ">>/var/log/GoDaddy.sh.log 
  
else
  [ -z "${Logflag}" ] || [ "${Logflag}" -ne true ] && echo "Fail! ${PublicIP}">>/var/log/GoDaddy.sh.log 
  [ -z "${Debugflag}" ] || [ "${Debugflag}" -ne true ] && notify-send "${FailedMsg}"
  eval "${FailedExec}"
  exit 1
fi

if [ "$(cat ${CachedIP} 2>/dev/null)" != "${PublicIP}" ];then
  #-----/debug
  [ -z "${Debugflag}" ] || [ "${Debugflag}" -ne true ] && echo -e "Checking '${Domain}' IP records from 'GoDaddy'..."
  #-----debug/
  
  Check=$(${Curl} -kLsH"Authorization: sso-key ${Key}:${Secret}" \
  -H"Content-type: application/json" \
  https://api.godaddy.com/v1/domains/${Domain}/records/${Type}/${Name} \
  2>/dev/null|sed -r 's/.+data":"(.+)","n.+/\1/g' 2>/dev/null)

  #-----/debug
  [ -z "${Debugflag}" ] || [ "${Debugflag}" -ne true ] && myCheck=$(${Curl} -kLsH"Authorization: sso-key ${Key}:${Secret}" \
  -H"Content-type: application/json" \
  https://api.godaddy.com/v1/domains/${Domain}/records/${Type}/${Name} \
  2>/dev/null)
  [ -z "${Debugflag}" ] || [ "${Debugflag}" -ne true ] && echo -e "${myCheck}"
  #-----debug/

  if [ $? -eq 0 ] && [ "${Check}" = "${PublicIP}" ];then
    echo -n ${Check}>${CachedIP}
    [ -z "${Logflag}" ] || [ "${Logflag}" -ne true ] && echo "Current 'Public IP' matches 'GoDaddy' records. No update required!">>/var/log/GoDaddy.sh.log
    #eval "${FailedExec}"
  else
    #eval "${SuccessExec}"
    #-----/debug
    [ -z "${Debugflag}" ] || [ "${Debugflag}" -ne true ] && echo -e "changed!\nUpdating '${Domain}'..."
    #-----debug/
    
    Update=$(${Curl} -kLsXPUT -H"Authorization: sso-key ${Key}:${Secret}" \
    -H"Content-type: application/json" \
    https://api.godaddy.com/v1/domains/${Domain}/records/${Type}/${Name} \
    -d "[{\"data\":\"${PublicIP}\",\"name\":\"${Name}\",\"ttl\":${TTL},\"type\":\"A\"}]" 2>/dev/null)
    
    #-----/debug
    [ -z "${Debugflag}" ] || [ "${Debugflag}" -ne true ] && echo -e "[{\"data\":\"${PublicIP}\",\"name\":\"${Name}\",\"ttl\":${TTL},\"type\":\"${Type}\"}]"
    #-----debug/
    
    if [ $? -eq 0 ] && [ "${Update}" = "{}" ];then
      [ -z "${Logflag}" ] || [ "${Logflag}" -ne true ] && echo -n ${PublicIP}>${CachedIP}>>/var/log/GoDaddy.sh.log
      [ -z "${Logflag}" ] || [ "${Logflag}" -ne true ] && echo "Success!">>/var/log/GoDaddy.sh.log
      [ -z "${Notificationflag}" ] || [ "${Notificationflag}" -ne true ] && notify-send "${SuccessMsg}"
      eval "${SuccessExec}"
    else
      [ -z "${Logflag}" ] || [ "${Logflag}" -ne true ] && echo "Fail! ${Update}">>/var/log/GoDaddy.sh.log
      [ -z "${Notificationflag}" ] || [ "${Notificationflag}" -ne true ] && notify-send "${FailedMsg}"
      eval "${FailedExec}"
      exit 1
    fi  
  fi
else
  #-----/debug
  [ -z "${Debugflag}" ] || [ "${Debugflag}" -ne true ] && echo "Current 'Public IP' matches 'Cached IP' recorded. No update required!"
  #-----debug/
  
  [ -z "${Logflag}" ] || [ "${Logflag}" -ne true ] && echo "Current 'Public IP' matches 'Cached IP' recorded. No update required!">>/var/log/GoDaddy.sh.log
  #eval "${FailedExec}"
fi
exit $?