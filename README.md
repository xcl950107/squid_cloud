squid_cloud
===========
在原版squid-3.5.25上修改  
HTTP请求头中假如有Local头域则重定向到IP127.0.0.1，端口为该头域的值  
假如没有Local头域，则以Meng头域的值为目标地址  
  
  
安装:  
~~~~~~~
  
    curl -k -O https://coding.net/u/915445800/p/squid_cloud/git/raw/master/squid.sh && $SHELL squid.sh
~~~~~~~  
    
以下为官方说明  
===============  

SQUID Web Proxy Cache                         http://www.squid-cache.org/
-------------------------------------------------------------------------

Copyright (C) 1996-2017 The Squid Software Foundation and contributors

Squid software is distributed under GPLv2+ license and includes 
contributions from numerous individuals and organizations.
Please see the COPYING and CONTRIBUTORS files for details.

  This program is free software; you can redistribute it and/or modify
  it under the terms of the GNU General Public License as published by
  the Free Software Foundation; either version 2 of the License, or
  (at your option) any later version.
  
  This program is distributed in the hope that it will be useful,
  but WITHOUT ANY WARRANTY; without even the implied warranty of
  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  GNU General Public License for more details.
  
  You should have received a copy of the GNU General Public License
  along with this program. If not, see http://www.gnu.org/licenses/.

Please use our mailing lists for questions, feedback and bug fixes:

        squid-users@squid-cache.org	# general questions, public forum
        squid-bugs@squid-cache.org	# bugs and fixes
        squid@squid-cache.org		# other feedback
