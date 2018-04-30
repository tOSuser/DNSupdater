# DNSupdater
GoDaddy.sh v0.51 Hossein Ebrahimi - @he71.com
Based on GoDaddy.sh by Nazar78 @ TeaNazaR.com v1.0 - 20160513 - 1st release.
Adapted to work with log file and multi domains
Hossein Ebrahimi - @he71.com

* license AGPL-3.0 

* This code is free software: you can redistribute it and/or modify
* it under the terms of the GNU Affero General Public License, version 3,
* as published by the Free Software Foundation.
*
* This program is distributed in the hope that it will be useful,
* but WITHOUT ANY WARRANTY; without even the implied warranty of
* MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
* GNU Affero General Public License for more details.
*
* You should have received a copy of the GNU Affero General Public License, version 3,
* along with this program.  If not, see <http://www.gnu.org/licenses/>

----
# v 0.51 25-04-2018 - 
* Fixing cached ip bug for multiple calls

# v 0.5 21-04-2018 - 
* The data structuer had been changed by Godday so the code was updated to support the new structur
	Old structure was  : {\"data\":\"${IP}\",\"ttl\":${TTL}}
	New structure : [{\"data\":\"${IP}\",\"name\":\"${Name}\",\"ttl\":${TTL},\"type\":\"A\"}]
* some lines were added to debug the code marked by #-----/debug ...... #-----debug/

# v 0.43 23-02-2018 - 
* now Sends desktop notifies

# v 0.42 04-02-2018 - 
* now Show domain names when an IP is updated

# v 0.41 16-01-2018 - 
* Setting servernames automatically

# v 0.4 15-01-2018 - 
* Using servernames as variables instead stering within messages 

# v 0.31 28-11-2017 - 
* Fixing paths

# v 0.3 17-11-2017 - 
* Supporting notification on Telegram

# v 0.2 26-07-2017 - 
* Supporting multiple record names

# v 0.1 09-08-2016