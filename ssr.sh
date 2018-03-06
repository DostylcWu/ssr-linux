{\rtf1\ansi\ansicpg936\cocoartf1504\cocoasubrtf830
{\fonttbl\f0\fmodern\fcharset0 Courier;\f1\fnil\fcharset134 PingFangSC-Regular;}
{\colortbl;\red255\green255\blue255;\red0\green0\blue0;}
{\*\expandedcolortbl;;\cssrgb\c0\c0\c0;}
\paperw11900\paperh16840\margl1440\margr1440\vieww10800\viewh8400\viewkind0
\deftab720
\pard\pardeftab720\sl280\partightenfactor0

\f0\fs24 \cf2 \expnd0\expndtw0\kerning0
#!/usr/bin/env bash\
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin\
export PATH\
\
#=================================================\
#	System Required: CentOS 6+/Debian 6+/Ubuntu 14.04+\
#	Description: Install the ShadowsocksR mudbjson server\
#	Version: 1.0.25\
#	Author: Toyo\
#	\
#=================================================\
\
sh_ver="1.0.25"\
filepath=$(cd "$(dirname "$0")"; pwd)\
file=$(echo -e "$\{filepath\}"|awk -F "$0" '\{print $1\}')\
ssr_folder="/usr/local/shadowsocksr"\
config_file="$\{ssr_folder\}/config.json"\
config_user_file="$\{ssr_folder\}/user-config.json"\
config_user_api_file="$\{ssr_folder\}/userapiconfig.py"\
config_user_mudb_file="$\{ssr_folder\}/mudb.json"\
ssr_log_file="$\{ssr_folder\}/ssserver.log"\
Libsodiumr_file="/usr/local/lib/libsodium.so"\
Libsodiumr_ver_backup="1.0.15"\
Server_Speeder_file="/serverspeeder/bin/serverSpeeder.sh"\
LotServer_file="/appex/bin/serverSpeeder.sh"\
BBR_file="$\{file\}/bbr.sh"\
jq_file="$\{ssr_folder\}/jq"\
\
Green_font_prefix="\\033[32m" && Red_font_prefix="\\033[31m" && Green_background_prefix="\\033[42;37m" && Red_background_prefix="\\033[41;37m" && Font_color_suffix="\\033[0m"\
Info="$\{Green_font_prefix\}[
\f1 \'d0\'c5\'cf\'a2
\f0 ]$\{Font_color_suffix\}"\
Error="$\{Red_font_prefix\}[
\f1 \'b4\'ed\'ce\'f3
\f0 ]$\{Font_color_suffix\}"\
Tip="$\{Green_font_prefix\}[
\f1 \'d7\'a2\'d2\'e2
\f0 ]$\{Font_color_suffix\}"\
Separator_1="\'97\'97\'97\'97\'97\'97\'97\'97\'97\'97\'97\'97\'97\'97\'97\'97\'97\'97\'97\'97\'97\'97\'97\'97\'97\'97\'97\'97\'97\'97"\
\
check_root()\{\
	[[ $EUID != 0 ]] && echo -e "$\{Error\} 
\f1 \'b5\'b1\'c7\'b0\'d5\'cb\'ba\'c5\'b7\'c7
\f0 ROOT(
\f1 \'bb\'f2\'c3\'bb\'d3\'d0
\f0 ROOT
\f1 \'c8\'a8\'cf\'de
\f0 )
\f1 \'a3\'ac\'ce\'de\'b7\'a8\'bc\'cc\'d0\'f8\'b2\'d9\'d7\'f7\'a3\'ac\'c7\'eb\'ca\'b9\'d3\'c3
\f0 $\{Green_background_prefix\} sudo su $\{Font_color_suffix\}
\f1 \'c0\'b4\'bb\'f1\'c8\'a1\'c1\'d9\'ca\'b1
\f0 ROOT
\f1 \'c8\'a8\'cf\'de\'a3\'a8\'d6\'b4\'d0\'d0\'ba\'f3\'bb\'e1\'cc\'e1\'ca\'be\'ca\'e4\'c8\'eb\'b5\'b1\'c7\'b0\'d5\'cb\'ba\'c5\'b5\'c4\'c3\'dc\'c2\'eb\'a3\'a9\'a1\'a3
\f0 " && exit 1\
\}\
check_sys()\{\
	if [[ -f /etc/redhat-release ]]; then\
		release="centos"\
	elif cat /etc/issue | grep -q -E -i "debian"; then\
		release="debian"\
	elif cat /etc/issue | grep -q -E -i "ubuntu"; then\
		release="ubuntu"\
	elif cat /etc/issue | grep -q -E -i "centos|red hat|redhat"; then\
		release="centos"\
	elif cat /proc/version | grep -q -E -i "debian"; then\
		release="debian"\
	elif cat /proc/version | grep -q -E -i "ubuntu"; then\
		release="ubuntu"\
	elif cat /proc/version | grep -q -E -i "centos|red hat|redhat"; then\
		release="centos"\
    fi\
	bit=`uname -m`\
\}\
check_pid()\{\
	PID=`ps -ef |grep -v grep | grep server.py |awk '\{print $2\}'`\
\}\
check_crontab()\{\
	[[ ! -e "/usr/bin/crontab" ]] && echo -e "$\{Error\} 
\f1 \'c8\'b1\'c9\'d9\'d2\'c0\'c0\'b5
\f0  Crontab 
\f1 \'a3\'ac\'c7\'eb\'b3\'a2\'ca\'d4\'ca\'d6\'b6\'af\'b0\'b2\'d7\'b0
\f0  CentOS: yum install crond -y , Debian/Ubuntu: apt-get install cron -y !" && exit 1\
\}\
SSR_installation_status()\{\
	[[ ! -e $\{ssr_folder\} ]] && echo -e "$\{Error\} 
\f1 \'c3\'bb\'d3\'d0\'b7\'a2\'cf\'d6
\f0  ShadowsocksR 
\f1 \'ce\'c4\'bc\'fe\'bc\'d0\'a3\'ac\'c7\'eb\'bc\'ec\'b2\'e9
\f0  !" && exit 1\
\}\
Server_Speeder_installation_status()\{\
	[[ ! -e $\{Server_Speeder_file\} ]] && echo -e "$\{Error\} 
\f1 \'c3\'bb\'d3\'d0\'b0\'b2\'d7\'b0
\f0  
\f1 \'c8\'f1\'cb\'d9
\f0 (Server Speeder)
\f1 \'a3\'ac\'c7\'eb\'bc\'ec\'b2\'e9
\f0  !" && exit 1\
\}\
LotServer_installation_status()\{\
	[[ ! -e $\{LotServer_file\} ]] && echo -e "$\{Error\} 
\f1 \'c3\'bb\'d3\'d0\'b0\'b2\'d7\'b0
\f0  LotServer
\f1 \'a3\'ac\'c7\'eb\'bc\'ec\'b2\'e9
\f0  !" && exit 1\
\}\
BBR_installation_status()\{\
	if [[ ! -e $\{BBR_file\} ]]; then\
		echo -e "$\{Error\} 
\f1 \'c3\'bb\'d3\'d0\'b7\'a2\'cf\'d6
\f0  BBR
\f1 \'bd\'c5\'b1\'be\'a3\'ac\'bf\'aa\'ca\'bc\'cf\'c2\'d4\'d8
\f0 ..."\
		cd "$\{file\}"\
		if ! wget -N --no-check-certificate https://raw.githubusercontent.com/ToyoDAdoubi/doubi/master/bbr.sh; then\
			echo -e "$\{Error\} BBR 
\f1 \'bd\'c5\'b1\'be\'cf\'c2\'d4\'d8\'ca\'a7\'b0\'dc
\f0  !" && exit 1\
		else\
			echo -e "$\{Info\} BBR 
\f1 \'bd\'c5\'b1\'be\'cf\'c2\'d4\'d8\'cd\'ea\'b3\'c9
\f0  !"\
			chmod +x bbr.sh\
		fi\
	fi\
\}\
# 
\f1 \'c9\'e8\'d6\'c3
\f0  
\f1 \'b7\'c0\'bb\'f0\'c7\'bd\'b9\'e6\'d4\'f2
\f0 \
Add_iptables()\{\
	if [[ ! -z "$\{ssr_port\}" ]]; then\
		iptables -I INPUT -m state --state NEW -m tcp -p tcp --dport $\{ssr_port\} -j ACCEPT\
		iptables -I INPUT -m state --state NEW -m udp -p udp --dport $\{ssr_port\} -j ACCEPT\
		ip6tables -I INPUT -m state --state NEW -m tcp -p tcp --dport $\{ssr_port\} -j ACCEPT\
		ip6tables -I INPUT -m state --state NEW -m udp -p udp --dport $\{ssr_port\} -j ACCEPT\
	fi\
\}\
Del_iptables()\{\
	if [[ ! -z "$\{port\}" ]]; then\
		iptables -D INPUT -m state --state NEW -m tcp -p tcp --dport $\{port\} -j ACCEPT\
		iptables -D INPUT -m state --state NEW -m udp -p udp --dport $\{port\} -j ACCEPT\
		ip6tables -D INPUT -m state --state NEW -m tcp -p tcp --dport $\{port\} -j ACCEPT\
		ip6tables -D INPUT -m state --state NEW -m udp -p udp --dport $\{port\} -j ACCEPT\
	fi\
\}\
Save_iptables()\{\
	if [[ $\{release\} == "centos" ]]; then\
		service iptables save\
		service ip6tables save\
	else\
		iptables-save > /etc/iptables.up.rules\
		ip6tables-save > /etc/ip6tables.up.rules\
	fi\
\}\
Set_iptables()\{\
	if [[ $\{release\} == "centos" ]]; then\
		service iptables save\
		service ip6tables save\
		chkconfig --level 2345 iptables on\
		chkconfig --level 2345 ip6tables on\
	else\
		iptables-save > /etc/iptables.up.rules\
		ip6tables-save > /etc/ip6tables.up.rules\
		echo -e '#!/bin/bash\\n/sbin/iptables-restore < /etc/iptables.up.rules\\n/sbin/ip6tables-restore < /etc/ip6tables.up.rules' > /etc/network/if-pre-up.d/iptables\
		chmod +x /etc/network/if-pre-up.d/iptables\
	fi\
\}\
# 
\f1 \'b6\'c1\'c8\'a1
\f0  
\f1 \'c5\'e4\'d6\'c3\'d0\'c5\'cf\'a2
\f0 \
Get_IP()\{\
	ip=$(wget -qO- -t1 -T2 ipinfo.io/ip)\
	if [[ -z "$\{ip\}" ]]; then\
		ip=$(wget -qO- -t1 -T2 api.ip.sb/ip)\
		if [[ -z "$\{ip\}" ]]; then\
			ip=$(wget -qO- -t1 -T2 members.3322.org/dyndns/getip)\
			if [[ -z "$\{ip\}" ]]; then\
				ip="VPS_IP"\
			fi\
		fi\
	fi\
\}\
Get_User_info()\{\
	Get_user_port=$1\
	user_info_get=$(python mujson_mgr.py -l -p "$\{Get_user_port\}")\
	match_info=$(echo "$\{user_info_get\}"|grep -w "### user ")\
	if [[ -z "$\{match_info\}" ]]; then\
		echo -e "$\{Error\} 
\f1 \'d3\'c3\'bb\'a7\'d0\'c5\'cf\'a2\'bb\'f1\'c8\'a1\'ca\'a7\'b0\'dc
\f0  $\{Green_font_prefix\}[
\f1 \'b6\'cb\'bf\'da
\f0 : $\{ssr_port\}]$\{Font_color_suffix\} " && exit 1\
	fi\
	user_name=$(echo "$\{user_info_get\}"|grep -w "user :"|awk -F "user : " '\{print $NF\}')\
	port=$(echo "$\{user_info_get\}"|grep -w "port :"|sed 's/[[:space:]]//g'|awk -F ":" '\{print $NF\}')\
	password=$(echo "$\{user_info_get\}"|grep -w "passwd :"|awk -F "passwd : " '\{print $NF\}')\
	method=$(echo "$\{user_info_get\}"|grep -w "method :"|sed 's/[[:space:]]//g'|awk -F ":" '\{print $NF\}')\
	protocol=$(echo "$\{user_info_get\}"|grep -w "protocol :"|sed 's/[[:space:]]//g'|awk -F ":" '\{print $NF\}')\
	protocol_param=$(echo "$\{user_info_get\}"|grep -w "protocol_param :"|sed 's/[[:space:]]//g'|awk -F ":" '\{print $NF\}')\
	[[ -z $\{protocol_param\} ]] && protocol_param="0(
\f1 \'ce\'de\'cf\'de
\f0 )"\
	obfs=$(echo "$\{user_info_get\}"|grep -w "obfs :"|sed 's/[[:space:]]//g'|awk -F ":" '\{print $NF\}')\
	#transfer_enable=$(echo "$\{user_info_get\}"|grep -w "transfer_enable :"|sed 's/[[:space:]]//g'|awk -F ":" '\{print $NF\}'|awk -F "ytes" '\{print $1\}'|sed 's/KB/ KB/;s/MB/ MB/;s/GB/ GB/;s/TB/ TB/;s/PB/ PB/')\
	#u=$(echo "$\{user_info_get\}"|grep -w "u :"|sed 's/[[:space:]]//g'|awk -F ":" '\{print $NF\}')\
	#d=$(echo "$\{user_info_get\}"|grep -w "d :"|sed 's/[[:space:]]//g'|awk -F ":" '\{print $NF\}')\
	forbidden_port=$(echo "$\{user_info_get\}"|grep -w "forbidden_port :"|sed 's/[[:space:]]//g'|awk -F ":" '\{print $NF\}')\
	[[ -z $\{forbidden_port\} ]] && forbidden_port="
\f1 \'ce\'de\'cf\'de\'d6\'c6
\f0 "\
	speed_limit_per_con=$(echo "$\{user_info_get\}"|grep -w "speed_limit_per_con :"|sed 's/[[:space:]]//g'|awk -F ":" '\{print $NF\}')\
	speed_limit_per_user=$(echo "$\{user_info_get\}"|grep -w "speed_limit_per_user :"|sed 's/[[:space:]]//g'|awk -F ":" '\{print $NF\}')\
	Get_User_transfer "$\{port\}"\
\}\
Get_User_transfer()\{\
	transfer_port=$1\
	#echo "transfer_port=$\{transfer_port\}"\
	all_port=$($\{jq_file\} '.[]|.port' $\{config_user_mudb_file\})\
	#echo "all_port=$\{all_port\}"\
	port_num=$(echo "$\{all_port\}"|grep -nw "$\{transfer_port\}"|awk -F ":" '\{print $1\}')\
	#echo "port_num=$\{port_num\}"\
	port_num_1=$(expr $\{port_num\} - 1)\
	#echo "port_num_1=$\{port_num_1\}"\
	transfer_enable_1=$($\{jq_file\} ".[$\{port_num_1\}].transfer_enable" $\{config_user_mudb_file\})\
	#echo "transfer_enable_1=$\{transfer_enable_1\}"\
	u_1=$($\{jq_file\} ".[$\{port_num_1\}].u" $\{config_user_mudb_file\})\
	#echo "u_1=$\{u_1\}"\
	d_1=$($\{jq_file\} ".[$\{port_num_1\}].d" $\{config_user_mudb_file\})\
	#echo "d_1=$\{d_1\}"\
	transfer_enable_Used_2_1=$(expr $\{u_1\} + $\{d_1\})\
	#echo "transfer_enable_Used_2_1=$\{transfer_enable_Used_2_1\}"\
	transfer_enable_Used_1=$(expr $\{transfer_enable_1\} - $\{transfer_enable_Used_2_1\})\
	#echo "transfer_enable_Used_1=$\{transfer_enable_Used_1\}"\
	\
	\
	if [[ $\{transfer_enable_1\} -lt 1024 ]]; then\
		transfer_enable="$\{transfer_enable_1\} B"\
	elif [[ $\{transfer_enable_1\} -lt 1048576 ]]; then\
		transfer_enable=$(awk 'BEGIN\{printf "%.2f\\n",'$\{transfer_enable_1\}'/'1024'\}')\
		transfer_enable="$\{transfer_enable\} KB"\
	elif [[ $\{transfer_enable_1\} -lt 1073741824 ]]; then\
		transfer_enable=$(awk 'BEGIN\{printf "%.2f\\n",'$\{transfer_enable_1\}'/'1048576'\}')\
		transfer_enable="$\{transfer_enable\} MB"\
	elif [[ $\{transfer_enable_1\} -lt 1099511627776 ]]; then\
		transfer_enable=$(awk 'BEGIN\{printf "%.2f\\n",'$\{transfer_enable_1\}'/'1073741824'\}')\
		transfer_enable="$\{transfer_enable\} GB"\
	elif [[ $\{transfer_enable_1\} -lt 1125899906842624 ]]; then\
		transfer_enable=$(awk 'BEGIN\{printf "%.2f\\n",'$\{transfer_enable_1\}'/'1099511627776'\}')\
		transfer_enable="$\{transfer_enable\} TB"\
	fi\
	#echo "transfer_enable=$\{transfer_enable\}"\
	if [[ $\{u_1\} -lt 1024 ]]; then\
		u="$\{u_1\} B"\
	elif [[ $\{u_1\} -lt 1048576 ]]; then\
		u=$(awk 'BEGIN\{printf "%.2f\\n",'$\{u_1\}'/'1024'\}')\
		u="$\{u\} KB"\
	elif [[ $\{u_1\} -lt 1073741824 ]]; then\
		u=$(awk 'BEGIN\{printf "%.2f\\n",'$\{u_1\}'/'1048576'\}')\
		u="$\{u\} MB"\
	elif [[ $\{u_1\} -lt 1099511627776 ]]; then\
		u=$(awk 'BEGIN\{printf "%.2f\\n",'$\{u_1\}'/'1073741824'\}')\
		u="$\{u\} GB"\
	elif [[ $\{u_1\} -lt 1125899906842624 ]]; then\
		u=$(awk 'BEGIN\{printf "%.2f\\n",'$\{u_1\}'/'1099511627776'\}')\
		u="$\{u\} TB"\
	fi\
	#echo "u=$\{u\}"\
	if [[ $\{d_1\} -lt 1024 ]]; then\
		d="$\{d_1\} B"\
	elif [[ $\{d_1\} -lt 1048576 ]]; then\
		d=$(awk 'BEGIN\{printf "%.2f\\n",'$\{d_1\}'/'1024'\}')\
		d="$\{d\} KB"\
	elif [[ $\{d_1\} -lt 1073741824 ]]; then\
		d=$(awk 'BEGIN\{printf "%.2f\\n",'$\{d_1\}'/'1048576'\}')\
		d="$\{d\} MB"\
	elif [[ $\{d_1\} -lt 1099511627776 ]]; then\
		d=$(awk 'BEGIN\{printf "%.2f\\n",'$\{d_1\}'/'1073741824'\}')\
		d="$\{d\} GB"\
	elif [[ $\{d_1\} -lt 1125899906842624 ]]; then\
		d=$(awk 'BEGIN\{printf "%.2f\\n",'$\{d_1\}'/'1099511627776'\}')\
		d="$\{d\} TB"\
	fi\
	#echo "d=$\{d\}"\
	if [[ $\{transfer_enable_Used_1\} -lt 1024 ]]; then\
		transfer_enable_Used="$\{transfer_enable_Used_1\} B"\
	elif [[ $\{transfer_enable_Used_1\} -lt 1048576 ]]; then\
		transfer_enable_Used=$(awk 'BEGIN\{printf "%.2f\\n",'$\{transfer_enable_Used_1\}'/'1024'\}')\
		transfer_enable_Used="$\{transfer_enable_Used\} KB"\
	elif [[ $\{transfer_enable_Used_1\} -lt 1073741824 ]]; then\
		transfer_enable_Used=$(awk 'BEGIN\{printf "%.2f\\n",'$\{transfer_enable_Used_1\}'/'1048576'\}')\
		transfer_enable_Used="$\{transfer_enable_Used\} MB"\
	elif [[ $\{transfer_enable_Used_1\} -lt 1099511627776 ]]; then\
		transfer_enable_Used=$(awk 'BEGIN\{printf "%.2f\\n",'$\{transfer_enable_Used_1\}'/'1073741824'\}')\
		transfer_enable_Used="$\{transfer_enable_Used\} GB"\
	elif [[ $\{transfer_enable_Used_1\} -lt 1125899906842624 ]]; then\
		transfer_enable_Used=$(awk 'BEGIN\{printf "%.2f\\n",'$\{transfer_enable_Used_1\}'/'1099511627776'\}')\
		transfer_enable_Used="$\{transfer_enable_Used\} TB"\
	fi\
	#echo "transfer_enable_Used=$\{transfer_enable_Used\}"\
	if [[ $\{transfer_enable_Used_2_1\} -lt 1024 ]]; then\
		transfer_enable_Used_2="$\{transfer_enable_Used_2_1\} B"\
	elif [[ $\{transfer_enable_Used_2_1\} -lt 1048576 ]]; then\
		transfer_enable_Used_2=$(awk 'BEGIN\{printf "%.2f\\n",'$\{transfer_enable_Used_2_1\}'/'1024'\}')\
		transfer_enable_Used_2="$\{transfer_enable_Used_2\} KB"\
	elif [[ $\{transfer_enable_Used_2_1\} -lt 1073741824 ]]; then\
		transfer_enable_Used_2=$(awk 'BEGIN\{printf "%.2f\\n",'$\{transfer_enable_Used_2_1\}'/'1048576'\}')\
		transfer_enable_Used_2="$\{transfer_enable_Used_2\} MB"\
	elif [[ $\{transfer_enable_Used_2_1\} -lt 1099511627776 ]]; then\
		transfer_enable_Used_2=$(awk 'BEGIN\{printf "%.2f\\n",'$\{transfer_enable_Used_2_1\}'/'1073741824'\}')\
		transfer_enable_Used_2="$\{transfer_enable_Used_2\} GB"\
	elif [[ $\{transfer_enable_Used_2_1\} -lt 1125899906842624 ]]; then\
		transfer_enable_Used_2=$(awk 'BEGIN\{printf "%.2f\\n",'$\{transfer_enable_Used_2_1\}'/'1099511627776'\}')\
		transfer_enable_Used_2="$\{transfer_enable_Used_2\} TB"\
	fi\
	#echo "transfer_enable_Used_2=$\{transfer_enable_Used_2\}"\
\}\
Get_User_transfer_all()\{\
	if [[ $\{transfer_enable_Used_233\} -lt 1024 ]]; then\
		transfer_enable_Used_233_2="$\{transfer_enable_Used_233\} B"\
	elif [[ $\{transfer_enable_Used_233\} -lt 1048576 ]]; then\
		transfer_enable_Used_233_2=$(awk 'BEGIN\{printf "%.2f\\n",'$\{transfer_enable_Used_233\}'/'1024'\}')\
		transfer_enable_Used_233_2="$\{transfer_enable_Used_233_2\} KB"\
	elif [[ $\{transfer_enable_Used_233\} -lt 1073741824 ]]; then\
		transfer_enable_Used_233_2=$(awk 'BEGIN\{printf "%.2f\\n",'$\{transfer_enable_Used_233\}'/'1048576'\}')\
		transfer_enable_Used_233_2="$\{transfer_enable_Used_233_2\} MB"\
	elif [[ $\{transfer_enable_Used_233\} -lt 1099511627776 ]]; then\
		transfer_enable_Used_233_2=$(awk 'BEGIN\{printf "%.2f\\n",'$\{transfer_enable_Used_233\}'/'1073741824'\}')\
		transfer_enable_Used_233_2="$\{transfer_enable_Used_233_2\} GB"\
	elif [[ $\{transfer_enable_Used_233\} -lt 1125899906842624 ]]; then\
		transfer_enable_Used_233_2=$(awk 'BEGIN\{printf "%.2f\\n",'$\{transfer_enable_Used_233\}'/'1099511627776'\}')\
		transfer_enable_Used_233_2="$\{transfer_enable_Used_233_2\} TB"\
	fi\
\}\
urlsafe_base64()\{\
	date=$(echo -n "$1"|base64|sed ':a;N;s/\\n/ /g;ta'|sed 's/ //g;s/=//g;s/+/-/g;s/\\//_/g')\
	echo -e "$\{date\}"\
\}\
ss_link_qr()\{\
	SSbase64=$(urlsafe_base64 "$\{method\}:$\{password\}@$\{ip\}:$\{port\}")\
	SSurl="ss://$\{SSbase64\}"\
	SSQRcode="http://doub.pw/qr/qr.php?text=$\{SSurl\}"\
	ss_link=" SS    
\f1 \'c1\'b4\'bd\'d3
\f0  : $\{Green_font_prefix\}$\{SSurl\}$\{Font_color_suffix\} \\n SS  
\f1 \'b6\'fe\'ce\'ac\'c2\'eb
\f0  : $\{Green_font_prefix\}$\{SSQRcode\}$\{Font_color_suffix\}"\
\}\
ssr_link_qr()\{\
	SSRprotocol=$(echo $\{protocol\} | sed 's/_compatible//g')\
	SSRobfs=$(echo $\{obfs\} | sed 's/_compatible//g')\
	SSRPWDbase64=$(urlsafe_base64 "$\{password\}")\
	SSRbase64=$(urlsafe_base64 "$\{ip\}:$\{port\}:$\{SSRprotocol\}:$\{method\}:$\{SSRobfs\}:$\{SSRPWDbase64\}")\
	SSRurl="ssr://$\{SSRbase64\}"\
	SSRQRcode="http://doub.pw/qr/qr.php?text=$\{SSRurl\}"\
	ssr_link=" SSR   
\f1 \'c1\'b4\'bd\'d3
\f0  : $\{Red_font_prefix\}$\{SSRurl\}$\{Font_color_suffix\} \\n SSR 
\f1 \'b6\'fe\'ce\'ac\'c2\'eb
\f0  : $\{Red_font_prefix\}$\{SSRQRcode\}$\{Font_color_suffix\} \\n "\
\}\
ss_ssr_determine()\{\
	protocol_suffix=`echo $\{protocol\} | awk -F "_" '\{print $NF\}'`\
	obfs_suffix=`echo $\{obfs\} | awk -F "_" '\{print $NF\}'`\
	if [[ $\{protocol\} = "origin" ]]; then\
		if [[ $\{obfs\} = "plain" ]]; then\
			ss_link_qr\
			ssr_link=""\
		else\
			if [[ $\{obfs_suffix\} != "compatible" ]]; then\
				ss_link=""\
			else\
				ss_link_qr\
			fi\
		fi\
	else\
		if [[ $\{protocol_suffix\} != "compatible" ]]; then\
			ss_link=""\
		else\
			if [[ $\{obfs_suffix\} != "compatible" ]]; then\
				if [[ $\{obfs_suffix\} = "plain" ]]; then\
					ss_link_qr\
				else\
					ss_link=""\
				fi\
			else\
				ss_link_qr\
			fi\
		fi\
	fi\
	ssr_link_qr\
\}\
# 
\f1 \'cf\'d4\'ca\'be
\f0  
\f1 \'c5\'e4\'d6\'c3\'d0\'c5\'cf\'a2
\f0 \
View_User()\{\
	SSR_installation_status\
	List_port_user\
	while true\
	do\
		echo -e "
\f1 \'c7\'eb\'ca\'e4\'c8\'eb\'d2\'aa\'b2\'e9\'bf\'b4\'d5\'cb\'ba\'c5\'d0\'c5\'cf\'a2\'b5\'c4\'d3\'c3\'bb\'a7
\f0  
\f1 \'b6\'cb\'bf\'da
\f0 "\
		stty erase '^H' && read -p "(
\f1 \'c4\'ac\'c8\'cf
\f0 : 
\f1 \'c8\'a1\'cf\'fb
\f0 ):" View_user_port\
		[[ -z "$\{View_user_port\}" ]] && echo -e "
\f1 \'d2\'d1\'c8\'a1\'cf\'fb
\f0 ..." && exit 1\
		View_user=$(cat "$\{config_user_mudb_file\}"|grep '"port": '"$\{View_user_port\}"',')\
		if [[ ! -z $\{View_user\} ]]; then\
			Get_User_info "$\{View_user_port\}"\
			View_User_info\
			break\
		else\
			echo -e "$\{Error\} 
\f1 \'c7\'eb\'ca\'e4\'c8\'eb\'d5\'fd\'c8\'b7\'b5\'c4\'b6\'cb\'bf\'da
\f0  !"\
		fi\
	done\
\}\
View_User_info()\{\
	ip=$(cat $\{config_user_api_file\}|grep "SERVER_PUB_ADDR = "|awk -F "[']" '\{print $2\}')\
	[[ -z "$\{ip\}" ]] && Get_IP\
	ss_ssr_determine\
	clear && echo "===================================================" && echo\
	echo -e " 
\f1 \'d3\'c3\'bb\'a7
\f0  [$\{user_name\}] 
\f1 \'b5\'c4\'c5\'e4\'d6\'c3\'d0\'c5\'cf\'a2\'a3\'ba
\f0 " && echo\
	echo -e " I  P\\t    : $\{Green_font_prefix\}$\{ip\}$\{Font_color_suffix\}"\
	echo -e " 
\f1 \'b6\'cb\'bf\'da
\f0 \\t    : $\{Green_font_prefix\}$\{port\}$\{Font_color_suffix\}"\
	echo -e " 
\f1 \'c3\'dc\'c2\'eb
\f0 \\t    : $\{Green_font_prefix\}$\{password\}$\{Font_color_suffix\}"\
	echo -e " 
\f1 \'bc\'d3\'c3\'dc
\f0 \\t    : $\{Green_font_prefix\}$\{method\}$\{Font_color_suffix\}"\
	echo -e " 
\f1 \'d0\'ad\'d2\'e9
\f0 \\t    : $\{Red_font_prefix\}$\{protocol\}$\{Font_color_suffix\}"\
	echo -e " 
\f1 \'bb\'ec\'cf\'fd
\f0 \\t    : $\{Red_font_prefix\}$\{obfs\}$\{Font_color_suffix\}"\
	echo -e " 
\f1 \'c9\'e8\'b1\'b8\'ca\'fd\'cf\'de\'d6\'c6
\f0  : $\{Green_font_prefix\}$\{protocol_param\}$\{Font_color_suffix\}"\
	echo -e " 
\f1 \'b5\'a5\'cf\'df\'b3\'cc\'cf\'de\'cb\'d9
\f0  : $\{Green_font_prefix\}$\{speed_limit_per_con\} KB/S$\{Font_color_suffix\}"\
	echo -e " 
\f1 \'d3\'c3\'bb\'a7\'d7\'dc\'cf\'de\'cb\'d9
\f0  : $\{Green_font_prefix\}$\{speed_limit_per_user\} KB/S$\{Font_color_suffix\}"\
	echo -e " 
\f1 \'bd\'fb\'d6\'b9\'b5\'c4\'b6\'cb\'bf\'da
\f0  : $\{Green_font_prefix\}$\{forbidden_port\} $\{Font_color_suffix\}"\
	echo\
	echo -e " 
\f1 \'d2\'d1\'ca\'b9\'d3\'c3\'c1\'f7\'c1\'bf
\f0  : 
\f1 \'c9\'cf\'b4\'ab
\f0 : $\{Green_font_prefix\}$\{u\}$\{Font_color_suffix\} + 
\f1 \'cf\'c2\'d4\'d8
\f0 : $\{Green_font_prefix\}$\{d\}$\{Font_color_suffix\} = $\{Green_font_prefix\}$\{transfer_enable_Used_2\}$\{Font_color_suffix\}"\
	echo -e " 
\f1 \'ca\'a3\'d3\'e0\'b5\'c4\'c1\'f7\'c1\'bf
\f0  : $\{Green_font_prefix\}$\{transfer_enable_Used\} $\{Font_color_suffix\}"\
	echo -e " 
\f1 \'d3\'c3\'bb\'a7\'d7\'dc\'c1\'f7\'c1\'bf
\f0  : $\{Green_font_prefix\}$\{transfer_enable\} $\{Font_color_suffix\}"\
	echo -e "$\{ss_link\}"\
	echo -e "$\{ssr_link\}"\
	echo -e " $\{Green_font_prefix\} 
\f1 \'cc\'e1\'ca\'be
\f0 : $\{Font_color_suffix\}\
 
\f1 \'d4\'da\'e4\'af\'c0\'c0\'c6\'f7\'d6\'d0\'a3\'ac\'b4\'f2\'bf\'aa\'b6\'fe\'ce\'ac\'c2\'eb\'c1\'b4\'bd\'d3\'a3\'ac\'be\'cd\'bf\'c9\'d2\'d4\'bf\'b4\'b5\'bd\'b6\'fe\'ce\'ac\'c2\'eb\'cd\'bc\'c6\'ac\'a1\'a3
\f0 \
 
\f1 \'d0\'ad\'d2\'e9\'ba\'cd\'bb\'ec\'cf\'fd\'ba\'f3\'c3\'e6\'b5\'c4
\f0 [ _compatible ]
\f1 \'a3\'ac\'d6\'b8\'b5\'c4\'ca\'c7
\f0  
\f1 \'bc\'e6\'c8\'dd\'d4\'ad\'b0\'e6\'d0\'ad\'d2\'e9
\f0 /
\f1 \'bb\'ec\'cf\'fd\'a1\'a3
\f0 "\
	echo && echo "==================================================="\
\}\
# 
\f1 \'c9\'e8\'d6\'c3
\f0  
\f1 \'c5\'e4\'d6\'c3\'d0\'c5\'cf\'a2
\f0 \
Set_config_user()\{\
	echo "
\f1 \'c7\'eb\'ca\'e4\'c8\'eb\'d2\'aa\'c9\'e8\'d6\'c3\'b5\'c4\'d3\'c3\'bb\'a7
\f0  
\f1 \'d3\'c3\'bb\'a7\'c3\'fb
\f0 (
\f1 \'c7\'eb\'ce\'f0\'d6\'d8\'b8\'b4
\f0 , 
\f1 \'d3\'c3\'d3\'da\'c7\'f8\'b7\'d6
\f0 , 
\f1 \'b2\'bb\'d6\'a7\'b3\'d6\'d6\'d0\'ce\'c4
\f0 , 
\f1 \'bb\'e1\'b1\'a8\'b4\'ed
\f0  !)"\
	stty erase '^H' && read -p "(
\f1 \'c4\'ac\'c8\'cf
\f0 : doubi):" ssr_user\
	[[ -z "$\{ssr_user\}" ]] && ssr_user="doubi"\
	echo && echo $\{Separator_1\} && echo -e "	
\f1 \'d3\'c3\'bb\'a7\'c3\'fb
\f0  : $\{Green_font_prefix\}$\{ssr_user\}$\{Font_color_suffix\}" && echo $\{Separator_1\} && echo\
\}\
Set_config_port()\{\
	while true\
	do\
	echo -e "
\f1 \'c7\'eb\'ca\'e4\'c8\'eb\'d2\'aa\'c9\'e8\'d6\'c3\'b5\'c4\'d3\'c3\'bb\'a7
\f0  
\f1 \'b6\'cb\'bf\'da
\f0 (
\f1 \'c7\'eb\'ce\'f0\'d6\'d8\'b8\'b4
\f0 , 
\f1 \'d3\'c3\'d3\'da\'c7\'f8\'b7\'d6
\f0 )"\
	stty erase '^H' && read -p "(
\f1 \'c4\'ac\'c8\'cf
\f0 : 2333):" ssr_port\
	[[ -z "$ssr_port" ]] && ssr_port="2333"\
	expr $\{ssr_port\} + 0 &>/dev/null\
	if [[ $? == 0 ]]; then\
		if [[ $\{ssr_port\} -ge 1 ]] && [[ $\{ssr_port\} -le 65535 ]]; then\
			echo && echo $\{Separator_1\} && echo -e "	
\f1 \'b6\'cb\'bf\'da
\f0  : $\{Green_font_prefix\}$\{ssr_port\}$\{Font_color_suffix\}" && echo $\{Separator_1\} && echo\
			break\
		else\
			echo -e "$\{Error\} 
\f1 \'c7\'eb\'ca\'e4\'c8\'eb\'d5\'fd\'c8\'b7\'b5\'c4\'ca\'fd\'d7\'d6
\f0 (1-65535)"\
		fi\
	else\
		echo -e "$\{Error\} 
\f1 \'c7\'eb\'ca\'e4\'c8\'eb\'d5\'fd\'c8\'b7\'b5\'c4\'ca\'fd\'d7\'d6
\f0 (1-65535)"\
	fi\
	done\
\}\
Set_config_password()\{\
	echo "
\f1 \'c7\'eb\'ca\'e4\'c8\'eb\'d2\'aa\'c9\'e8\'d6\'c3\'b5\'c4\'d3\'c3\'bb\'a7
\f0  
\f1 \'c3\'dc\'c2\'eb
\f0 "\
	stty erase '^H' && read -p "(
\f1 \'c4\'ac\'c8\'cf
\f0 : doub.io):" ssr_password\
	[[ -z "$\{ssr_password\}" ]] && ssr_password="doub.io"\
	echo && echo $\{Separator_1\} && echo -e "	
\f1 \'c3\'dc\'c2\'eb
\f0  : $\{Green_font_prefix\}$\{ssr_password\}$\{Font_color_suffix\}" && echo $\{Separator_1\} && echo\
\}\
Set_config_method()\{\
	echo -e "
\f1 \'c7\'eb\'d1\'a1\'d4\'f1\'d2\'aa\'c9\'e8\'d6\'c3\'b5\'c4\'d3\'c3\'bb\'a7
\f0  
\f1 \'bc\'d3\'c3\'dc\'b7\'bd\'ca\'bd
\f0 \
 $\{Green_font_prefix\} 1.$\{Font_color_suffix\} none\
 $\{Tip\} 
\f1 \'c8\'e7\'b9\'fb\'ca\'b9\'d3\'c3
\f0  auth_chain_* 
\f1 \'cf\'b5\'c1\'d0\'d0\'ad\'d2\'e9\'a3\'ac\'bd\'a8\'d2\'e9\'bc\'d3\'c3\'dc\'b7\'bd\'ca\'bd\'d1\'a1\'d4\'f1
\f0  none (
\f1 \'b8\'c3\'cf\'b5\'c1\'d0\'d0\'ad\'d2\'e9\'d7\'d4\'b4\'f8
\f0  RC4 
\f1 \'bc\'d3\'c3\'dc
\f0 )
\f1 \'a3\'ac\'bb\'ec\'cf\'fd\'cb\'e6\'d2\'e2
\f0 \
 \
 $\{Green_font_prefix\} 2.$\{Font_color_suffix\} rc4\
 $\{Green_font_prefix\} 3.$\{Font_color_suffix\} rc4-md5\
 $\{Green_font_prefix\} 4.$\{Font_color_suffix\} rc4-md5-6\
 \
 $\{Green_font_prefix\} 5.$\{Font_color_suffix\} aes-128-ctr\
 $\{Green_font_prefix\} 6.$\{Font_color_suffix\} aes-192-ctr\
 $\{Green_font_prefix\} 7.$\{Font_color_suffix\} aes-256-ctr\
 \
 $\{Green_font_prefix\} 8.$\{Font_color_suffix\} aes-128-cfb\
 $\{Green_font_prefix\} 9.$\{Font_color_suffix\} aes-192-cfb\
 $\{Green_font_prefix\}10.$\{Font_color_suffix\} aes-256-cfb\
 \
 $\{Green_font_prefix\}11.$\{Font_color_suffix\} aes-128-cfb8\
 $\{Green_font_prefix\}12.$\{Font_color_suffix\} aes-192-cfb8\
 $\{Green_font_prefix\}13.$\{Font_color_suffix\} aes-256-cfb8\
 \
 $\{Green_font_prefix\}14.$\{Font_color_suffix\} salsa20\
 $\{Green_font_prefix\}15.$\{Font_color_suffix\} chacha20\
 $\{Green_font_prefix\}16.$\{Font_color_suffix\} chacha20-ietf\
 $\{Tip\} salsa20/chacha20-*
\f1 \'cf\'b5\'c1\'d0\'bc\'d3\'c3\'dc\'b7\'bd\'ca\'bd\'a3\'ac\'d0\'e8\'d2\'aa\'b6\'ee\'cd\'e2\'b0\'b2\'d7\'b0\'d2\'c0\'c0\'b5
\f0  libsodium 
\f1 \'a3\'ac\'b7\'f1\'d4\'f2\'bb\'e1\'ce\'de\'b7\'a8\'c6\'f4\'b6\'af
\f0 ShadowsocksR !" && echo\
	stty erase '^H' && read -p "(
\f1 \'c4\'ac\'c8\'cf
\f0 : 5. aes-128-ctr):" ssr_method\
	[[ -z "$\{ssr_method\}" ]] && ssr_method="5"\
	if [[ $\{ssr_method\} == "1" ]]; then\
		ssr_method="none"\
	elif [[ $\{ssr_method\} == "2" ]]; then\
		ssr_method="rc4"\
	elif [[ $\{ssr_method\} == "3" ]]; then\
		ssr_method="rc4-md5"\
	elif [[ $\{ssr_method\} == "4" ]]; then\
		ssr_method="rc4-md5-6"\
	elif [[ $\{ssr_method\} == "5" ]]; then\
		ssr_method="aes-128-ctr"\
	elif [[ $\{ssr_method\} == "6" ]]; then\
		ssr_method="aes-192-ctr"\
	elif [[ $\{ssr_method\} == "7" ]]; then\
		ssr_method="aes-256-ctr"\
	elif [[ $\{ssr_method\} == "8" ]]; then\
		ssr_method="aes-128-cfb"\
	elif [[ $\{ssr_method\} == "9" ]]; then\
		ssr_method="aes-192-cfb"\
	elif [[ $\{ssr_method\} == "10" ]]; then\
		ssr_method="aes-256-cfb"\
	elif [[ $\{ssr_method\} == "11" ]]; then\
		ssr_method="aes-128-cfb8"\
	elif [[ $\{ssr_method\} == "12" ]]; then\
		ssr_method="aes-192-cfb8"\
	elif [[ $\{ssr_method\} == "13" ]]; then\
		ssr_method="aes-256-cfb8"\
	elif [[ $\{ssr_method\} == "14" ]]; then\
		ssr_method="salsa20"\
	elif [[ $\{ssr_method\} == "15" ]]; then\
		ssr_method="chacha20"\
	elif [[ $\{ssr_method\} == "16" ]]; then\
		ssr_method="chacha20-ietf"\
	else\
		ssr_method="aes-128-ctr"\
	fi\
	echo && echo $\{Separator_1\} && echo -e "	
\f1 \'bc\'d3\'c3\'dc
\f0  : $\{Green_font_prefix\}$\{ssr_method\}$\{Font_color_suffix\}" && echo $\{Separator_1\} && echo\
\}\
Set_config_protocol()\{\
	echo -e "
\f1 \'c7\'eb\'d1\'a1\'d4\'f1\'d2\'aa\'c9\'e8\'d6\'c3\'b5\'c4\'d3\'c3\'bb\'a7
\f0  
\f1 \'d0\'ad\'d2\'e9\'b2\'e5\'bc\'fe
\f0 \
 $\{Green_font_prefix\}1.$\{Font_color_suffix\} origin\
 $\{Green_font_prefix\}2.$\{Font_color_suffix\} auth_sha1_v4\
 $\{Green_font_prefix\}3.$\{Font_color_suffix\} auth_aes128_md5\
 $\{Green_font_prefix\}4.$\{Font_color_suffix\} auth_aes128_sha1\
 $\{Green_font_prefix\}5.$\{Font_color_suffix\} auth_chain_a\
 $\{Green_font_prefix\}6.$\{Font_color_suffix\} auth_chain_b\
 $\{Tip\} 
\f1 \'c8\'e7\'b9\'fb\'ca\'b9\'d3\'c3
\f0  auth_chain_* 
\f1 \'cf\'b5\'c1\'d0\'d0\'ad\'d2\'e9\'a3\'ac\'bd\'a8\'d2\'e9\'bc\'d3\'c3\'dc\'b7\'bd\'ca\'bd\'d1\'a1\'d4\'f1
\f0  none (
\f1 \'b8\'c3\'cf\'b5\'c1\'d0\'d0\'ad\'d2\'e9\'d7\'d4\'b4\'f8
\f0  RC4 
\f1 \'bc\'d3\'c3\'dc
\f0 )
\f1 \'a3\'ac\'bb\'ec\'cf\'fd\'cb\'e6\'d2\'e2
\f0 " && echo\
	stty erase '^H' && read -p "(
\f1 \'c4\'ac\'c8\'cf
\f0 : 3. auth_aes128_md5):" ssr_protocol\
	[[ -z "$\{ssr_protocol\}" ]] && ssr_protocol="3"\
	if [[ $\{ssr_protocol\} == "1" ]]; then\
		ssr_protocol="origin"\
	elif [[ $\{ssr_protocol\} == "2" ]]; then\
		ssr_protocol="auth_sha1_v4"\
	elif [[ $\{ssr_protocol\} == "3" ]]; then\
		ssr_protocol="auth_aes128_md5"\
	elif [[ $\{ssr_protocol\} == "4" ]]; then\
		ssr_protocol="auth_aes128_sha1"\
	elif [[ $\{ssr_protocol\} == "5" ]]; then\
		ssr_protocol="auth_chain_a"\
	elif [[ $\{ssr_protocol\} == "6" ]]; then\
		ssr_protocol="auth_chain_b"\
	else\
		ssr_protocol="auth_aes128_md5"\
	fi\
	echo && echo $\{Separator_1\} && echo -e "	
\f1 \'d0\'ad\'d2\'e9
\f0  : $\{Green_font_prefix\}$\{ssr_protocol\}$\{Font_color_suffix\}" && echo $\{Separator_1\} && echo\
	if [[ $\{ssr_protocol\} != "origin" ]]; then\
		if [[ $\{ssr_protocol\} == "auth_sha1_v4" ]]; then\
			stty erase '^H' && read -p "
\f1 \'ca\'c7\'b7\'f1\'c9\'e8\'d6\'c3
\f0  
\f1 \'d0\'ad\'d2\'e9\'b2\'e5\'bc\'fe\'bc\'e6\'c8\'dd\'d4\'ad\'b0\'e6
\f0 (_compatible)
\f1 \'a3\'bf
\f0 [Y/n]" ssr_protocol_yn\
			[[ -z "$\{ssr_protocol_yn\}" ]] && ssr_protocol_yn="y"\
			[[ $ssr_protocol_yn == [Yy] ]] && ssr_protocol=$\{ssr_protocol\}"_compatible"\
			echo\
		fi\
	fi\
\}\
Set_config_obfs()\{\
	echo -e "
\f1 \'c7\'eb\'d1\'a1\'d4\'f1\'d2\'aa\'c9\'e8\'d6\'c3\'b5\'c4\'d3\'c3\'bb\'a7
\f0  
\f1 \'bb\'ec\'cf\'fd\'b2\'e5\'bc\'fe
\f0 \
 $\{Green_font_prefix\}1.$\{Font_color_suffix\} plain\
 $\{Green_font_prefix\}2.$\{Font_color_suffix\} http_simple\
 $\{Green_font_prefix\}3.$\{Font_color_suffix\} http_post\
 $\{Green_font_prefix\}4.$\{Font_color_suffix\} random_head\
 $\{Green_font_prefix\}5.$\{Font_color_suffix\} tls1.2_ticket_auth\
 $\{Tip\} 
\f1 \'c8\'e7\'b9\'fb\'ca\'b9\'d3\'c3
\f0  ShadowsocksR 
\f1 \'b4\'fa\'c0\'ed\'d3\'ce\'cf\'b7\'a3\'ac\'bd\'a8\'d2\'e9\'d1\'a1\'d4\'f1
\f0  
\f1 \'bb\'ec\'cf\'fd\'bc\'e6\'c8\'dd\'d4\'ad\'b0\'e6\'bb\'f2
\f0  plain 
\f1 \'bb\'ec\'cf\'fd\'a3\'ac\'c8\'bb\'ba\'f3\'bf\'cd\'bb\'a7\'b6\'cb\'d1\'a1\'d4\'f1
\f0  plain
\f1 \'a3\'ac\'b7\'f1\'d4\'f2\'bb\'e1\'d4\'f6\'bc\'d3\'d1\'d3\'b3\'d9
\f0  !\
 
\f1 \'c1\'ed\'cd\'e2
\f0 , 
\f1 \'c8\'e7\'b9\'fb\'c4\'e3\'d1\'a1\'d4\'f1\'c1\'cb
\f0  tls1.2_ticket_auth
\f1 \'a3\'ac\'c4\'c7\'c3\'b4\'bf\'cd\'bb\'a7\'b6\'cb\'bf\'c9\'d2\'d4\'d1\'a1\'d4\'f1
\f0  tls1.2_ticket_fastauth
\f1 \'a3\'ac\'d5\'e2\'d1\'f9\'bc\'b4\'c4\'dc\'ce\'b1\'d7\'b0\'cc\'d8\'d5\'f7
\f0  
\f1 \'d3\'d6\'b2\'bb\'bb\'e1\'d4\'f6\'bc\'d3\'d1\'d3\'b3\'d9
\f0  !" && echo\
	stty erase '^H' && read -p "(
\f1 \'c4\'ac\'c8\'cf
\f0 : 5. tls1.2_ticket_auth):" ssr_obfs\
	[[ -z "$\{ssr_obfs\}" ]] && ssr_obfs="5"\
	if [[ $\{ssr_obfs\} == "1" ]]; then\
		ssr_obfs="plain"\
	elif [[ $\{ssr_obfs\} == "2" ]]; then\
		ssr_obfs="http_simple"\
	elif [[ $\{ssr_obfs\} == "3" ]]; then\
		ssr_obfs="http_post"\
	elif [[ $\{ssr_obfs\} == "4" ]]; then\
		ssr_obfs="random_head"\
	elif [[ $\{ssr_obfs\} == "5" ]]; then\
		ssr_obfs="tls1.2_ticket_auth"\
	else\
		ssr_obfs="tls1.2_ticket_auth"\
	fi\
	echo && echo $\{Separator_1\} && echo -e "	
\f1 \'bb\'ec\'cf\'fd
\f0  : $\{Green_font_prefix\}$\{ssr_obfs\}$\{Font_color_suffix\}" && echo $\{Separator_1\} && echo\
	if [[ $\{ssr_obfs\} != "plain" ]]; then\
			stty erase '^H' && read -p "
\f1 \'ca\'c7\'b7\'f1\'c9\'e8\'d6\'c3
\f0  
\f1 \'bb\'ec\'cf\'fd\'b2\'e5\'bc\'fe\'bc\'e6\'c8\'dd\'d4\'ad\'b0\'e6
\f0 (_compatible)
\f1 \'a3\'bf
\f0 [Y/n]" ssr_obfs_yn\
			[[ -z "$\{ssr_obfs_yn\}" ]] && ssr_obfs_yn="y"\
			[[ $ssr_obfs_yn == [Yy] ]] && ssr_obfs=$\{ssr_obfs\}"_compatible"\
			echo\
	fi\
\}\
Set_config_protocol_param()\{\
	while true\
	do\
	echo -e "
\f1 \'c7\'eb\'ca\'e4\'c8\'eb\'d2\'aa\'c9\'e8\'d6\'c3\'b5\'c4\'d3\'c3\'bb\'a7
\f0  
\f1 \'d3\'fb\'cf\'de\'d6\'c6\'b5\'c4\'c9\'e8\'b1\'b8\'ca\'fd
\f0  ($\{Green_font_prefix\} auth_* 
\f1 \'cf\'b5\'c1\'d0\'d0\'ad\'d2\'e9
\f0  
\f1 \'b2\'bb\'bc\'e6\'c8\'dd\'d4\'ad\'b0\'e6\'b2\'c5\'d3\'d0\'d0\'a7
\f0  $\{Font_color_suffix\})"\
	echo -e "$\{Tip\} 
\f1 \'c9\'e8\'b1\'b8\'ca\'fd\'cf\'de\'d6\'c6\'a3\'ba\'c3\'bf\'b8\'f6\'b6\'cb\'bf\'da\'cd\'ac\'d2\'bb\'ca\'b1\'bc\'e4\'c4\'dc\'c1\'b4\'bd\'d3\'b5\'c4\'bf\'cd\'bb\'a7\'b6\'cb\'ca\'fd\'c1\'bf
\f0 (
\f1 \'b6\'e0\'b6\'cb\'bf\'da\'c4\'a3\'ca\'bd\'a3\'ac\'c3\'bf\'b8\'f6\'b6\'cb\'bf\'da\'b6\'bc\'ca\'c7\'b6\'c0\'c1\'a2\'bc\'c6\'cb\'e3
\f0 )
\f1 \'a3\'ac\'bd\'a8\'d2\'e9\'d7\'ee\'c9\'d9
\f0  2
\f1 \'b8\'f6\'a1\'a3
\f0 "\
	stty erase '^H' && read -p "(
\f1 \'c4\'ac\'c8\'cf
\f0 : 
\f1 \'ce\'de\'cf\'de
\f0 ):" ssr_protocol_param\
	[[ -z "$ssr_protocol_param" ]] && ssr_protocol_param="" && echo && break\
	expr $\{ssr_protocol_param\} + 0 &>/dev/null\
	if [[ $? == 0 ]]; then\
		if [[ $\{ssr_protocol_param\} -ge 1 ]] && [[ $\{ssr_protocol_param\} -le 9999 ]]; then\
			echo && echo $\{Separator_1\} && echo -e "	
\f1 \'c9\'e8\'b1\'b8\'ca\'fd\'cf\'de\'d6\'c6
\f0  : $\{Green_font_prefix\}$\{ssr_protocol_param\}$\{Font_color_suffix\}" && echo $\{Separator_1\} && echo\
			break\
		else\
			echo -e "$\{Error\} 
\f1 \'c7\'eb\'ca\'e4\'c8\'eb\'d5\'fd\'c8\'b7\'b5\'c4\'ca\'fd\'d7\'d6
\f0 (1-9999)"\
		fi\
	else\
		echo -e "$\{Error\} 
\f1 \'c7\'eb\'ca\'e4\'c8\'eb\'d5\'fd\'c8\'b7\'b5\'c4\'ca\'fd\'d7\'d6
\f0 (1-9999)"\
	fi\
	done\
\}\
Set_config_speed_limit_per_con()\{\
	while true\
	do\
	echo -e "
\f1 \'c7\'eb\'ca\'e4\'c8\'eb\'d2\'aa\'c9\'e8\'d6\'c3\'b5\'c4\'d3\'c3\'bb\'a7
\f0  
\f1 \'b5\'a5\'cf\'df\'b3\'cc
\f0  
\f1 \'cf\'de\'cb\'d9\'c9\'cf\'cf\'de
\f0 (
\f1 \'b5\'a5\'ce\'bb\'a3\'ba
\f0 KB/S)"\
	echo -e "$\{Tip\} 
\f1 \'b5\'a5\'cf\'df\'b3\'cc\'cf\'de\'cb\'d9\'a3\'ba\'c3\'bf\'b8\'f6\'b6\'cb\'bf\'da
\f0  
\f1 \'b5\'a5\'cf\'df\'b3\'cc\'b5\'c4\'cf\'de\'cb\'d9\'c9\'cf\'cf\'de\'a3\'ac\'b6\'e0\'cf\'df\'b3\'cc\'bc\'b4\'ce\'de\'d0\'a7\'a1\'a3
\f0 "\
	stty erase '^H' && read -p "(
\f1 \'c4\'ac\'c8\'cf
\f0 : 
\f1 \'ce\'de\'cf\'de
\f0 ):" ssr_speed_limit_per_con\
	[[ -z "$ssr_speed_limit_per_con" ]] && ssr_speed_limit_per_con=0 && echo && break\
	expr $\{ssr_speed_limit_per_con\} + 0 &>/dev/null\
	if [[ $? == 0 ]]; then\
		if [[ $\{ssr_speed_limit_per_con\} -ge 1 ]] && [[ $\{ssr_speed_limit_per_con\} -le 131072 ]]; then\
			echo && echo $\{Separator_1\} && echo -e "	
\f1 \'b5\'a5\'cf\'df\'b3\'cc\'cf\'de\'cb\'d9
\f0  : $\{Green_font_prefix\}$\{ssr_speed_limit_per_con\} KB/S$\{Font_color_suffix\}" && echo $\{Separator_1\} && echo\
			break\
		else\
			echo -e "$\{Error\} 
\f1 \'c7\'eb\'ca\'e4\'c8\'eb\'d5\'fd\'c8\'b7\'b5\'c4\'ca\'fd\'d7\'d6
\f0 (1-131072)"\
		fi\
	else\
		echo -e "$\{Error\} 
\f1 \'c7\'eb\'ca\'e4\'c8\'eb\'d5\'fd\'c8\'b7\'b5\'c4\'ca\'fd\'d7\'d6
\f0 (1-131072)"\
	fi\
	done\
\}\
Set_config_speed_limit_per_user()\{\
	while true\
	do\
	echo\
	echo -e "
\f1 \'c7\'eb\'ca\'e4\'c8\'eb\'d2\'aa\'c9\'e8\'d6\'c3\'b5\'c4\'d3\'c3\'bb\'a7
\f0  
\f1 \'d7\'dc\'cb\'d9\'b6\'c8
\f0  
\f1 \'cf\'de\'cb\'d9\'c9\'cf\'cf\'de
\f0 (
\f1 \'b5\'a5\'ce\'bb\'a3\'ba
\f0 KB/S)"\
	echo -e "$\{Tip\} 
\f1 \'b6\'cb\'bf\'da\'d7\'dc\'cf\'de\'cb\'d9\'a3\'ba\'c3\'bf\'b8\'f6\'b6\'cb\'bf\'da
\f0  
\f1 \'d7\'dc\'cb\'d9\'b6\'c8
\f0  
\f1 \'cf\'de\'cb\'d9\'c9\'cf\'cf\'de\'a3\'ac\'b5\'a5\'b8\'f6\'b6\'cb\'bf\'da\'d5\'fb\'cc\'e5\'cf\'de\'cb\'d9\'a1\'a3
\f0 "\
	stty erase '^H' && read -p "(
\f1 \'c4\'ac\'c8\'cf
\f0 : 
\f1 \'ce\'de\'cf\'de
\f0 ):" ssr_speed_limit_per_user\
	[[ -z "$ssr_speed_limit_per_user" ]] && ssr_speed_limit_per_user=0 && echo && break\
	expr $\{ssr_speed_limit_per_user\} + 0 &>/dev/null\
	if [[ $? == 0 ]]; then\
		if [[ $\{ssr_speed_limit_per_user\} -ge 1 ]] && [[ $\{ssr_speed_limit_per_user\} -le 131072 ]]; then\
			echo && echo $\{Separator_1\} && echo -e "	
\f1 \'d3\'c3\'bb\'a7\'d7\'dc\'cf\'de\'cb\'d9
\f0  : $\{Green_font_prefix\}$\{ssr_speed_limit_per_user\} KB/S$\{Font_color_suffix\}" && echo $\{Separator_1\} && echo\
			break\
		else\
			echo -e "$\{Error\} 
\f1 \'c7\'eb\'ca\'e4\'c8\'eb\'d5\'fd\'c8\'b7\'b5\'c4\'ca\'fd\'d7\'d6
\f0 (1-131072)"\
		fi\
	else\
		echo -e "$\{Error\} 
\f1 \'c7\'eb\'ca\'e4\'c8\'eb\'d5\'fd\'c8\'b7\'b5\'c4\'ca\'fd\'d7\'d6
\f0 (1-131072)"\
	fi\
	done\
\}\
Set_config_transfer()\{\
	while true\
	do\
	echo\
	echo -e "
\f1 \'c7\'eb\'ca\'e4\'c8\'eb\'d2\'aa\'c9\'e8\'d6\'c3\'b5\'c4\'d3\'c3\'bb\'a7
\f0  
\f1 \'bf\'c9\'ca\'b9\'d3\'c3\'b5\'c4\'d7\'dc\'c1\'f7\'c1\'bf\'c9\'cf\'cf\'de
\f0 (
\f1 \'b5\'a5\'ce\'bb
\f0 : GB, 1-838868 GB)"\
	stty erase '^H' && read -p "(
\f1 \'c4\'ac\'c8\'cf
\f0 : 
\f1 \'ce\'de\'cf\'de
\f0 ):" ssr_transfer\
	[[ -z "$ssr_transfer" ]] && ssr_transfer="838868" && echo && break\
	expr $\{ssr_transfer\} + 0 &>/dev/null\
	if [[ $? == 0 ]]; then\
		if [[ $\{ssr_transfer\} -ge 1 ]] && [[ $\{ssr_transfer\} -le 838868 ]]; then\
			echo && echo $\{Separator_1\} && echo -e "	
\f1 \'d3\'c3\'bb\'a7\'d7\'dc\'c1\'f7\'c1\'bf
\f0  : $\{Green_font_prefix\}$\{ssr_transfer\} GB$\{Font_color_suffix\}" && echo $\{Separator_1\} && echo\
			break\
		else\
			echo -e "$\{Error\} 
\f1 \'c7\'eb\'ca\'e4\'c8\'eb\'d5\'fd\'c8\'b7\'b5\'c4\'ca\'fd\'d7\'d6
\f0 (1-838868)"\
		fi\
	else\
		echo -e "$\{Error\} 
\f1 \'c7\'eb\'ca\'e4\'c8\'eb\'d5\'fd\'c8\'b7\'b5\'c4\'ca\'fd\'d7\'d6
\f0 (1-838868)"\
	fi\
	done\
\}\
Set_config_forbid()\{\
	echo "
\f1 \'c7\'eb\'ca\'e4\'c8\'eb\'d2\'aa\'c9\'e8\'d6\'c3\'b5\'c4\'d3\'c3\'bb\'a7
\f0  
\f1 \'bd\'fb\'d6\'b9\'b7\'c3\'ce\'ca\'b5\'c4\'b6\'cb\'bf\'da
\f0 "\
	echo -e "$\{Tip\} 
\f1 \'bd\'fb\'d6\'b9\'b5\'c4\'b6\'cb\'bf\'da\'a3\'ba\'c0\'fd\'c8\'e7\'b2\'bb\'d4\'ca\'d0\'ed\'b7\'c3\'ce\'ca
\f0  25
\f1 \'b6\'cb\'bf\'da\'a3\'ac\'d3\'c3\'bb\'a7\'be\'cd\'ce\'de\'b7\'a8\'cd\'a8\'b9\'fd
\f0 SSR
\f1 \'b4\'fa\'c0\'ed\'b7\'c3\'ce\'ca
\f0  
\f1 \'d3\'ca\'bc\'fe\'b6\'cb\'bf\'da
\f0 25
\f1 \'c1\'cb\'a3\'ac\'c8\'e7\'b9\'fb\'bd\'fb\'d6\'b9\'c1\'cb
\f0  80,443 
\f1 \'c4\'c7\'c3\'b4\'d3\'c3\'bb\'a7\'bd\'ab\'ce\'de\'b7\'a8\'d5\'fd\'b3\'a3\'b7\'c3\'ce\'ca
\f0  http/https 
\f1 \'cd\'f8\'d5\'be\'a1\'a3
\f0 \

\f1 \'b7\'e2\'bd\'fb\'b5\'a5\'b8\'f6\'b6\'cb\'bf\'da\'b8\'f1\'ca\'bd
\f0 : 25\

\f1 \'b7\'e2\'bd\'fb\'b6\'e0\'b8\'f6\'b6\'cb\'bf\'da\'b8\'f1\'ca\'bd
\f0 : 23,465\

\f1 \'b7\'e2\'bd\'fb
\f0   
\f1 \'b6\'cb\'bf\'da\'b6\'ce\'b8\'f1\'ca\'bd
\f0 : 233-266\

\f1 \'b7\'e2\'bd\'fb\'b6\'e0\'d6\'d6\'b8\'f1\'ca\'bd\'b6\'cb\'bf\'da
\f0 : 25,465,233-666 (
\f1 \'b2\'bb\'b4\'f8\'c3\'b0\'ba\'c5
\f0 :)"\
	stty erase '^H' && read -p "(
\f1 \'c4\'ac\'c8\'cf\'ce\'aa\'bf\'d5
\f0  
\f1 \'b2\'bb\'bd\'fb\'d6\'b9\'b7\'c3\'ce\'ca\'c8\'ce\'ba\'ce\'b6\'cb\'bf\'da
\f0 ):" ssr_forbid\
	[[ -z "$\{ssr_forbid\}" ]] && ssr_forbid=""\
	echo && echo $\{Separator_1\} && echo -e "	
\f1 \'bd\'fb\'d6\'b9\'b5\'c4\'b6\'cb\'bf\'da
\f0  : $\{Green_font_prefix\}$\{ssr_forbid\}$\{Font_color_suffix\}" && echo $\{Separator_1\} && echo\
\}\
Set_config_enable()\{\
	user_total=$(expr $\{user_total\} - 1)\
	for((integer = 0; integer <= $\{user_total\}; integer++))\
	do\
		echo -e "integer=$\{integer\}"\
		port_jq=$($\{jq_file\} ".[$\{integer\}].port" "$\{config_user_mudb_file\}")\
		echo -e "port_jq=$\{port_jq\}"\
		if [[ "$\{ssr_port\}" == "$\{port_jq\}" ]]; then\
			enable=$($\{jq_file\} ".[$\{integer\}].enable" "$\{config_user_mudb_file\}")\
			echo -e "enable=$\{enable\}"\
			[[ "$\{enable\}" == "null" ]] && echo -e "$\{Error\} 
\f1 \'bb\'f1\'c8\'a1\'b5\'b1\'c7\'b0\'b6\'cb\'bf\'da
\f0 [$\{ssr_port\}]
\f1 \'b5\'c4\'bd\'fb\'d3\'c3\'d7\'b4\'cc\'ac\'ca\'a7\'b0\'dc
\f0  !" && exit 1\
			ssr_port_num=$(cat "$\{config_user_mudb_file\}"|grep -n '"port": '$\{ssr_port\}','|awk -F ":" '\{print $1\}')\
			echo -e "ssr_port_num=$\{ssr_port_num\}"\
			[[ "$\{ssr_port_num\}" == "null" ]] && echo -e "$\{Error\} 
\f1 \'bb\'f1\'c8\'a1\'b5\'b1\'c7\'b0\'b6\'cb\'bf\'da
\f0 [$\{ssr_port\}]
\f1 \'b5\'c4\'d0\'d0\'ca\'fd\'ca\'a7\'b0\'dc
\f0  !" && exit 1\
			ssr_enable_num=$(expr $\{ssr_port_num\} - 5)\
			echo -e "ssr_enable_num=$\{ssr_enable_num\}"\
			break\
		fi\
	done\
	if [[ "$\{enable\}" == "1" ]]; then\
		echo -e "
\f1 \'b6\'cb\'bf\'da
\f0  [$\{ssr_port\}] 
\f1 \'b5\'c4\'d5\'cb\'ba\'c5\'d7\'b4\'cc\'ac\'ce\'aa\'a3\'ba
\f0 $\{Green_font_prefix\}
\f1 \'c6\'f4\'d3\'c3
\f0 $\{Font_color_suffix\} , 
\f1 \'ca\'c7\'b7\'f1\'c7\'d0\'bb\'bb\'ce\'aa
\f0  $\{Red_font_prefix\}
\f1 \'bd\'fb\'d3\'c3
\f0 $\{Font_color_suffix\} ?[Y/n]"\
		stty erase '^H' && read -p "(
\f1 \'c4\'ac\'c8\'cf
\f0 : Y):" ssr_enable_yn\
		[[ -z "$\{ssr_enable_yn\}" ]] && ssr_enable_yn="y"\
		if [[ "$\{ssr_enable_yn\}" == [Yy] ]]; then\
			ssr_enable="0"\
		else\
			echo "
\f1 \'c8\'a1\'cf\'fb
\f0 ..." && exit 0\
		fi\
	elif [[ "$\{enable\}" == "0" ]]; then\
		echo -e "
\f1 \'b6\'cb\'bf\'da
\f0  [$\{ssr_port\}] 
\f1 \'b5\'c4\'d5\'cb\'ba\'c5\'d7\'b4\'cc\'ac\'ce\'aa\'a3\'ba
\f0 $\{Green_font_prefix\}
\f1 \'bd\'fb\'d3\'c3
\f0 $\{Font_color_suffix\} , 
\f1 \'ca\'c7\'b7\'f1\'c7\'d0\'bb\'bb\'ce\'aa
\f0  $\{Red_font_prefix\}
\f1 \'c6\'f4\'d3\'c3
\f0 $\{Font_color_suffix\} ?[Y/n]"\
		stty erase '^H' && read -p "(
\f1 \'c4\'ac\'c8\'cf
\f0 : Y):" ssr_enable_yn\
		[[ -z "$\{ssr_enable_yn\}" ]] && ssr_enable_yn = "y"\
		if [[ "$\{ssr_enable_yn\}" == [Yy] ]]; then\
			ssr_enable="1"\
		else\
			echo "
\f1 \'c8\'a1\'cf\'fb
\f0 ..." && exit 0\
		fi\
	else\
		echo -e "$\{Error\} 
\f1 \'b5\'b1\'c7\'b0\'b6\'cb\'bf\'da\'b5\'c4\'bd\'fb\'d3\'c3\'d7\'b4\'cc\'ac\'d2\'ec\'b3\'a3
\f0 [$\{enable\}] !" && exit 1\
	fi\
\}\
Set_user_api_server_pub_addr()\{\
	addr=$1\
	if [[ "$\{addr\}" == "Modify" ]]; then\
		server_pub_addr=$(cat $\{config_user_api_file\}|grep "SERVER_PUB_ADDR = "|awk -F "[']" '\{print $2\}')\
		if [[ -z $\{server_pub_addr\} ]]; then\
			echo -e "$\{Error\} 
\f1 \'bb\'f1\'c8\'a1\'b5\'b1\'c7\'b0\'c5\'e4\'d6\'c3\'b5\'c4
\f0  
\f1 \'b7\'fe\'ce\'f1\'c6\'f7
\f0 IP
\f1 \'bb\'f2\'d3\'f2\'c3\'fb\'ca\'a7\'b0\'dc\'a3\'a1
\f0 " && exit 1\
		else\
			echo -e "$\{Info\} 
\f1 \'b5\'b1\'c7\'b0\'c5\'e4\'d6\'c3\'b5\'c4\'b7\'fe\'ce\'f1\'c6\'f7
\f0 IP
\f1 \'bb\'f2\'d3\'f2\'c3\'fb\'ce\'aa\'a3\'ba
\f0  $\{Green_font_prefix\}$\{server_pub_addr\}$\{Font_color_suffix\}"\
		fi\
	fi\
	echo "
\f1 \'c7\'eb\'ca\'e4\'c8\'eb\'d3\'c3\'bb\'a7\'c5\'e4\'d6\'c3\'d6\'d0\'d2\'aa\'cf\'d4\'ca\'be\'b5\'c4
\f0  
\f1 \'b7\'fe\'ce\'f1\'c6\'f7
\f0 IP
\f1 \'bb\'f2\'d3\'f2\'c3\'fb
\f0  (
\f1 \'b5\'b1\'b7\'fe\'ce\'f1\'c6\'f7\'d3\'d0\'b6\'e0\'b8\'f6
\f0 IP
\f1 \'ca\'b1\'a3\'ac\'bf\'c9\'d2\'d4\'d6\'b8\'b6\'a8\'d3\'c3\'bb\'a7\'c5\'e4\'d6\'c3\'d6\'d0\'cf\'d4\'ca\'be\'b5\'c4
\f0 IP
\f1 \'bb\'f2\'d5\'df\'d3\'f2\'c3\'fb
\f0 )"\
	stty erase '^H' && read -p "(
\f1 \'c4\'ac\'c8\'cf\'d7\'d4\'b6\'af\'bc\'ec\'b2\'e2\'cd\'e2\'cd\'f8
\f0 IP):" ssr_server_pub_addr\
	if [[ -z "$\{ssr_server_pub_addr\}" ]]; then\
		Get_IP\
		if [[ $\{ip\} == "VPS_IP" ]]; then\
			while true\
			do\
			stty erase '^H' && read -p "$\{Error\} 
\f1 \'d7\'d4\'b6\'af\'bc\'ec\'b2\'e2\'cd\'e2\'cd\'f8
\f0 IP
\f1 \'ca\'a7\'b0\'dc\'a3\'ac\'c7\'eb\'ca\'d6\'b6\'af\'ca\'e4\'c8\'eb\'b7\'fe\'ce\'f1\'c6\'f7
\f0 IP
\f1 \'bb\'f2\'d3\'f2\'c3\'fb
\f0 " ssr_server_pub_addr\
			if [[ -z "$ssr_server_pub_addr" ]]; then\
				echo -e "$\{Error\} 
\f1 \'b2\'bb\'c4\'dc\'ce\'aa\'bf\'d5\'a3\'a1
\f0 "\
			else\
				break\
			fi\
			done\
		else\
			ssr_server_pub_addr="$\{ip\}"\
		fi\
	fi\
	echo && echo $\{Separator_1\} && echo -e "	IP
\f1 \'bb\'f2\'d3\'f2\'c3\'fb
\f0  : $\{Green_font_prefix\}$\{ssr_server_pub_addr\}$\{Font_color_suffix\}" && echo $\{Separator_1\} && echo\
\}\
Set_config_all()\{\
	lal=$1\
	if [[ "$\{lal\}" == "Modify" ]]; then\
		Set_config_password\
		Set_config_method\
		Set_config_protocol\
		Set_config_obfs\
		Set_config_protocol_param\
		Set_config_speed_limit_per_con\
		Set_config_speed_limit_per_user\
		Set_config_transfer\
		Set_config_forbid\
	else\
		Set_config_user\
		Set_config_port\
		Set_config_password\
		Set_config_method\
		Set_config_protocol\
		Set_config_obfs\
		Set_config_protocol_param\
		Set_config_speed_limit_per_con\
		Set_config_speed_limit_per_user\
		Set_config_transfer\
		Set_config_forbid\
	fi\
\}\
# 
\f1 \'d0\'de\'b8\'c4
\f0  
\f1 \'c5\'e4\'d6\'c3\'d0\'c5\'cf\'a2
\f0 \
Modify_config_password()\{\
	match_edit=$(python mujson_mgr.py -e -p "$\{ssr_port\}" -k "$\{ssr_password\}"|grep -w "edit user ")\
	if [[ -z "$\{match_edit\}" ]]; then\
		echo -e "$\{Error\} 
\f1 \'d3\'c3\'bb\'a7\'c3\'dc\'c2\'eb\'d0\'de\'b8\'c4\'ca\'a7\'b0\'dc
\f0  $\{Green_font_prefix\}[
\f1 \'b6\'cb\'bf\'da
\f0 : $\{ssr_port\}]$\{Font_color_suffix\} " && exit 1\
	else\
		echo -e "$\{Info\} 
\f1 \'d3\'c3\'bb\'a7\'c3\'dc\'c2\'eb\'d0\'de\'b8\'c4\'b3\'c9\'b9\'a6
\f0  $\{Green_font_prefix\}[
\f1 \'b6\'cb\'bf\'da
\f0 : $\{ssr_port\}]$\{Font_color_suffix\} (
\f1 \'d7\'a2\'d2\'e2\'a3\'ba\'bf\'c9\'c4\'dc\'d0\'e8\'d2\'aa\'ca\'ae\'c3\'eb\'d7\'f3\'d3\'d2\'b2\'c5\'bb\'e1\'d3\'a6\'d3\'c3\'d7\'ee\'d0\'c2\'c5\'e4\'d6\'c3
\f0 )"\
	fi\
\}\
Modify_config_method()\{\
	match_edit=$(python mujson_mgr.py -e -p "$\{ssr_port\}" -m "$\{ssr_method\}"|grep -w "edit user ")\
	if [[ -z "$\{match_edit\}" ]]; then\
		echo -e "$\{Error\} 
\f1 \'d3\'c3\'bb\'a7\'bc\'d3\'c3\'dc\'b7\'bd\'ca\'bd\'d0\'de\'b8\'c4\'ca\'a7\'b0\'dc
\f0  $\{Green_font_prefix\}[
\f1 \'b6\'cb\'bf\'da
\f0 : $\{ssr_port\}]$\{Font_color_suffix\} " && exit 1\
	else\
		echo -e "$\{Info\} 
\f1 \'d3\'c3\'bb\'a7\'bc\'d3\'c3\'dc\'b7\'bd\'ca\'bd\'d0\'de\'b8\'c4\'b3\'c9\'b9\'a6
\f0  $\{Green_font_prefix\}[
\f1 \'b6\'cb\'bf\'da
\f0 : $\{ssr_port\}]$\{Font_color_suffix\} (
\f1 \'d7\'a2\'d2\'e2\'a3\'ba\'bf\'c9\'c4\'dc\'d0\'e8\'d2\'aa\'ca\'ae\'c3\'eb\'d7\'f3\'d3\'d2\'b2\'c5\'bb\'e1\'d3\'a6\'d3\'c3\'d7\'ee\'d0\'c2\'c5\'e4\'d6\'c3
\f0 )"\
	fi\
\}\
Modify_config_protocol()\{\
	match_edit=$(python mujson_mgr.py -e -p "$\{ssr_port\}" -O "$\{ssr_protocol\}"|grep -w "edit user ")\
	if [[ -z "$\{match_edit\}" ]]; then\
		echo -e "$\{Error\} 
\f1 \'d3\'c3\'bb\'a7\'d0\'ad\'d2\'e9\'d0\'de\'b8\'c4\'ca\'a7\'b0\'dc
\f0  $\{Green_font_prefix\}[
\f1 \'b6\'cb\'bf\'da
\f0 : $\{ssr_port\}]$\{Font_color_suffix\} " && exit 1\
	else\
		echo -e "$\{Info\} 
\f1 \'d3\'c3\'bb\'a7\'d0\'ad\'d2\'e9\'d0\'de\'b8\'c4\'b3\'c9\'b9\'a6
\f0  $\{Green_font_prefix\}[
\f1 \'b6\'cb\'bf\'da
\f0 : $\{ssr_port\}]$\{Font_color_suffix\} (
\f1 \'d7\'a2\'d2\'e2\'a3\'ba\'bf\'c9\'c4\'dc\'d0\'e8\'d2\'aa\'ca\'ae\'c3\'eb\'d7\'f3\'d3\'d2\'b2\'c5\'bb\'e1\'d3\'a6\'d3\'c3\'d7\'ee\'d0\'c2\'c5\'e4\'d6\'c3
\f0 )"\
	fi\
\}\
Modify_config_obfs()\{\
	match_edit=$(python mujson_mgr.py -e -p "$\{ssr_port\}" -o "$\{ssr_obfs\}"|grep -w "edit user ")\
	if [[ -z "$\{match_edit\}" ]]; then\
		echo -e "$\{Error\} 
\f1 \'d3\'c3\'bb\'a7\'bb\'ec\'cf\'fd\'d0\'de\'b8\'c4\'ca\'a7\'b0\'dc
\f0  $\{Green_font_prefix\}[
\f1 \'b6\'cb\'bf\'da
\f0 : $\{ssr_port\}]$\{Font_color_suffix\} " && exit 1\
	else\
		echo -e "$\{Info\} 
\f1 \'d3\'c3\'bb\'a7\'bb\'ec\'cf\'fd\'d0\'de\'b8\'c4\'b3\'c9\'b9\'a6
\f0  $\{Green_font_prefix\}[
\f1 \'b6\'cb\'bf\'da
\f0 : $\{ssr_port\}]$\{Font_color_suffix\} (
\f1 \'d7\'a2\'d2\'e2\'a3\'ba\'bf\'c9\'c4\'dc\'d0\'e8\'d2\'aa\'ca\'ae\'c3\'eb\'d7\'f3\'d3\'d2\'b2\'c5\'bb\'e1\'d3\'a6\'d3\'c3\'d7\'ee\'d0\'c2\'c5\'e4\'d6\'c3
\f0 )"\
	fi\
\}\
Modify_config_protocol_param()\{\
	match_edit=$(python mujson_mgr.py -e -p "$\{ssr_port\}" -G "$\{ssr_protocol_param\}"|grep -w "edit user ")\
	if [[ -z "$\{match_edit\}" ]]; then\
		echo -e "$\{Error\} 
\f1 \'d3\'c3\'bb\'a7\'d0\'ad\'d2\'e9\'b2\'ce\'ca\'fd
\f0 (
\f1 \'c9\'e8\'b1\'b8\'ca\'fd\'cf\'de\'d6\'c6
\f0 )
\f1 \'d0\'de\'b8\'c4\'ca\'a7\'b0\'dc
\f0  $\{Green_font_prefix\}[
\f1 \'b6\'cb\'bf\'da
\f0 : $\{ssr_port\}]$\{Font_color_suffix\} " && exit 1\
	else\
		echo -e "$\{Info\} 
\f1 \'d3\'c3\'bb\'a7\'d2\'e9\'b2\'ce\'ca\'fd
\f0 (
\f1 \'c9\'e8\'b1\'b8\'ca\'fd\'cf\'de\'d6\'c6
\f0 )
\f1 \'d0\'de\'b8\'c4\'b3\'c9\'b9\'a6
\f0  $\{Green_font_prefix\}[
\f1 \'b6\'cb\'bf\'da
\f0 : $\{ssr_port\}]$\{Font_color_suffix\} (
\f1 \'d7\'a2\'d2\'e2\'a3\'ba\'bf\'c9\'c4\'dc\'d0\'e8\'d2\'aa\'ca\'ae\'c3\'eb\'d7\'f3\'d3\'d2\'b2\'c5\'bb\'e1\'d3\'a6\'d3\'c3\'d7\'ee\'d0\'c2\'c5\'e4\'d6\'c3
\f0 )"\
	fi\
\}\
Modify_config_speed_limit_per_con()\{\
	match_edit=$(python mujson_mgr.py -e -p "$\{ssr_port\}" -s "$\{ssr_speed_limit_per_con\}"|grep -w "edit user ")\
	if [[ -z "$\{match_edit\}" ]]; then\
		echo -e "$\{Error\} 
\f1 \'d3\'c3\'bb\'a7\'b5\'a5\'cf\'df\'b3\'cc\'cf\'de\'cb\'d9\'d0\'de\'b8\'c4\'ca\'a7\'b0\'dc
\f0  $\{Green_font_prefix\}[
\f1 \'b6\'cb\'bf\'da
\f0 : $\{ssr_port\}]$\{Font_color_suffix\} " && exit 1\
	else\
		echo -e "$\{Info\} 
\f1 \'d3\'c3\'bb\'a7\'b5\'a5\'cf\'df\'b3\'cc\'cf\'de\'cb\'d9\'d0\'de\'b8\'c4\'b3\'c9\'b9\'a6
\f0  $\{Green_font_prefix\}[
\f1 \'b6\'cb\'bf\'da
\f0 : $\{ssr_port\}]$\{Font_color_suffix\} (
\f1 \'d7\'a2\'d2\'e2\'a3\'ba\'bf\'c9\'c4\'dc\'d0\'e8\'d2\'aa\'ca\'ae\'c3\'eb\'d7\'f3\'d3\'d2\'b2\'c5\'bb\'e1\'d3\'a6\'d3\'c3\'d7\'ee\'d0\'c2\'c5\'e4\'d6\'c3
\f0 )"\
	fi\
\}\
Modify_config_speed_limit_per_user()\{\
	match_edit=$(python mujson_mgr.py -e -p "$\{ssr_port\}" -S "$\{ssr_speed_limit_per_user\}"|grep -w "edit user ")\
	if [[ -z "$\{match_edit\}" ]]; then\
		echo -e "$\{Error\} 
\f1 \'d3\'c3\'bb\'a7\'b6\'cb\'bf\'da\'d7\'dc\'cf\'de\'cb\'d9\'d0\'de\'b8\'c4\'ca\'a7\'b0\'dc
\f0  $\{Green_font_prefix\}[
\f1 \'b6\'cb\'bf\'da
\f0 : $\{ssr_port\}]$\{Font_color_suffix\} " && exit 1\
	else\
		echo -e "$\{Info\} 
\f1 \'d3\'c3\'bb\'a7\'b6\'cb\'bf\'da\'d7\'dc\'cf\'de\'cb\'d9\'d0\'de\'b8\'c4\'b3\'c9\'b9\'a6
\f0  $\{Green_font_prefix\}[
\f1 \'b6\'cb\'bf\'da
\f0 : $\{ssr_port\}]$\{Font_color_suffix\} (
\f1 \'d7\'a2\'d2\'e2\'a3\'ba\'bf\'c9\'c4\'dc\'d0\'e8\'d2\'aa\'ca\'ae\'c3\'eb\'d7\'f3\'d3\'d2\'b2\'c5\'bb\'e1\'d3\'a6\'d3\'c3\'d7\'ee\'d0\'c2\'c5\'e4\'d6\'c3
\f0 )"\
	fi\
\}\
Modify_config_connect_verbose_info()\{\
	sed -i 's/"connect_verbose_info": '"$(echo $\{connect_verbose_info\})"',/"connect_verbose_info": '"$(echo $\{ssr_connect_verbose_info\})"',/g' $\{config_user_file\}\
\}\
Modify_config_transfer()\{\
	match_edit=$(python mujson_mgr.py -e -p "$\{ssr_port\}" -t "$\{ssr_transfer\}"|grep -w "edit user ")\
	if [[ -z "$\{match_edit\}" ]]; then\
		echo -e "$\{Error\} 
\f1 \'d3\'c3\'bb\'a7\'d7\'dc\'c1\'f7\'c1\'bf\'d0\'de\'b8\'c4\'ca\'a7\'b0\'dc
\f0  $\{Green_font_prefix\}[
\f1 \'b6\'cb\'bf\'da
\f0 : $\{ssr_port\}]$\{Font_color_suffix\} " && exit 1\
	else\
		echo -e "$\{Info\} 
\f1 \'d3\'c3\'bb\'a7\'d7\'dc\'c1\'f7\'c1\'bf\'d0\'de\'b8\'c4\'b3\'c9\'b9\'a6
\f0  $\{Green_font_prefix\}[
\f1 \'b6\'cb\'bf\'da
\f0 : $\{ssr_port\}]$\{Font_color_suffix\} (
\f1 \'d7\'a2\'d2\'e2\'a3\'ba\'bf\'c9\'c4\'dc\'d0\'e8\'d2\'aa\'ca\'ae\'c3\'eb\'d7\'f3\'d3\'d2\'b2\'c5\'bb\'e1\'d3\'a6\'d3\'c3\'d7\'ee\'d0\'c2\'c5\'e4\'d6\'c3
\f0 )"\
	fi\
\}\
Modify_config_forbid()\{\
	match_edit=$(python mujson_mgr.py -e -p "$\{ssr_port\}" -f "$\{ssr_forbid\}"|grep -w "edit user ")\
	if [[ -z "$\{match_edit\}" ]]; then\
		echo -e "$\{Error\} 
\f1 \'d3\'c3\'bb\'a7\'bd\'fb\'d6\'b9\'b7\'c3\'ce\'ca\'b6\'cb\'bf\'da\'d0\'de\'b8\'c4\'ca\'a7\'b0\'dc
\f0  $\{Green_font_prefix\}[
\f1 \'b6\'cb\'bf\'da
\f0 : $\{ssr_port\}]$\{Font_color_suffix\} " && exit 1\
	else\
		echo -e "$\{Info\} 
\f1 \'d3\'c3\'bb\'a7\'bd\'fb\'d6\'b9\'b7\'c3\'ce\'ca\'b6\'cb\'bf\'da\'d0\'de\'b8\'c4\'b3\'c9\'b9\'a6
\f0  $\{Green_font_prefix\}[
\f1 \'b6\'cb\'bf\'da
\f0 : $\{ssr_port\}]$\{Font_color_suffix\} (
\f1 \'d7\'a2\'d2\'e2\'a3\'ba\'bf\'c9\'c4\'dc\'d0\'e8\'d2\'aa\'ca\'ae\'c3\'eb\'d7\'f3\'d3\'d2\'b2\'c5\'bb\'e1\'d3\'a6\'d3\'c3\'d7\'ee\'d0\'c2\'c5\'e4\'d6\'c3
\f0 )"\
	fi\
\}\
Modify_config_enable()\{\
	sed -i "$\{ssr_enable_num\}"'s/"enable": '"$(echo $\{enable\})"',/"enable": '"$(echo $\{ssr_enable\})"',/' $\{config_user_mudb_file\}\
\}\
Modify_user_api_server_pub_addr()\{\
	sed -i "s/SERVER_PUB_ADDR = '$\{server_pub_addr\}'/SERVER_PUB_ADDR = '$\{ssr_server_pub_addr\}'/" $\{config_user_api_file\}\
\}\
Modify_config_all()\{\
	Modify_config_password\
	Modify_config_method\
	Modify_config_protocol\
	Modify_config_obfs\
	Modify_config_protocol_param\
	Modify_config_speed_limit_per_con\
	Modify_config_speed_limit_per_user\
	Modify_config_transfer\
	Modify_config_forbid\
\}\
Check_python()\{\
	python_ver=`python -h`\
	if [[ -z $\{python_ver\} ]]; then\
		echo -e "$\{Info\} 
\f1 \'c3\'bb\'d3\'d0\'b0\'b2\'d7\'b0
\f0 Python
\f1 \'a3\'ac\'bf\'aa\'ca\'bc\'b0\'b2\'d7\'b0
\f0 ..."\
		if [[ $\{release\} == "centos" ]]; then\
			yum install -y python\
		else\
			apt-get install -y python\
		fi\
	fi\
\}\
Centos_yum()\{\
	yum update\
	cat /etc/redhat-release |grep 7\\..*|grep -i centos>/dev/null\
	if [[ $? = 0 ]]; then\
		yum install -y vim unzip crond net-tools\
	else\
		yum install -y vim unzip crond\
	fi\
\}\
Debian_apt()\{\
	apt-get update\
	cat /etc/issue |grep 9\\..*>/dev/null\
	if [[ $? = 0 ]]; then\
		apt-get install -y vim unzip cron net-tools\
	else\
		apt-get install -y vim unzip cron\
	fi\
\}\
# 
\f1 \'cf\'c2\'d4\'d8
\f0  ShadowsocksR\
Download_SSR()\{\
	cd "/usr/local"\
	wget -N --no-check-certificate "https://github.com/ToyoDAdoubi/shadowsocksr/archive/manyuser.zip"\
	#git config --global http.sslVerify false\
	#env GIT_SSL_NO_VERIFY=true git clone -b manyuser https://github.com/ToyoDAdoubi/shadowsocksr.git\
	#[[ ! -e $\{ssr_folder\} ]] && echo -e "$\{Error\} ShadowsocksR
\f1 \'b7\'fe\'ce\'f1\'b6\'cb
\f0  
\f1 \'cf\'c2\'d4\'d8\'ca\'a7\'b0\'dc
\f0  !" && exit 1\
	[[ ! -e "manyuser.zip" ]] && echo -e "$\{Error\} ShadowsocksR
\f1 \'b7\'fe\'ce\'f1\'b6\'cb
\f0  
\f1 \'d1\'b9\'cb\'f5\'b0\'fc
\f0  
\f1 \'cf\'c2\'d4\'d8\'ca\'a7\'b0\'dc
\f0  !" && rm -rf manyuser.zip && exit 1\
	unzip "manyuser.zip"\
	[[ ! -e "/usr/local/shadowsocksr-manyuser/" ]] && echo -e "$\{Error\} ShadowsocksR
\f1 \'b7\'fe\'ce\'f1\'b6\'cb
\f0  
\f1 \'bd\'e2\'d1\'b9\'ca\'a7\'b0\'dc
\f0  !" && rm -rf manyuser.zip && exit 1\
	mv "/usr/local/shadowsocksr-manyuser/" "/usr/local/shadowsocksr/"\
	[[ ! -e "/usr/local/shadowsocksr/" ]] && echo -e "$\{Error\} ShadowsocksR
\f1 \'b7\'fe\'ce\'f1\'b6\'cb
\f0  
\f1 \'d6\'d8\'c3\'fc\'c3\'fb\'ca\'a7\'b0\'dc
\f0  !" && rm -rf manyuser.zip && rm -rf "/usr/local/shadowsocksr-manyuser/" && exit 1\
	rm -rf manyuser.zip\
	cd "shadowsocksr"\
	cp "$\{ssr_folder\}/config.json" "$\{config_user_file\}"\
	cp "$\{ssr_folder\}/mysql.json" "$\{ssr_folder\}/usermysql.json"\
	cp "$\{ssr_folder\}/apiconfig.py" "$\{config_user_api_file\}"\
	[[ ! -e $\{config_user_api_file\} ]] && echo -e "$\{Error\} ShadowsocksR
\f1 \'b7\'fe\'ce\'f1\'b6\'cb
\f0  apiconfig.py 
\f1 \'b8\'b4\'d6\'c6\'ca\'a7\'b0\'dc
\f0  !" && exit 1\
	sed -i "s/API_INTERFACE = 'sspanelv2'/API_INTERFACE = 'mudbjson'/" $\{config_user_api_file\}\
	server_pub_addr="127.0.0.1"\
	Modify_user_api_server_pub_addr\
	#sed -i "s/SERVER_PUB_ADDR = '127.0.0.1'/SERVER_PUB_ADDR = '$\{ip\}'/" $\{config_user_api_file\}\
	sed -i 's/ \\/\\/ only works under multi-user mode//g' "$\{config_user_file\}"\
	echo -e "$\{Info\} ShadowsocksR
\f1 \'b7\'fe\'ce\'f1\'b6\'cb
\f0  
\f1 \'cf\'c2\'d4\'d8\'cd\'ea\'b3\'c9
\f0  !"\
\}\
Service_SSR()\{\
	if [[ $\{release\} = "centos" ]]; then\
		if ! wget --no-check-certificate https://raw.githubusercontent.com/ToyoDAdoubi/doubi/master/other/ssrmu_centos -O /etc/init.d/ssrmu; then\
			echo -e "$\{Error\} ShadowsocksR
\f1 \'b7\'fe\'ce\'f1
\f0  
\f1 \'b9\'dc\'c0\'ed\'bd\'c5\'b1\'be\'cf\'c2\'d4\'d8\'ca\'a7\'b0\'dc
\f0  !" && exit 1\
		fi\
		chmod +x /etc/init.d/ssrmu\
		chkconfig --add ssrmu\
		chkconfig ssrmu on\
	else\
		if ! wget --no-check-certificate https://raw.githubusercontent.com/ToyoDAdoubi/doubi/master/other/ssrmu_debian -O /etc/init.d/ssrmu; then\
			echo -e "$\{Error\} ShadowsocksR
\f1 \'b7\'fe\'ce\'f1
\f0  
\f1 \'b9\'dc\'c0\'ed\'bd\'c5\'b1\'be\'cf\'c2\'d4\'d8\'ca\'a7\'b0\'dc
\f0  !" && exit 1\
		fi\
		chmod +x /etc/init.d/ssrmu\
		update-rc.d -f ssrmu defaults\
	fi\
	echo -e "$\{Info\} ShadowsocksR
\f1 \'b7\'fe\'ce\'f1
\f0  
\f1 \'b9\'dc\'c0\'ed\'bd\'c5\'b1\'be\'cf\'c2\'d4\'d8\'cd\'ea\'b3\'c9
\f0  !"\
\}\
# 
\f1 \'b0\'b2\'d7\'b0
\f0  JQ
\f1 \'bd\'e2\'ce\'f6\'c6\'f7
\f0 \
JQ_install()\{\
	if [[ ! -e $\{jq_file\} ]]; then\
		cd "$\{ssr_folder\}"\
		if [[ $\{bit\} = "x86_64" ]]; then\
			mv "jq-linux64" "jq"\
			#wget --no-check-certificate "https://github.com/stedolan/jq/releases/download/jq-1.5/jq-linux64" -O $\{jq_file\}\
		else\
			mv "jq-linux32" "jq"\
			#wget --no-check-certificate "https://github.com/stedolan/jq/releases/download/jq-1.5/jq-linux32" -O $\{jq_file\}\
		fi\
		[[ ! -e $\{jq_file\} ]] && echo -e "$\{Error\} JQ
\f1 \'bd\'e2\'ce\'f6\'c6\'f7
\f0  
\f1 \'d6\'d8\'c3\'fc\'c3\'fb\'ca\'a7\'b0\'dc\'a3\'ac\'c7\'eb\'bc\'ec\'b2\'e9
\f0  !" && exit 1\
		chmod +x $\{jq_file\}\
		echo -e "$\{Info\} JQ
\f1 \'bd\'e2\'ce\'f6\'c6\'f7
\f0  
\f1 \'b0\'b2\'d7\'b0\'cd\'ea\'b3\'c9\'a3\'ac\'bc\'cc\'d0\'f8
\f0 ..." \
	else\
		echo -e "$\{Info\} JQ
\f1 \'bd\'e2\'ce\'f6\'c6\'f7
\f0  
\f1 \'d2\'d1\'b0\'b2\'d7\'b0\'a3\'ac\'bc\'cc\'d0\'f8
\f0 ..."\
	fi\
\}\
# 
\f1 \'b0\'b2\'d7\'b0
\f0  
\f1 \'d2\'c0\'c0\'b5
\f0 \
Installation_dependency()\{\
	if [[ $\{release\} == "centos" ]]; then\
		Centos_yum\
	else\
		Debian_apt\
	fi\
	[[ ! -e "/usr/bin/unzip" ]] && echo -e "$\{Error\} 
\f1 \'d2\'c0\'c0\'b5
\f0  unzip(
\f1 \'bd\'e2\'d1\'b9\'d1\'b9\'cb\'f5\'b0\'fc
\f0 ) 
\f1 \'b0\'b2\'d7\'b0\'ca\'a7\'b0\'dc\'a3\'ac\'b6\'e0\'b0\'eb\'ca\'c7\'c8\'ed\'bc\'fe\'b0\'fc\'d4\'b4\'b5\'c4\'ce\'ca\'cc\'e2\'a3\'ac\'c7\'eb\'bc\'ec\'b2\'e9
\f0  !" && exit 1\
	Check_python\
	#echo "nameserver 8.8.8.8" > /etc/resolv.conf\
	#echo "nameserver 8.8.4.4" >> /etc/resolv.conf\
	cp -f /usr/share/zoneinfo/Asia/Shanghai /etc/localtime\
	if [[ $\{release\} == "centos" ]]; then\
		/etc/init.d/crond restart\
	else\
		/etc/init.d/cron restart\
	fi\
\}\
Install_SSR()\{\
	check_root\
	[[ -e $\{ssr_folder\} ]] && echo -e "$\{Error\} ShadowsocksR 
\f1 \'ce\'c4\'bc\'fe\'bc\'d0\'d2\'d1\'b4\'e6\'d4\'da\'a3\'ac\'c7\'eb\'bc\'ec\'b2\'e9
\f0 ( 
\f1 \'c8\'e7\'b0\'b2\'d7\'b0\'ca\'a7\'b0\'dc\'bb\'f2\'d5\'df\'b4\'e6\'d4\'da\'be\'c9\'b0\'e6\'b1\'be\'a3\'ac\'c7\'eb\'cf\'c8\'d0\'b6\'d4\'d8
\f0  ) !" && exit 1\
	echo -e "$\{Info\} 
\f1 \'bf\'aa\'ca\'bc\'c9\'e8\'d6\'c3
\f0  ShadowsocksR
\f1 \'d5\'cb\'ba\'c5\'c5\'e4\'d6\'c3
\f0 ..."\
	Set_user_api_server_pub_addr\
	Set_config_all\
	echo -e "$\{Info\} 
\f1 \'bf\'aa\'ca\'bc\'b0\'b2\'d7\'b0
\f0 /
\f1 \'c5\'e4\'d6\'c3
\f0  ShadowsocksR
\f1 \'d2\'c0\'c0\'b5
\f0 ..."\
	Installation_dependency\
	echo -e "$\{Info\} 
\f1 \'bf\'aa\'ca\'bc\'cf\'c2\'d4\'d8
\f0 /
\f1 \'b0\'b2\'d7\'b0
\f0  ShadowsocksR
\f1 \'ce\'c4\'bc\'fe
\f0 ..."\
	Download_SSR\
	echo -e "$\{Info\} 
\f1 \'bf\'aa\'ca\'bc\'cf\'c2\'d4\'d8
\f0 /
\f1 \'b0\'b2\'d7\'b0
\f0  ShadowsocksR
\f1 \'b7\'fe\'ce\'f1\'bd\'c5\'b1\'be
\f0 (init)..."\
	Service_SSR\
	echo -e "$\{Info\} 
\f1 \'bf\'aa\'ca\'bc\'cf\'c2\'d4\'d8
\f0 /
\f1 \'b0\'b2\'d7\'b0
\f0  JSNO
\f1 \'bd\'e2\'ce\'f6\'c6\'f7
\f0  JQ..."\
	JQ_install\
	echo -e "$\{Info\} 
\f1 \'bf\'aa\'ca\'bc\'cc\'ed\'bc\'d3\'b3\'f5\'ca\'bc\'d3\'c3\'bb\'a7
\f0 ..."\
	Add_port_user "install"\
	echo -e "$\{Info\} 
\f1 \'bf\'aa\'ca\'bc\'c9\'e8\'d6\'c3
\f0  iptables
\f1 \'b7\'c0\'bb\'f0\'c7\'bd
\f0 ..."\
	Set_iptables\
	echo -e "$\{Info\} 
\f1 \'bf\'aa\'ca\'bc\'cc\'ed\'bc\'d3
\f0  iptables
\f1 \'b7\'c0\'bb\'f0\'c7\'bd\'b9\'e6\'d4\'f2
\f0 ..."\
	Add_iptables\
	echo -e "$\{Info\} 
\f1 \'bf\'aa\'ca\'bc\'b1\'a3\'b4\'e6
\f0  iptables
\f1 \'b7\'c0\'bb\'f0\'c7\'bd\'b9\'e6\'d4\'f2
\f0 ..."\
	Save_iptables\
	echo -e "$\{Info\} 
\f1 \'cb\'f9\'d3\'d0\'b2\'bd\'d6\'e8
\f0  
\f1 \'b0\'b2\'d7\'b0\'cd\'ea\'b1\'cf\'a3\'ac\'bf\'aa\'ca\'bc\'c6\'f4\'b6\'af
\f0  ShadowsocksR
\f1 \'b7\'fe\'ce\'f1\'b6\'cb
\f0 ..."\
	Start_SSR\
	Get_User_info "$\{ssr_port\}"\
	View_User_info\
\}\
Update_SSR()\{\
	SSR_installation_status\
	echo -e "
\f1 \'d2\'f2\'c6\'c6\'cd\'de\'d4\'dd\'cd\'a3\'b8\'fc\'d0\'c2
\f0 ShadowsocksR
\f1 \'b7\'fe\'ce\'f1\'b6\'cb\'a3\'ac\'cb\'f9\'d2\'d4\'b4\'cb\'b9\'a6\'c4\'dc\'c1\'d9\'ca\'b1\'bd\'fb\'d3\'c3\'a1\'a3
\f0 "\
	#cd $\{ssr_folder\}\
	#git pull\
	#Restart_SSR\
\}\
Uninstall_SSR()\{\
	[[ ! -e $\{ssr_folder\} ]] && echo -e "$\{Error\} 
\f1 \'c3\'bb\'d3\'d0\'b0\'b2\'d7\'b0
\f0  ShadowsocksR
\f1 \'a3\'ac\'c7\'eb\'bc\'ec\'b2\'e9
\f0  !" && exit 1\
	echo "
\f1 \'c8\'b7\'b6\'a8\'d2\'aa
\f0  
\f1 \'d0\'b6\'d4\'d8
\f0 ShadowsocksR
\f1 \'a3\'bf
\f0 [y/N]" && echo\
	stty erase '^H' && read -p "(
\f1 \'c4\'ac\'c8\'cf
\f0 : n):" unyn\
	[[ -z $\{unyn\} ]] && unyn="n"\
	if [[ $\{unyn\} == [Yy] ]]; then\
		check_pid\
		[[ ! -z "$\{PID\}" ]] && kill -9 $\{PID\}\
		user_info=$(python mujson_mgr.py -l)\
		user_total=$(echo "$\{user_info\}"|wc -l)\
		if [[ ! -z $\{user_info\} ]]; then\
			for((integer = 1; integer <= $\{user_total\}; integer++))\
			do\
				port=$(echo "$\{user_info\}"|sed -n "$\{integer\}p"|awk '\{print $4\}')\
				Del_iptables\
			done\
		fi\
		if [[ $\{release\} = "centos" ]]; then\
			chkconfig --del ssrmu\
		else\
			update-rc.d -f ssrmu remove\
		fi\
		rm -rf $\{ssr_folder\} && rm -rf /etc/init.d/ssrmu\
		echo && echo " ShadowsocksR 
\f1 \'d0\'b6\'d4\'d8\'cd\'ea\'b3\'c9
\f0  !" && echo\
	else\
		echo && echo " 
\f1 \'d0\'b6\'d4\'d8\'d2\'d1\'c8\'a1\'cf\'fb
\f0 ..." && echo\
	fi\
\}\
Check_Libsodium_ver()\{\
	echo -e "$\{Info\} 
\f1 \'bf\'aa\'ca\'bc\'bb\'f1\'c8\'a1
\f0  libsodium 
\f1 \'d7\'ee\'d0\'c2\'b0\'e6\'b1\'be
\f0 ..."\
	Libsodiumr_ver=$(wget -qO- "https://github.com/jedisct1/libsodium/tags"|grep "/jedisct1/libsodium/releases/tag/"|head -1|sed -r 's/.*tag\\/(.+)\\">.*/\\1/')\
	[[ -z $\{Libsodiumr_ver\} ]] && Libsodiumr_ver=$\{Libsodiumr_ver_backup\}\
	echo -e "$\{Info\} libsodium 
\f1 \'d7\'ee\'d0\'c2\'b0\'e6\'b1\'be\'ce\'aa
\f0  $\{Green_font_prefix\}$\{Libsodiumr_ver\}$\{Font_color_suffix\} !"\
\}\
Install_Libsodium()\{\
	if [[ -e $\{Libsodiumr_file\} ]]; then\
		echo -e "$\{Error\} libsodium 
\f1 \'d2\'d1\'b0\'b2\'d7\'b0
\f0  , 
\f1 \'ca\'c7\'b7\'f1\'b8\'b2\'b8\'c7\'b0\'b2\'d7\'b0
\f0 (
\f1 \'b8\'fc\'d0\'c2
\f0 )
\f1 \'a3\'bf
\f0 [y/N]"\
		stty erase '^H' && read -p "(
\f1 \'c4\'ac\'c8\'cf
\f0 : n):" yn\
		[[ -z $\{yn\} ]] && yn="n"\
		if [[ $\{yn\} == [Nn] ]]; then\
			echo "
\f1 \'d2\'d1\'c8\'a1\'cf\'fb
\f0 ..." && exit 1\
		fi\
	else\
		echo -e "$\{Info\} libsodium 
\f1 \'ce\'b4\'b0\'b2\'d7\'b0\'a3\'ac\'bf\'aa\'ca\'bc\'b0\'b2\'d7\'b0
\f0 ..."\
	fi\
	Check_Libsodium_ver\
	if [[ $\{release\} == "centos" ]]; then\
		yum update\
		echo -e "$\{Info\} 
\f1 \'b0\'b2\'d7\'b0\'d2\'c0\'c0\'b5
\f0 ..."\
		yum -y groupinstall "Development Tools"\
		echo -e "$\{Info\} 
\f1 \'cf\'c2\'d4\'d8
\f0 ..."\
		wget  --no-check-certificate -N "https://github.com/jedisct1/libsodium/releases/download/$\{Libsodiumr_ver\}/libsodium-$\{Libsodiumr_ver\}.tar.gz"\
		echo -e "$\{Info\} 
\f1 \'bd\'e2\'d1\'b9
\f0 ..."\
		tar -xzf libsodium-$\{Libsodiumr_ver\}.tar.gz && cd libsodium-$\{Libsodiumr_ver\}\
		echo -e "$\{Info\} 
\f1 \'b1\'e0\'d2\'eb\'b0\'b2\'d7\'b0
\f0 ..."\
		./configure --disable-maintainer-mode && make -j2 && make install\
		echo /usr/local/lib > /etc/ld.so.conf.d/usr_local_lib.conf\
	else\
		apt-get update\
		echo -e "$\{Info\} 
\f1 \'b0\'b2\'d7\'b0\'d2\'c0\'c0\'b5
\f0 ..."\
		apt-get install -y build-essential\
		echo -e "$\{Info\} 
\f1 \'cf\'c2\'d4\'d8
\f0 ..."\
		wget  --no-check-certificate -N "https://github.com/jedisct1/libsodium/releases/download/$\{Libsodiumr_ver\}/libsodium-$\{Libsodiumr_ver\}.tar.gz"\
		echo -e "$\{Info\} 
\f1 \'bd\'e2\'d1\'b9
\f0 ..."\
		tar -xzf libsodium-$\{Libsodiumr_ver\}.tar.gz && cd libsodium-$\{Libsodiumr_ver\}\
		echo -e "$\{Info\} 
\f1 \'b1\'e0\'d2\'eb\'b0\'b2\'d7\'b0
\f0 ..."\
		./configure --disable-maintainer-mode && make -j2 && make install\
	fi\
	ldconfig\
	cd .. && rm -rf libsodium-$\{Libsodiumr_ver\}.tar.gz && rm -rf libsodium-$\{Libsodiumr_ver\}\
	[[ ! -e $\{Libsodiumr_file\} ]] && echo -e "$\{Error\} libsodium 
\f1 \'b0\'b2\'d7\'b0\'ca\'a7\'b0\'dc
\f0  !" && exit 1\
	echo && echo -e "$\{Info\} libsodium 
\f1 \'b0\'b2\'d7\'b0\'b3\'c9\'b9\'a6
\f0  !" && echo\
\}\
# 
\f1 \'cf\'d4\'ca\'be
\f0  
\f1 \'c1\'ac\'bd\'d3\'d0\'c5\'cf\'a2
\f0 \
debian_View_user_connection_info()\{\
	format_1=$1\
	user_info=$(python mujson_mgr.py -l)\
	user_total=$(echo "$\{user_info\}"|wc -l)\
	[[ -z $\{user_info\} ]] && echo -e "$\{Error\} 
\f1 \'c3\'bb\'d3\'d0\'b7\'a2\'cf\'d6
\f0  
\f1 \'d3\'c3\'bb\'a7\'a3\'ac\'c7\'eb\'bc\'ec\'b2\'e9
\f0  !" && exit 1\
	IP_total=`netstat -anp |grep 'ESTABLISHED' |grep 'python' |grep 'tcp6' |awk '\{print $5\}' |awk -F ":" '\{print $1\}' |sort -u |wc -l`\
	user_list_all=""\
	for((integer = 1; integer <= $\{user_total\}; integer++))\
	do\
		user_port=$(echo "$\{user_info\}"|sed -n "$\{integer\}p"|awk '\{print $4\}')\
		user_IP_1=`netstat -anp |grep 'ESTABLISHED' |grep 'python' |grep 'tcp6' |grep ":$\{user_port\} " |awk '\{print $5\}' |awk -F ":" '\{print $1\}' |sort -u`\
		if [[ -z $\{user_IP_1\} ]]; then\
			user_IP_total="0"\
		else\
			user_IP_total=`echo -e "$\{user_IP_1\}"|wc -l`\
			if [[ $\{format_1\} == "IP_address" ]]; then\
				get_IP_address\
			else\
				user_IP=`echo -e "\\n$\{user_IP_1\}"`\
			fi\
		fi\
		user_info_233=$(python mujson_mgr.py -l|grep -w "$\{user_port\}"|awk '\{print $2\}'|sed 's/\\[//g;s/\\]//g')\
		user_list_all=$\{user_list_all\}"
\f1 \'d3\'c3\'bb\'a7\'c3\'fb
\f0 : $\{Green_font_prefix\}"$\{user_info_233\}"$\{Font_color_suffix\}\\t 
\f1 \'b6\'cb\'bf\'da
\f0 : $\{Green_font_prefix\}"$\{user_port\}"$\{Font_color_suffix\}\\t 
\f1 \'c1\'b4\'bd\'d3
\f0 IP
\f1 \'d7\'dc\'ca\'fd
\f0 : $\{Green_font_prefix\}"$\{user_IP_total\}"$\{Font_color_suffix\}\\t 
\f1 \'b5\'b1\'c7\'b0\'c1\'b4\'bd\'d3
\f0 IP: $\{Green_font_prefix\}$\{user_IP\}$\{Font_color_suffix\}\\n"\
		user_IP=""\
	done\
	echo -e "
\f1 \'d3\'c3\'bb\'a7\'d7\'dc\'ca\'fd
\f0 : $\{Green_background_prefix\} "$\{user_total\}" $\{Font_color_suffix\} 
\f1 \'c1\'b4\'bd\'d3
\f0 IP
\f1 \'d7\'dc\'ca\'fd
\f0 : $\{Green_background_prefix\} "$\{IP_total\}" $\{Font_color_suffix\} "\
	echo -e "$\{user_list_all\}"\
\}\
centos_View_user_connection_info()\{\
	format_1=$1\
	user_info=$(python mujson_mgr.py -l)\
	user_total=$(echo "$\{user_info\}"|wc -l)\
	[[ -z $\{user_info\} ]] && echo -e "$\{Error\} 
\f1 \'c3\'bb\'d3\'d0\'b7\'a2\'cf\'d6
\f0  
\f1 \'d3\'c3\'bb\'a7\'a3\'ac\'c7\'eb\'bc\'ec\'b2\'e9
\f0  !" && exit 1\
	IP_total=`netstat -anp |grep 'ESTABLISHED' |grep 'python' |grep 'tcp' | grep '::ffff:' |awk '\{print $5\}' |awk -F ":" '\{print $4\}' |sort -u |wc -l`\
	user_list_all=""\
	for((integer = 1; integer <= $\{user_total\}; integer++))\
	do\
		user_port=$(echo "$\{user_info\}"|sed -n "$\{integer\}p"|awk '\{print $4\}')\
		user_IP_1=`netstat -anp |grep 'ESTABLISHED' |grep 'python' |grep 'tcp' |grep ":$\{user_port\} "|grep '::ffff:' |awk '\{print $5\}' |awk -F ":" '\{print $4\}' |sort -u`\
		if [[ -z $\{user_IP_1\} ]]; then\
			user_IP_total="0"\
		else\
			user_IP_total=`echo -e "$\{user_IP_1\}"|wc -l`\
			if [[ $\{format_1\} == "IP_address" ]]; then\
				get_IP_address\
			else\
				user_IP=`echo -e "\\n$\{user_IP_1\}"`\
			fi\
		fi\
		user_info_233=$(python mujson_mgr.py -l|grep -w "$\{user_port\}"|awk '\{print $2\}'|sed 's/\\[//g;s/\\]//g')\
		user_list_all=$\{user_list_all\}"
\f1 \'d3\'c3\'bb\'a7\'c3\'fb
\f0 : $\{Green_font_prefix\}"$\{user_info_233\}"$\{Font_color_suffix\}\\t 
\f1 \'b6\'cb\'bf\'da
\f0 : $\{Green_font_prefix\}"$\{user_port\}"$\{Font_color_suffix\}\\t 
\f1 \'c1\'b4\'bd\'d3
\f0 IP
\f1 \'d7\'dc\'ca\'fd
\f0 : $\{Green_font_prefix\}"$\{user_IP_total\}"$\{Font_color_suffix\}\\t 
\f1 \'b5\'b1\'c7\'b0\'c1\'b4\'bd\'d3
\f0 IP: $\{Green_font_prefix\}$\{user_IP\}$\{Font_color_suffix\}\\n"\
		user_IP=""\
	done\
	echo -e "
\f1 \'d3\'c3\'bb\'a7\'d7\'dc\'ca\'fd
\f0 : $\{Green_background_prefix\} "$\{user_total\}" $\{Font_color_suffix\} 
\f1 \'c1\'b4\'bd\'d3
\f0 IP
\f1 \'d7\'dc\'ca\'fd
\f0 : $\{Green_background_prefix\} "$\{IP_total\}" $\{Font_color_suffix\} "\
	echo -e "$\{user_list_all\}"\
\}\
View_user_connection_info()\{\
	SSR_installation_status\
	echo && echo -e "
\f1 \'c7\'eb\'d1\'a1\'d4\'f1\'d2\'aa\'cf\'d4\'ca\'be\'b5\'c4\'b8\'f1\'ca\'bd\'a3\'ba
\f0 \
 $\{Green_font_prefix\}1.$\{Font_color_suffix\} 
\f1 \'cf\'d4\'ca\'be
\f0  IP 
\f1 \'b8\'f1\'ca\'bd
\f0 \
 $\{Green_font_prefix\}2.$\{Font_color_suffix\} 
\f1 \'cf\'d4\'ca\'be
\f0  IP+IP
\f1 \'b9\'e9\'ca\'f4\'b5\'d8
\f0  
\f1 \'b8\'f1\'ca\'bd
\f0 " && echo\
	stty erase '^H' && read -p "(
\f1 \'c4\'ac\'c8\'cf
\f0 : 1):" ssr_connection_info\
	[[ -z "$\{ssr_connection_info\}" ]] && ssr_connection_info="1"\
	if [[ $\{ssr_connection_info\} == "1" ]]; then\
		View_user_connection_info_1 ""\
	elif [[ $\{ssr_connection_info\} == "2" ]]; then\
		echo -e "$\{Tip\} 
\f1 \'bc\'ec\'b2\'e2
\f0 IP
\f1 \'b9\'e9\'ca\'f4\'b5\'d8
\f0 (ipip.net)
\f1 \'a3\'ac\'c8\'e7\'b9\'fb
\f0 IP
\f1 \'bd\'cf\'b6\'e0\'a3\'ac\'bf\'c9\'c4\'dc\'ca\'b1\'bc\'e4\'bb\'e1\'b1\'c8\'bd\'cf\'b3\'a4
\f0 ..."\
		View_user_connection_info_1 "IP_address"\
	else\
		echo -e "$\{Error\} 
\f1 \'c7\'eb\'ca\'e4\'c8\'eb\'d5\'fd\'c8\'b7\'b5\'c4\'ca\'fd\'d7\'d6
\f0 (1-2)" && exit 1\
	fi\
\}\
View_user_connection_info_1()\{\
	format=$1\
	if [[ $\{release\} = "centos" ]]; then\
		cat /etc/redhat-release |grep 7\\..*|grep -i centos>/dev/null\
		if [[ $? = 0 ]]; then\
			debian_View_user_connection_info "$format"\
		else\
			centos_View_user_connection_info "$format"\
		fi\
	else\
		debian_View_user_connection_info "$format"\
	fi\
\}\
get_IP_address()\{\
	#echo "user_IP_1=$\{user_IP_1\}"\
	if [[ ! -z $\{user_IP_1\} ]]; then\
	#echo "user_IP_total=$\{user_IP_total\}"\
		for((integer_1 = $\{user_IP_total\}; integer_1 >= 1; integer_1--))\
		do\
			IP=`echo "$\{user_IP_1\}" |sed -n "$integer_1"p`\
			#echo "IP=$\{IP\}"\
			IP_address=`wget -qO- -t1 -T2 http://freeapi.ipip.net/$\{IP\}|sed 's/\\"//g;s/,//g;s/\\[//g;s/\\]//g'`\
			#echo "IP_address=$\{IP_address\}"\
			user_IP="$\{user_IP\}\\n$\{IP\}($\{IP_address\})"\
			#echo "user_IP=$\{user_IP\}"\
			sleep 1s\
		done\
	fi\
\}\
# 
\f1 \'d0\'de\'b8\'c4
\f0  
\f1 \'d3\'c3\'bb\'a7\'c5\'e4\'d6\'c3
\f0 \
Modify_port()\{\
	List_port_user\
	while true\
	do\
		echo -e "
\f1 \'c7\'eb\'ca\'e4\'c8\'eb\'d2\'aa\'d0\'de\'b8\'c4\'b5\'c4\'d3\'c3\'bb\'a7
\f0  
\f1 \'b6\'cb\'bf\'da
\f0 "\
		stty erase '^H' && read -p "(
\f1 \'c4\'ac\'c8\'cf
\f0 : 
\f1 \'c8\'a1\'cf\'fb
\f0 ):" ssr_port\
		[[ -z "$\{ssr_port\}" ]] && echo -e "
\f1 \'d2\'d1\'c8\'a1\'cf\'fb
\f0 ..." && exit 1\
		Modify_user=$(cat "$\{config_user_mudb_file\}"|grep '"port": '"$\{ssr_port\}"',')\
		if [[ ! -z $\{Modify_user\} ]]; then\
			break\
		else\
			echo -e "$\{Error\} 
\f1 \'c7\'eb\'ca\'e4\'c8\'eb\'d5\'fd\'c8\'b7\'b5\'c4\'b6\'cb\'bf\'da
\f0  !"\
		fi\
	done\
\}\
Modify_Config()\{\
	SSR_installation_status\
	echo && echo -e "
\f1 \'c4\'e3\'d2\'aa\'d7\'f6\'ca\'b2\'c3\'b4\'a3\'bf
\f0 \
 $\{Green_font_prefix\}1.$\{Font_color_suffix\}  
\f1 \'cc\'ed\'bc\'d3
\f0  
\f1 \'d3\'c3\'bb\'a7\'c5\'e4\'d6\'c3
\f0 \
 $\{Green_font_prefix\}2.$\{Font_color_suffix\}  
\f1 \'c9\'be\'b3\'fd
\f0  
\f1 \'d3\'c3\'bb\'a7\'c5\'e4\'d6\'c3
\f0 \
\'97\'97\'97\'97\'97 
\f1 \'d0\'de\'b8\'c4
\f0  
\f1 \'d3\'c3\'bb\'a7\'c5\'e4\'d6\'c3
\f0  \'97\'97\'97\'97\'97\
 $\{Green_font_prefix\}3.$\{Font_color_suffix\}  
\f1 \'d0\'de\'b8\'c4
\f0  
\f1 \'d3\'c3\'bb\'a7\'c3\'dc\'c2\'eb
\f0 \
 $\{Green_font_prefix\}4.$\{Font_color_suffix\}  
\f1 \'d0\'de\'b8\'c4
\f0  
\f1 \'bc\'d3\'c3\'dc\'b7\'bd\'ca\'bd
\f0 \
 $\{Green_font_prefix\}5.$\{Font_color_suffix\}  
\f1 \'d0\'de\'b8\'c4
\f0  
\f1 \'d0\'ad\'d2\'e9\'b2\'e5\'bc\'fe
\f0 \
 $\{Green_font_prefix\}6.$\{Font_color_suffix\}  
\f1 \'d0\'de\'b8\'c4
\f0  
\f1 \'bb\'ec\'cf\'fd\'b2\'e5\'bc\'fe
\f0 \
 $\{Green_font_prefix\}7.$\{Font_color_suffix\}  
\f1 \'d0\'de\'b8\'c4
\f0  
\f1 \'c9\'e8\'b1\'b8\'ca\'fd\'cf\'de\'d6\'c6
\f0 \
 $\{Green_font_prefix\}8.$\{Font_color_suffix\}  
\f1 \'d0\'de\'b8\'c4
\f0  
\f1 \'b5\'a5\'cf\'df\'b3\'cc\'cf\'de\'cb\'d9
\f0 \
 $\{Green_font_prefix\}9.$\{Font_color_suffix\}  
\f1 \'d0\'de\'b8\'c4
\f0  
\f1 \'d3\'c3\'bb\'a7\'d7\'dc\'cf\'de\'cb\'d9
\f0 \
 $\{Green_font_prefix\}10.$\{Font_color_suffix\} 
\f1 \'d0\'de\'b8\'c4
\f0  
\f1 \'d3\'c3\'bb\'a7\'d7\'dc\'c1\'f7\'c1\'bf
\f0 \
 $\{Green_font_prefix\}11.$\{Font_color_suffix\} 
\f1 \'d0\'de\'b8\'c4
\f0  
\f1 \'d3\'c3\'bb\'a7\'bd\'fb\'d3\'c3\'b6\'cb\'bf\'da
\f0 \
 $\{Green_font_prefix\}12.$\{Font_color_suffix\} 
\f1 \'d0\'de\'b8\'c4
\f0  
\f1 \'c8\'ab\'b2\'bf\'c5\'e4\'d6\'c3
\f0 \
\'97\'97\'97\'97\'97 
\f1 \'c6\'e4\'cb\'fb
\f0  \'97\'97\'97\'97\'97\
 $\{Green_font_prefix\}13.$\{Font_color_suffix\} 
\f1 \'d0\'de\'b8\'c4
\f0  
\f1 \'d3\'c3\'bb\'a7\'c5\'e4\'d6\'c3\'d6\'d0\'cf\'d4\'ca\'be\'b5\'c4
\f0 IP
\f1 \'bb\'f2\'d3\'f2\'c3\'fb
\f0 \
 \
 $\{Tip\} 
\f1 \'d3\'c3\'bb\'a7\'b5\'c4\'d3\'c3\'bb\'a7\'c3\'fb\'ba\'cd\'b6\'cb\'bf\'da\'ca\'c7\'ce\'de\'b7\'a8\'d0\'de\'b8\'c4\'a3\'ac\'c8\'e7\'b9\'fb\'d0\'e8\'d2\'aa\'d0\'de\'b8\'c4\'c7\'eb\'ca\'b9\'d3\'c3\'bd\'c5\'b1\'be\'b5\'c4
\f0  
\f1 \'ca\'d6\'b6\'af\'d0\'de\'b8\'c4\'b9\'a6\'c4\'dc
\f0  !" && echo\
	stty erase '^H' && read -p "(
\f1 \'c4\'ac\'c8\'cf
\f0 : 
\f1 \'c8\'a1\'cf\'fb
\f0 ):" ssr_modify\
	[[ -z "$\{ssr_modify\}" ]] && echo "
\f1 \'d2\'d1\'c8\'a1\'cf\'fb
\f0 ..." && exit 1\
	if [[ $\{ssr_modify\} == "1" ]]; then\
		Add_port_user\
	elif [[ $\{ssr_modify\} == "2" ]]; then\
		Del_port_user\
	elif [[ $\{ssr_modify\} == "3" ]]; then\
		Modify_port\
		Set_config_password\
		Modify_config_password\
	elif [[ $\{ssr_modify\} == "4" ]]; then\
		Modify_port\
		Set_config_method\
		Modify_config_method\
	elif [[ $\{ssr_modify\} == "5" ]]; then\
		Modify_port\
		Set_config_protocol\
		Modify_config_protocol\
	elif [[ $\{ssr_modify\} == "6" ]]; then\
		Modify_port\
		Set_config_obfs\
		Modify_config_obfs\
	elif [[ $\{ssr_modify\} == "7" ]]; then\
		Modify_port\
		Set_config_protocol_param\
		Modify_config_protocol_param\
	elif [[ $\{ssr_modify\} == "8" ]]; then\
		Modify_port\
		Set_config_speed_limit_per_con\
		Modify_config_speed_limit_per_con\
	elif [[ $\{ssr_modify\} == "9" ]]; then\
		Modify_port\
		Set_config_speed_limit_per_user\
		Modify_config_speed_limit_per_user\
	elif [[ $\{ssr_modify\} == "10" ]]; then\
		Modify_port\
		Set_config_transfer\
		Modify_config_transfer\
	elif [[ $\{ssr_modify\} == "11" ]]; then\
		Modify_port\
		Set_config_forbid\
		Modify_config_forbid\
	elif [[ $\{ssr_modify\} == "12" ]]; then\
		Modify_port\
		Set_config_all "Modify"\
		Modify_config_all\
	elif [[ $\{ssr_modify\} == "13" ]]; then\
		Set_user_api_server_pub_addr "Modify"\
		Modify_user_api_server_pub_addr\
	else\
		echo -e "$\{Error\} 
\f1 \'c7\'eb\'ca\'e4\'c8\'eb\'d5\'fd\'c8\'b7\'b5\'c4\'ca\'fd\'d7\'d6
\f0 (1-13)" && exit 1\
	fi\
\}\
List_port_user()\{\
	user_info=$(python mujson_mgr.py -l)\
	user_total=$(echo "$\{user_info\}"|wc -l)\
	[[ -z $\{user_info\} ]] && echo -e "$\{Error\} 
\f1 \'c3\'bb\'d3\'d0\'b7\'a2\'cf\'d6
\f0  
\f1 \'d3\'c3\'bb\'a7\'a3\'ac\'c7\'eb\'bc\'ec\'b2\'e9
\f0  !" && exit 1\
	user_list_all=""\
	for((integer = 1; integer <= $\{user_total\}; integer++))\
	do\
		user_port=$(echo "$\{user_info\}"|sed -n "$\{integer\}p"|awk '\{print $4\}')\
		user_username=$(echo "$\{user_info\}"|sed -n "$\{integer\}p"|awk '\{print $2\}'|sed 's/\\[//g;s/\\]//g')\
		Get_User_transfer "$\{user_port\}"\
		transfer_enable_Used_233=$(expr $transfer_enable_Used_233 + $transfer_enable_Used_2_1)\
		user_list_all=$\{user_list_all\}"
\f1 \'d3\'c3\'bb\'a7\'c3\'fb
\f0 : $\{Green_font_prefix\} "$\{user_username\}"$\{Font_color_suffix\}\\t 
\f1 \'b6\'cb\'bf\'da
\f0 : $\{Green_font_prefix\}"$\{user_port\}"$\{Font_color_suffix\}\\t 
\f1 \'c1\'f7\'c1\'bf\'ca\'b9\'d3\'c3\'c7\'e9\'bf\'f6
\f0 (
\f1 \'d2\'d1\'d3\'c3
\f0 +
\f1 \'ca\'a3\'d3\'e0
\f0 =
\f1 \'d7\'dc
\f0 ): $\{Green_font_prefix\}$\{transfer_enable_Used_2\}$\{Font_color_suffix\} + $\{Green_font_prefix\}$\{transfer_enable_Used\}$\{Font_color_suffix\} = $\{Green_font_prefix\}$\{transfer_enable\}$\{Font_color_suffix\}\\n"\
	done\
	Get_User_transfer_all\
	echo && echo -e "=== 
\f1 \'d3\'c3\'bb\'a7\'d7\'dc\'ca\'fd
\f0  $\{Green_background_prefix\} "$\{user_total\}" $\{Font_color_suffix\}"\
	echo -e $\{user_list_all\}\
	echo -e "=== 
\f1 \'b5\'b1\'c7\'b0\'cb\'f9\'d3\'d0\'d3\'c3\'bb\'a7\'d2\'d1\'ca\'b9\'d3\'c3\'c1\'f7\'c1\'bf\'d7\'dc\'ba\'cd
\f0 : $\{Green_background_prefix\} $\{transfer_enable_Used_233_2\} $\{Font_color_suffix\}\\n"\
\}\
Add_port_user()\{\
	lalal=$1\
	if [[ "$lalal" == "install" ]]; then\
		match_add=$(python mujson_mgr.py -a -u "$\{ssr_user\}" -p "$\{ssr_port\}" -k "$\{ssr_password\}" -m "$\{ssr_method\}" -O "$\{ssr_protocol\}" -G "$\{ssr_protocol_param\}" -o "$\{ssr_obfs\}" -s "$\{ssr_speed_limit_per_con\}" -S "$\{ssr_speed_limit_per_user\}" -t "$\{ssr_transfer\}" -f "$\{ssr_forbid\}"|grep -w "add user info")\
	else\
		while true\
		do\
			Set_config_all\
			match_port=$(python mujson_mgr.py -l|grep -w "port $\{ssr_port\}$")\
			[[ ! -z "$\{match_port\}" ]] && echo -e "$\{Error\} 
\f1 \'b8\'c3\'b6\'cb\'bf\'da
\f0  [$\{ssr_port\}] 
\f1 \'d2\'d1\'b4\'e6\'d4\'da\'a3\'ac\'c7\'eb\'ce\'f0\'d6\'d8\'b8\'b4\'cc\'ed\'bc\'d3
\f0  !" && exit 1\
			match_username=$(python mujson_mgr.py -l|grep -w "user \\[$\{ssr_user\}]")\
			[[ ! -z "$\{match_username\}" ]] && echo -e "$\{Error\} 
\f1 \'b8\'c3\'d3\'c3\'bb\'a7\'c3\'fb
\f0  [$\{ssr_user\}] 
\f1 \'d2\'d1\'b4\'e6\'d4\'da\'a3\'ac\'c7\'eb\'ce\'f0\'d6\'d8\'b8\'b4\'cc\'ed\'bc\'d3
\f0  !" && exit 1\
			match_add=$(python mujson_mgr.py -a -u "$\{ssr_user\}" -p "$\{ssr_port\}" -k "$\{ssr_password\}" -m "$\{ssr_method\}" -O "$\{ssr_protocol\}" -G "$\{ssr_protocol_param\}" -o "$\{ssr_obfs\}" -s "$\{ssr_speed_limit_per_con\}" -S "$\{ssr_speed_limit_per_user\}" -t "$\{ssr_transfer\}" -f "$\{ssr_forbid\}"|grep -w "add user info")\
			if [[ -z "$\{match_add\}" ]]; then\
				echo -e "$\{Error\} 
\f1 \'d3\'c3\'bb\'a7\'cc\'ed\'bc\'d3\'ca\'a7\'b0\'dc
\f0  $\{Green_font_prefix\}[
\f1 \'d3\'c3\'bb\'a7\'c3\'fb
\f0 : $\{ssr_user\} , 
\f1 \'b6\'cb\'bf\'da
\f0 : $\{ssr_port\}]$\{Font_color_suffix\} "\
				break\
			else\
				Add_iptables\
				Save_iptables\
				echo -e "$\{Info\} 
\f1 \'d3\'c3\'bb\'a7\'cc\'ed\'bc\'d3\'b3\'c9\'b9\'a6
\f0  $\{Green_font_prefix\}[
\f1 \'d3\'c3\'bb\'a7\'c3\'fb
\f0 : $\{ssr_user\} , 
\f1 \'b6\'cb\'bf\'da
\f0 : $\{ssr_port\}]$\{Font_color_suffix\} "\
				echo\
				stty erase '^H' && read -p "
\f1 \'ca\'c7\'b7\'f1\'bc\'cc\'d0\'f8
\f0  
\f1 \'cc\'ed\'bc\'d3\'d3\'c3\'bb\'a7\'c5\'e4\'d6\'c3\'a3\'bf
\f0 [Y/n]:" addyn\
				[[ -z $\{addyn\} ]] && addyn="y"\
				if [[ $\{addyn\} == [Nn] ]]; then\
					Get_User_info "$\{ssr_port\}"\
					View_User_info\
					break\
				else\
					echo -e "$\{Info\} 
\f1 \'bc\'cc\'d0\'f8
\f0  
\f1 \'cc\'ed\'bc\'d3\'d3\'c3\'bb\'a7\'c5\'e4\'d6\'c3
\f0 ..."\
				fi\
			fi\
		done\
	fi\
\}\
Del_port_user()\{\
	List_port_user\
	while true\
	do\
		echo -e "
\f1 \'c7\'eb\'ca\'e4\'c8\'eb\'d2\'aa\'c9\'be\'b3\'fd\'b5\'c4\'d3\'c3\'bb\'a7
\f0  
\f1 \'b6\'cb\'bf\'da
\f0 "\
		stty erase '^H' && read -p "(
\f1 \'c4\'ac\'c8\'cf
\f0 : 
\f1 \'c8\'a1\'cf\'fb
\f0 ):" del_user_port\
		[[ -z "$\{del_user_port\}" ]] && echo -e "
\f1 \'d2\'d1\'c8\'a1\'cf\'fb
\f0 ..." && exit 1\
		del_user=$(cat "$\{config_user_mudb_file\}"|grep '"port": '"$\{del_user_port\}"',')\
		if [[ ! -z $\{del_user\} ]]; then\
			port=$\{del_user_port\}\
			match_del=$(python mujson_mgr.py -d -p "$\{del_user_port\}"|grep -w "delete user ")\
			if [[ -z "$\{match_del\}" ]]; then\
				echo -e "$\{Error\} 
\f1 \'d3\'c3\'bb\'a7\'c9\'be\'b3\'fd\'ca\'a7\'b0\'dc
\f0  $\{Green_font_prefix\}[
\f1 \'b6\'cb\'bf\'da
\f0 : $\{del_user_port\}]$\{Font_color_suffix\} "\
			else\
				Del_iptables\
				Save_iptables\
				echo -e "$\{Info\} 
\f1 \'d3\'c3\'bb\'a7\'c9\'be\'b3\'fd\'b3\'c9\'b9\'a6
\f0  $\{Green_font_prefix\}[
\f1 \'b6\'cb\'bf\'da
\f0 : $\{del_user_port\}]$\{Font_color_suffix\} "\
			fi\
			break\
		else\
			echo -e "$\{Error\} 
\f1 \'c7\'eb\'ca\'e4\'c8\'eb\'d5\'fd\'c8\'b7\'b5\'c4\'b6\'cb\'bf\'da
\f0  !"\
		fi\
	done\
\}\
Manually_Modify_Config()\{\
	SSR_installation_status\
	vi $\{config_user_mudb_file\}\
	echo "
\f1 \'ca\'c7\'b7\'f1\'cf\'d6\'d4\'da\'d6\'d8\'c6\'f4
\f0 ShadowsocksR
\f1 \'a3\'bf
\f0 [Y/n]" && echo\
	stty erase '^H' && read -p "(
\f1 \'c4\'ac\'c8\'cf
\f0 : y):" yn\
	[[ -z $\{yn\} ]] && yn="y"\
	if [[ $\{yn\} == [Yy] ]]; then\
		Restart_SSR\
	fi\
\}\
Clear_transfer()\{\
	SSR_installation_status\
	echo && echo -e "
\f1 \'c4\'e3\'d2\'aa\'d7\'f6\'ca\'b2\'c3\'b4\'a3\'bf
\f0 \
 $\{Green_font_prefix\}1.$\{Font_color_suffix\}  
\f1 \'c7\'e5\'c1\'e3
\f0  
\f1 \'b5\'a5\'b8\'f6\'d3\'c3\'bb\'a7\'d2\'d1\'ca\'b9\'d3\'c3\'c1\'f7\'c1\'bf
\f0 \
 $\{Green_font_prefix\}2.$\{Font_color_suffix\}  
\f1 \'c7\'e5\'c1\'e3
\f0  
\f1 \'cb\'f9\'d3\'d0\'d3\'c3\'bb\'a7\'d2\'d1\'ca\'b9\'d3\'c3\'c1\'f7\'c1\'bf
\f0 (
\f1 \'b2\'bb\'bf\'c9\'cd\'ec\'bb\'d8
\f0 )\
 $\{Green_font_prefix\}3.$\{Font_color_suffix\}  
\f1 \'c6\'f4\'b6\'af
\f0  
\f1 \'b6\'a8\'ca\'b1\'cb\'f9\'d3\'d0\'d3\'c3\'bb\'a7\'c1\'f7\'c1\'bf\'c7\'e5\'c1\'e3
\f0 \
 $\{Green_font_prefix\}4.$\{Font_color_suffix\}  
\f1 \'cd\'a3\'d6\'b9
\f0  
\f1 \'b6\'a8\'ca\'b1\'cb\'f9\'d3\'d0\'d3\'c3\'bb\'a7\'c1\'f7\'c1\'bf\'c7\'e5\'c1\'e3
\f0 \
 $\{Green_font_prefix\}5.$\{Font_color_suffix\}  
\f1 \'d0\'de\'b8\'c4
\f0  
\f1 \'b6\'a8\'ca\'b1\'cb\'f9\'d3\'d0\'d3\'c3\'bb\'a7\'c1\'f7\'c1\'bf\'c7\'e5\'c1\'e3
\f0 " && echo\
	stty erase '^H' && read -p "(
\f1 \'c4\'ac\'c8\'cf
\f0 : 
\f1 \'c8\'a1\'cf\'fb
\f0 ):" ssr_modify\
	[[ -z "$\{ssr_modify\}" ]] && echo "
\f1 \'d2\'d1\'c8\'a1\'cf\'fb
\f0 ..." && exit 1\
	if [[ $\{ssr_modify\} == "1" ]]; then\
		Clear_transfer_one\
	elif [[ $\{ssr_modify\} == "2" ]]; then\
		echo "
\f1 \'c8\'b7\'b6\'a8\'d2\'aa
\f0  
\f1 \'c7\'e5\'c1\'e3
\f0  
\f1 \'cb\'f9\'d3\'d0\'d3\'c3\'bb\'a7\'d2\'d1\'ca\'b9\'d3\'c3\'c1\'f7\'c1\'bf\'a3\'bf
\f0 [y/N]" && echo\
		stty erase '^H' && read -p "(
\f1 \'c4\'ac\'c8\'cf
\f0 : n):" yn\
		[[ -z $\{yn\} ]] && yn="n"\
		if [[ $\{yn\} == [Yy] ]]; then\
			Clear_transfer_all\
		else\
			echo "
\f1 \'c8\'a1\'cf\'fb
\f0 ..."\
		fi\
	elif [[ $\{ssr_modify\} == "3" ]]; then\
		check_crontab\
		Set_crontab\
		Clear_transfer_all_cron_start\
	elif [[ $\{ssr_modify\} == "4" ]]; then\
		check_crontab\
		Clear_transfer_all_cron_stop\
	elif [[ $\{ssr_modify\} == "5" ]]; then\
		check_crontab\
		Clear_transfer_all_cron_modify\
	else\
		echo -e "$\{Error\} 
\f1 \'c7\'eb\'ca\'e4\'c8\'eb\'d5\'fd\'c8\'b7\'b5\'c4\'ca\'fd\'d7\'d6
\f0 (1-5)" && exit 1\
	fi\
\}\
Clear_transfer_one()\{\
	List_port_user\
	while true\
	do\
		echo -e "
\f1 \'c7\'eb\'ca\'e4\'c8\'eb\'d2\'aa\'c7\'e5\'c1\'e3\'d2\'d1\'ca\'b9\'d3\'c3\'c1\'f7\'c1\'bf\'b5\'c4\'d3\'c3\'bb\'a7
\f0  
\f1 \'b6\'cb\'bf\'da
\f0 "\
		stty erase '^H' && read -p "(
\f1 \'c4\'ac\'c8\'cf
\f0 : 
\f1 \'c8\'a1\'cf\'fb
\f0 ):" Clear_transfer_user_port\
		[[ -z "$\{Clear_transfer_user_port\}" ]] && echo -e "
\f1 \'d2\'d1\'c8\'a1\'cf\'fb
\f0 ..." && exit 1\
		Clear_transfer_user=$(cat "$\{config_user_mudb_file\}"|grep '"port": '"$\{Clear_transfer_user_port\}"',')\
		if [[ ! -z $\{Clear_transfer_user\} ]]; then\
			match_clear=$(python mujson_mgr.py -c -p "$\{Clear_transfer_user_port\}"|grep -w "clear user ")\
			if [[ -z "$\{match_clear\}" ]]; then\
				echo -e "$\{Error\} 
\f1 \'d3\'c3\'bb\'a7\'d2\'d1\'ca\'b9\'d3\'c3\'c1\'f7\'c1\'bf\'c7\'e5\'c1\'e3\'ca\'a7\'b0\'dc
\f0  $\{Green_font_prefix\}[
\f1 \'b6\'cb\'bf\'da
\f0 : $\{Clear_transfer_user_port\}]$\{Font_color_suffix\} "\
			else\
				echo -e "$\{Info\} 
\f1 \'d3\'c3\'bb\'a7\'d2\'d1\'ca\'b9\'d3\'c3\'c1\'f7\'c1\'bf\'c7\'e5\'c1\'e3\'b3\'c9\'b9\'a6
\f0  $\{Green_font_prefix\}[
\f1 \'b6\'cb\'bf\'da
\f0 : $\{Clear_transfer_user_port\}]$\{Font_color_suffix\} "\
			fi\
			break\
		else\
			echo -e "$\{Error\} 
\f1 \'c7\'eb\'ca\'e4\'c8\'eb\'d5\'fd\'c8\'b7\'b5\'c4\'b6\'cb\'bf\'da
\f0  !"\
		fi\
	done\
\}\
Clear_transfer_all()\{\
	cd "$\{ssr_folder\}"\
	user_info=$(python mujson_mgr.py -l)\
	user_total=$(echo "$\{user_info\}"|wc -l)\
	[[ -z $\{user_info\} ]] && echo -e "$\{Error\} 
\f1 \'c3\'bb\'d3\'d0\'b7\'a2\'cf\'d6
\f0  
\f1 \'d3\'c3\'bb\'a7\'a3\'ac\'c7\'eb\'bc\'ec\'b2\'e9
\f0  !" && exit 1\
	for((integer = 1; integer <= $\{user_total\}; integer++))\
	do\
		user_port=$(echo "$\{user_info\}"|sed -n "$\{integer\}p"|awk '\{print $4\}')\
		match_clear=$(python mujson_mgr.py -c -p "$\{user_port\}"|grep -w "clear user ")\
		if [[ -z "$\{match_clear\}" ]]; then\
			echo -e "$\{Error\} 
\f1 \'d3\'c3\'bb\'a7\'d2\'d1\'ca\'b9\'d3\'c3\'c1\'f7\'c1\'bf\'c7\'e5\'c1\'e3\'ca\'a7\'b0\'dc
\f0  $\{Green_font_prefix\}[
\f1 \'b6\'cb\'bf\'da
\f0 : $\{user_port\}]$\{Font_color_suffix\} "\
		else\
			echo -e "$\{Info\} 
\f1 \'d3\'c3\'bb\'a7\'d2\'d1\'ca\'b9\'d3\'c3\'c1\'f7\'c1\'bf\'c7\'e5\'c1\'e3\'b3\'c9\'b9\'a6
\f0  $\{Green_font_prefix\}[
\f1 \'b6\'cb\'bf\'da
\f0 : $\{user_port\}]$\{Font_color_suffix\} "\
		fi\
	done\
	echo -e "$\{Info\} 
\f1 \'cb\'f9\'d3\'d0\'d3\'c3\'bb\'a7\'c1\'f7\'c1\'bf\'c7\'e5\'c1\'e3\'cd\'ea\'b1\'cf
\f0  !"\
\}\
Clear_transfer_all_cron_start()\{\
	crontab -l > "$file/crontab.bak"\
	sed -i "/ssrmu.sh/d" "$file/crontab.bak"\
	echo -e "\\n$\{Crontab_time\} /bin/bash $file/ssrmu.sh clearall" >> "$file/crontab.bak"\
	crontab "$file/crontab.bak"\
	rm -r "$file/crontab.bak"\
	cron_config=$(crontab -l | grep "ssrmu.sh")\
	if [[ -z $\{cron_config\} ]]; then\
		echo -e "$\{Error\} 
\f1 \'b6\'a8\'ca\'b1\'cb\'f9\'d3\'d0\'d3\'c3\'bb\'a7\'c1\'f7\'c1\'bf\'c7\'e5\'c1\'e3\'c6\'f4\'b6\'af\'ca\'a7\'b0\'dc
\f0  !" && exit 1\
	else\
		echo -e "$\{Info\} 
\f1 \'b6\'a8\'ca\'b1\'cb\'f9\'d3\'d0\'d3\'c3\'bb\'a7\'c1\'f7\'c1\'bf\'c7\'e5\'c1\'e3\'c6\'f4\'b6\'af\'b3\'c9\'b9\'a6
\f0  !"\
	fi\
\}\
Clear_transfer_all_cron_stop()\{\
	crontab -l > "$file/crontab.bak"\
	sed -i "/ssrmu.sh/d" "$file/crontab.bak"\
	crontab "$file/crontab.bak"\
	rm -r "$file/crontab.bak"\
	cron_config=$(crontab -l | grep "ssrmu.sh")\
	if [[ ! -z $\{cron_config\} ]]; then\
		echo -e "$\{Error\} 
\f1 \'b6\'a8\'ca\'b1\'cb\'f9\'d3\'d0\'d3\'c3\'bb\'a7\'c1\'f7\'c1\'bf\'c7\'e5\'c1\'e3\'cd\'a3\'d6\'b9\'ca\'a7\'b0\'dc
\f0  !" && exit 1\
	else\
		echo -e "$\{Info\} 
\f1 \'b6\'a8\'ca\'b1\'cb\'f9\'d3\'d0\'d3\'c3\'bb\'a7\'c1\'f7\'c1\'bf\'c7\'e5\'c1\'e3\'cd\'a3\'d6\'b9\'b3\'c9\'b9\'a6
\f0  !"\
	fi\
\}\
Clear_transfer_all_cron_modify()\{\
	Set_crontab\
	Clear_transfer_all_cron_stop\
	Clear_transfer_all_cron_start\
\}\
Set_crontab()\{\
		echo -e "
\f1 \'c7\'eb\'ca\'e4\'c8\'eb\'c1\'f7\'c1\'bf\'c7\'e5\'c1\'e3\'ca\'b1\'bc\'e4\'bc\'e4\'b8\'f4
\f0 \
 === 
\f1 \'b8\'f1\'ca\'bd\'cb\'b5\'c3\'f7
\f0  ===\
 * * * * * 
\f1 \'b7\'d6\'b1\'f0\'b6\'d4\'d3\'a6
\f0  
\f1 \'b7\'d6\'d6\'d3
\f0  
\f1 \'d0\'a1\'ca\'b1
\f0  
\f1 \'c8\'d5\'b7\'dd
\f0  
\f1 \'d4\'c2\'b7\'dd
\f0  
\f1 \'d0\'c7\'c6\'da
\f0 \
 $\{Green_font_prefix\} 0 2 1 * * $\{Font_color_suffix\} 
\f1 \'b4\'fa\'b1\'ed
\f0  
\f1 \'c3\'bf\'d4\'c2
\f0 1
\f1 \'c8\'d5
\f0 2
\f1 \'b5\'e3
\f0 0
\f1 \'b7\'d6
\f0  
\f1 \'c7\'e5\'c1\'e3\'d2\'d1\'ca\'b9\'d3\'c3\'c1\'f7\'c1\'bf
\f0 \
 $\{Green_font_prefix\} 0 2 15 * * $\{Font_color_suffix\} 
\f1 \'b4\'fa\'b1\'ed
\f0  
\f1 \'c3\'bf\'d4\'c2
\f0 15
\f1 \'c8\'d5
\f0 2
\f1 \'b5\'e3
\f0 0
\f1 \'b7\'d6
\f0  
\f1 \'c7\'e5\'c1\'e3\'d2\'d1\'ca\'b9\'d3\'c3\'c1\'f7\'c1\'bf
\f0 \
 $\{Green_font_prefix\} 0 2 */7 * * $\{Font_color_suffix\} 
\f1 \'b4\'fa\'b1\'ed
\f0  
\f1 \'c3\'bf
\f0 7
\f1 \'cc\'ec
\f0 2
\f1 \'b5\'e3
\f0 0
\f1 \'b7\'d6
\f0  
\f1 \'c7\'e5\'c1\'e3\'d2\'d1\'ca\'b9\'d3\'c3\'c1\'f7\'c1\'bf
\f0 \
 $\{Green_font_prefix\} 0 2 * * 0 $\{Font_color_suffix\} 
\f1 \'b4\'fa\'b1\'ed
\f0  
\f1 \'c3\'bf\'b8\'f6\'d0\'c7\'c6\'da\'c8\'d5
\f0 (7) 
\f1 \'c7\'e5\'c1\'e3\'d2\'d1\'ca\'b9\'d3\'c3\'c1\'f7\'c1\'bf
\f0 \
 $\{Green_font_prefix\} 0 2 * * 3 $\{Font_color_suffix\} 
\f1 \'b4\'fa\'b1\'ed
\f0  
\f1 \'c3\'bf\'b8\'f6\'d0\'c7\'c6\'da\'c8\'fd
\f0 (3) 
\f1 \'c7\'e5\'c1\'e3\'d2\'d1\'ca\'b9\'d3\'c3\'c1\'f7\'c1\'bf
\f0 " && echo\
	stty erase '^H' && read -p "(
\f1 \'c4\'ac\'c8\'cf
\f0 : 0 2 1 * * 
\f1 \'c3\'bf\'d4\'c2
\f0 1
\f1 \'c8\'d5
\f0 2
\f1 \'b5\'e3
\f0 0
\f1 \'b7\'d6
\f0 ):" Crontab_time\
	[[ -z "$\{Crontab_time\}" ]] && Crontab_time="0 2 1 * *"\
\}\
Start_SSR()\{\
	SSR_installation_status\
	check_pid\
	[[ ! -z $\{PID\} ]] && echo -e "$\{Error\} ShadowsocksR 
\f1 \'d5\'fd\'d4\'da\'d4\'cb\'d0\'d0
\f0  !" && exit 1\
	/etc/init.d/ssrmu start\
\}\
Stop_SSR()\{\
	SSR_installation_status\
	check_pid\
	[[ -z $\{PID\} ]] && echo -e "$\{Error\} ShadowsocksR 
\f1 \'ce\'b4\'d4\'cb\'d0\'d0
\f0  !" && exit 1\
	/etc/init.d/ssrmu stop\
\}\
Restart_SSR()\{\
	SSR_installation_status\
	check_pid\
	[[ ! -z $\{PID\} ]] && /etc/init.d/ssrmu stop\
	/etc/init.d/ssrmu start\
\}\
View_Log()\{\
	SSR_installation_status\
	[[ ! -e $\{ssr_log_file\} ]] && echo -e "$\{Error\} ShadowsocksR
\f1 \'c8\'d5\'d6\'be\'ce\'c4\'bc\'fe\'b2\'bb\'b4\'e6\'d4\'da
\f0  !" && exit 1\
	echo && echo -e "$\{Tip\} 
\f1 \'b0\'b4
\f0  $\{Red_font_prefix\}Ctrl+C$\{Font_color_suffix\} 
\f1 \'d6\'d5\'d6\'b9\'b2\'e9\'bf\'b4\'c8\'d5\'d6\'be
\f0 " && echo\
	tail -f $\{ssr_log_file\}\
\}\
# 
\f1 \'c8\'f1\'cb\'d9
\f0 \
Configure_Server_Speeder()\{\
	echo && echo -e "
\f1 \'c4\'e3\'d2\'aa\'d7\'f6\'ca\'b2\'c3\'b4\'a3\'bf
\f0 \
 $\{Green_font_prefix\}1.$\{Font_color_suffix\} 
\f1 \'b0\'b2\'d7\'b0
\f0  
\f1 \'c8\'f1\'cb\'d9
\f0 \
 $\{Green_font_prefix\}2.$\{Font_color_suffix\} 
\f1 \'d0\'b6\'d4\'d8
\f0  
\f1 \'c8\'f1\'cb\'d9
\f0 \
\'97\'97\'97\'97\'97\'97\'97\'97\
 $\{Green_font_prefix\}3.$\{Font_color_suffix\} 
\f1 \'c6\'f4\'b6\'af
\f0  
\f1 \'c8\'f1\'cb\'d9
\f0 \
 $\{Green_font_prefix\}4.$\{Font_color_suffix\} 
\f1 \'cd\'a3\'d6\'b9
\f0  
\f1 \'c8\'f1\'cb\'d9
\f0 \
 $\{Green_font_prefix\}5.$\{Font_color_suffix\} 
\f1 \'d6\'d8\'c6\'f4
\f0  
\f1 \'c8\'f1\'cb\'d9
\f0 \
 $\{Green_font_prefix\}6.$\{Font_color_suffix\} 
\f1 \'b2\'e9\'bf\'b4
\f0  
\f1 \'c8\'f1\'cb\'d9
\f0  
\f1 \'d7\'b4\'cc\'ac
\f0 \
 \
 
\f1 \'d7\'a2\'d2\'e2\'a3\'ba
\f0  
\f1 \'c8\'f1\'cb\'d9\'ba\'cd
\f0 LotServer
\f1 \'b2\'bb\'c4\'dc\'cd\'ac\'ca\'b1\'b0\'b2\'d7\'b0
\f0 /
\f1 \'c6\'f4\'b6\'af\'a3\'a1
\f0 " && echo\
	stty erase '^H' && read -p "(
\f1 \'c4\'ac\'c8\'cf
\f0 : 
\f1 \'c8\'a1\'cf\'fb
\f0 ):" server_speeder_num\
	[[ -z "$\{server_speeder_num\}" ]] && echo "
\f1 \'d2\'d1\'c8\'a1\'cf\'fb
\f0 ..." && exit 1\
	if [[ $\{server_speeder_num\} == "1" ]]; then\
		Install_ServerSpeeder\
	elif [[ $\{server_speeder_num\} == "2" ]]; then\
		Server_Speeder_installation_status\
		Uninstall_ServerSpeeder\
	elif [[ $\{server_speeder_num\} == "3" ]]; then\
		Server_Speeder_installation_status\
		$\{Server_Speeder_file\} start\
		$\{Server_Speeder_file\} status\
	elif [[ $\{server_speeder_num\} == "4" ]]; then\
		Server_Speeder_installation_status\
		$\{Server_Speeder_file\} stop\
	elif [[ $\{server_speeder_num\} == "5" ]]; then\
		Server_Speeder_installation_status\
		$\{Server_Speeder_file\} restart\
		$\{Server_Speeder_file\} status\
	elif [[ $\{server_speeder_num\} == "6" ]]; then\
		Server_Speeder_installation_status\
		$\{Server_Speeder_file\} status\
	else\
		echo -e "$\{Error\} 
\f1 \'c7\'eb\'ca\'e4\'c8\'eb\'d5\'fd\'c8\'b7\'b5\'c4\'ca\'fd\'d7\'d6
\f0 (1-6)" && exit 1\
	fi\
\}\
Install_ServerSpeeder()\{\
	[[ -e $\{Server_Speeder_file\} ]] && echo -e "$\{Error\} 
\f1 \'c8\'f1\'cb\'d9
\f0 (Server Speeder) 
\f1 \'d2\'d1\'b0\'b2\'d7\'b0
\f0  !" && exit 1\
	#
\f1 \'bd\'e8\'d3\'c3
\f0 91yun.rog
\f1 \'b5\'c4\'bf\'aa\'d0\'c4\'b0\'e6\'c8\'f1\'cb\'d9
\f0 \
	wget --no-check-certificate -qO /tmp/serverspeeder.sh https://raw.githubusercontent.com/91yun/serverspeeder/master/serverspeeder.sh\
	[[ ! -e "/tmp/serverspeeder.sh" ]] && echo -e "$\{Error\} 
\f1 \'c8\'f1\'cb\'d9\'b0\'b2\'d7\'b0\'bd\'c5\'b1\'be\'cf\'c2\'d4\'d8\'ca\'a7\'b0\'dc
\f0  !" && exit 1\
	bash /tmp/serverspeeder.sh\
	sleep 2s\
	PID=`ps -ef |grep -v grep |grep "serverspeeder" |awk '\{print $2\}'`\
	if [[ ! -z $\{PID\} ]]; then\
		rm -rf /tmp/serverspeeder.sh\
		rm -rf /tmp/91yunserverspeeder\
		rm -rf /tmp/91yunserverspeeder.tar.gz\
		echo -e "$\{Info\} 
\f1 \'c8\'f1\'cb\'d9
\f0 (Server Speeder) 
\f1 \'b0\'b2\'d7\'b0\'cd\'ea\'b3\'c9
\f0  !" && exit 1\
	else\
		echo -e "$\{Error\} 
\f1 \'c8\'f1\'cb\'d9
\f0 (Server Speeder) 
\f1 \'b0\'b2\'d7\'b0\'ca\'a7\'b0\'dc
\f0  !" && exit 1\
	fi\
\}\
Uninstall_ServerSpeeder()\{\
	echo "
\f1 \'c8\'b7\'b6\'a8\'d2\'aa\'d0\'b6\'d4\'d8
\f0  
\f1 \'c8\'f1\'cb\'d9
\f0 (Server Speeder)
\f1 \'a3\'bf
\f0 [y/N]" && echo\
	stty erase '^H' && read -p "(
\f1 \'c4\'ac\'c8\'cf
\f0 : n):" unyn\
	[[ -z $\{unyn\} ]] && echo && echo "
\f1 \'d2\'d1\'c8\'a1\'cf\'fb
\f0 ..." && exit 1\
	if [[ $\{unyn\} == [Yy] ]]; then\
		chattr -i /serverspeeder/etc/apx*\
		/serverspeeder/bin/serverSpeeder.sh uninstall -f\
		echo && echo "
\f1 \'c8\'f1\'cb\'d9
\f0 (Server Speeder) 
\f1 \'d0\'b6\'d4\'d8\'cd\'ea\'b3\'c9
\f0  !" && echo\
	fi\
\}\
# LotServer\
Configure_LotServer()\{\
	echo && echo -e "
\f1 \'c4\'e3\'d2\'aa\'d7\'f6\'ca\'b2\'c3\'b4\'a3\'bf
\f0 \
 $\{Green_font_prefix\}1.$\{Font_color_suffix\} 
\f1 \'b0\'b2\'d7\'b0
\f0  LotServer\
 $\{Green_font_prefix\}2.$\{Font_color_suffix\} 
\f1 \'d0\'b6\'d4\'d8
\f0  LotServer\
\'97\'97\'97\'97\'97\'97\'97\'97\
 $\{Green_font_prefix\}3.$\{Font_color_suffix\} 
\f1 \'c6\'f4\'b6\'af
\f0  LotServer\
 $\{Green_font_prefix\}4.$\{Font_color_suffix\} 
\f1 \'cd\'a3\'d6\'b9
\f0  LotServer\
 $\{Green_font_prefix\}5.$\{Font_color_suffix\} 
\f1 \'d6\'d8\'c6\'f4
\f0  LotServer\
 $\{Green_font_prefix\}6.$\{Font_color_suffix\} 
\f1 \'b2\'e9\'bf\'b4
\f0  LotServer 
\f1 \'d7\'b4\'cc\'ac
\f0 \
 \
 
\f1 \'d7\'a2\'d2\'e2\'a3\'ba
\f0  
\f1 \'c8\'f1\'cb\'d9\'ba\'cd
\f0 LotServer
\f1 \'b2\'bb\'c4\'dc\'cd\'ac\'ca\'b1\'b0\'b2\'d7\'b0
\f0 /
\f1 \'c6\'f4\'b6\'af\'a3\'a1
\f0 " && echo\
	stty erase '^H' && read -p "(
\f1 \'c4\'ac\'c8\'cf
\f0 : 
\f1 \'c8\'a1\'cf\'fb
\f0 ):" lotserver_num\
	[[ -z "$\{lotserver_num\}" ]] && echo "
\f1 \'d2\'d1\'c8\'a1\'cf\'fb
\f0 ..." && exit 1\
	if [[ $\{lotserver_num\} == "1" ]]; then\
		Install_LotServer\
	elif [[ $\{lotserver_num\} == "2" ]]; then\
		LotServer_installation_status\
		Uninstall_LotServer\
	elif [[ $\{lotserver_num\} == "3" ]]; then\
		LotServer_installation_status\
		$\{LotServer_file\} start\
		$\{LotServer_file\} status\
	elif [[ $\{lotserver_num\} == "4" ]]; then\
		LotServer_installation_status\
		$\{LotServer_file\} stop\
	elif [[ $\{lotserver_num\} == "5" ]]; then\
		LotServer_installation_status\
		$\{LotServer_file\} restart\
		$\{LotServer_file\} status\
	elif [[ $\{lotserver_num\} == "6" ]]; then\
		LotServer_installation_status\
		$\{LotServer_file\} status\
	else\
		echo -e "$\{Error\} 
\f1 \'c7\'eb\'ca\'e4\'c8\'eb\'d5\'fd\'c8\'b7\'b5\'c4\'ca\'fd\'d7\'d6
\f0 (1-6)" && exit 1\
	fi\
\}\
Install_LotServer()\{\
	[[ -e $\{LotServer_file\} ]] && echo -e "$\{Error\} LotServer 
\f1 \'d2\'d1\'b0\'b2\'d7\'b0
\f0  !" && exit 1\
	#Github: https://github.com/0oVicero0/serverSpeeder_Install\
	wget --no-check-certificate -qO /tmp/appex.sh "https://raw.githubusercontent.com/0oVicero0/serverSpeeder_Install/master/appex.sh"\
	[[ ! -e "/tmp/appex.sh" ]] && echo -e "$\{Error\} LotServer 
\f1 \'b0\'b2\'d7\'b0\'bd\'c5\'b1\'be\'cf\'c2\'d4\'d8\'ca\'a7\'b0\'dc
\f0  !" && exit 1\
	bash /tmp/appex.sh 'install'\
	sleep 2s\
	PID=`ps -ef |grep -v grep |grep "appex" |awk '\{print $2\}'`\
	if [[ ! -z $\{PID\} ]]; then\
		echo -e "$\{Info\} LotServer 
\f1 \'b0\'b2\'d7\'b0\'cd\'ea\'b3\'c9
\f0  !" && exit 1\
	else\
		echo -e "$\{Error\} LotServer 
\f1 \'b0\'b2\'d7\'b0\'ca\'a7\'b0\'dc
\f0  !" && exit 1\
	fi\
\}\
Uninstall_LotServer()\{\
	echo "
\f1 \'c8\'b7\'b6\'a8\'d2\'aa\'d0\'b6\'d4\'d8
\f0  LotServer
\f1 \'a3\'bf
\f0 [y/N]" && echo\
	stty erase '^H' && read -p "(
\f1 \'c4\'ac\'c8\'cf
\f0 : n):" unyn\
	[[ -z $\{unyn\} ]] && echo && echo "
\f1 \'d2\'d1\'c8\'a1\'cf\'fb
\f0 ..." && exit 1\
	if [[ $\{unyn\} == [Yy] ]]; then\
		wget --no-check-certificate -qO /tmp/appex.sh "https://raw.githubusercontent.com/0oVicero0/serverSpeeder_Install/master/appex.sh" && bash /tmp/appex.sh 'uninstall'\
		echo && echo "LotServer 
\f1 \'d0\'b6\'d4\'d8\'cd\'ea\'b3\'c9
\f0  !" && echo\
	fi\
\}\
# BBR\
Configure_BBR()\{\
	echo && echo -e "  
\f1 \'c4\'e3\'d2\'aa\'d7\'f6\'ca\'b2\'c3\'b4\'a3\'bf
\f0 \
	\
 $\{Green_font_prefix\}1.$\{Font_color_suffix\} 
\f1 \'b0\'b2\'d7\'b0
\f0  BBR\
\'97\'97\'97\'97\'97\'97\'97\'97\
 $\{Green_font_prefix\}2.$\{Font_color_suffix\} 
\f1 \'c6\'f4\'b6\'af
\f0  BBR\
 $\{Green_font_prefix\}3.$\{Font_color_suffix\} 
\f1 \'cd\'a3\'d6\'b9
\f0  BBR\
 $\{Green_font_prefix\}4.$\{Font_color_suffix\} 
\f1 \'b2\'e9\'bf\'b4
\f0  BBR 
\f1 \'d7\'b4\'cc\'ac
\f0 " && echo\
echo -e "$\{Green_font_prefix\} [
\f1 \'b0\'b2\'d7\'b0\'c7\'b0
\f0  
\f1 \'c7\'eb\'d7\'a2\'d2\'e2
\f0 ] $\{Font_color_suffix\}\
1. 
\f1 \'b0\'b2\'d7\'b0\'bf\'aa\'c6\'f4
\f0 BBR
\f1 \'a3\'ac\'d0\'e8\'d2\'aa\'b8\'fc\'bb\'bb\'c4\'da\'ba\'cb\'a3\'ac\'b4\'e6\'d4\'da\'b8\'fc\'bb\'bb\'ca\'a7\'b0\'dc\'b5\'c8\'b7\'e7\'cf\'d5
\f0 (
\f1 \'d6\'d8\'c6\'f4\'ba\'f3\'ce\'de\'b7\'a8\'bf\'aa\'bb\'fa
\f0 )\
2. 
\f1 \'b1\'be\'bd\'c5\'b1\'be\'bd\'f6\'d6\'a7\'b3\'d6
\f0  Debian / Ubuntu 
\f1 \'cf\'b5\'cd\'b3\'b8\'fc\'bb\'bb\'c4\'da\'ba\'cb\'a3\'ac
\f0 OpenVZ
\f1 \'ba\'cd
\f0 Docker 
\f1 \'b2\'bb\'d6\'a7\'b3\'d6\'b8\'fc\'bb\'bb\'c4\'da\'ba\'cb
\f0 \
3. Debian 
\f1 \'b8\'fc\'bb\'bb\'c4\'da\'ba\'cb\'b9\'fd\'b3\'cc\'d6\'d0\'bb\'e1\'cc\'e1\'ca\'be
\f0  [ 
\f1 \'ca\'c7\'b7\'f1\'d6\'d5\'d6\'b9\'d0\'b6\'d4\'d8\'c4\'da\'ba\'cb
\f0  ] 
\f1 \'a3\'ac\'c7\'eb\'d1\'a1\'d4\'f1
\f0  $\{Green_font_prefix\} NO $\{Font_color_suffix\}" && echo\
	stty erase '^H' && read -p "(
\f1 \'c4\'ac\'c8\'cf
\f0 : 
\f1 \'c8\'a1\'cf\'fb
\f0 ):" bbr_num\
	[[ -z "$\{bbr_num\}" ]] && echo "
\f1 \'d2\'d1\'c8\'a1\'cf\'fb
\f0 ..." && exit 1\
	if [[ $\{bbr_num\} == "1" ]]; then\
		Install_BBR\
	elif [[ $\{bbr_num\} == "2" ]]; then\
		Start_BBR\
	elif [[ $\{bbr_num\} == "3" ]]; then\
		Stop_BBR\
	elif [[ $\{bbr_num\} == "4" ]]; then\
		Status_BBR\
	else\
		echo -e "$\{Error\} 
\f1 \'c7\'eb\'ca\'e4\'c8\'eb\'d5\'fd\'c8\'b7\'b5\'c4\'ca\'fd\'d7\'d6
\f0 (1-4)" && exit 1\
	fi\
\}\
Install_BBR()\{\
	[[ $\{release\} = "centos" ]] && echo -e "$\{Error\} 
\f1 \'b1\'be\'bd\'c5\'b1\'be\'b2\'bb\'d6\'a7\'b3\'d6
\f0  CentOS
\f1 \'cf\'b5\'cd\'b3\'b0\'b2\'d7\'b0
\f0  BBR !" && exit 1\
	BBR_installation_status\
	bash "$\{BBR_file\}"\
\}\
Start_BBR()\{\
	BBR_installation_status\
	bash "$\{BBR_file\}" start\
\}\
Stop_BBR()\{\
	BBR_installation_status\
	bash "$\{BBR_file\}" stop\
\}\
Status_BBR()\{\
	BBR_installation_status\
	bash "$\{BBR_file\}" status\
\}\
# 
\f1 \'c6\'e4\'cb\'fb\'b9\'a6\'c4\'dc
\f0 \
Other_functions()\{\
	echo && echo -e "  
\f1 \'c4\'e3\'d2\'aa\'d7\'f6\'ca\'b2\'c3\'b4\'a3\'bf
\f0 \
	\
  $\{Green_font_prefix\}1.$\{Font_color_suffix\} 
\f1 \'c5\'e4\'d6\'c3
\f0  BBR\
  $\{Green_font_prefix\}2.$\{Font_color_suffix\} 
\f1 \'c5\'e4\'d6\'c3
\f0  
\f1 \'c8\'f1\'cb\'d9
\f0 (ServerSpeeder)\
  $\{Green_font_prefix\}3.$\{Font_color_suffix\} 
\f1 \'c5\'e4\'d6\'c3
\f0  LotServer(
\f1 \'c8\'f1\'cb\'d9\'c4\'b8\'b9\'ab\'cb\'be
\f0 )\
  $\{Tip\} 
\f1 \'c8\'f1\'cb\'d9
\f0 /LotServer/BBR 
\f1 \'b2\'bb\'d6\'a7\'b3\'d6
\f0  OpenVZ
\f1 \'a3\'a1
\f0 \
  $\{Tip\} 
\f1 \'c8\'f1\'cb\'d9\'ba\'cd
\f0 LotServer
\f1 \'b2\'bb\'c4\'dc\'b9\'b2\'b4\'e6\'a3\'a1
\f0 \
\'97\'97\'97\'97\'97\'97\'97\'97\'97\'97\'97\'97\
  $\{Green_font_prefix\}4.$\{Font_color_suffix\} 
\f1 \'d2\'bb\'bc\'fc\'b7\'e2\'bd\'fb
\f0  BT/PT/SPAM (iptables)\
  $\{Green_font_prefix\}5.$\{Font_color_suffix\} 
\f1 \'d2\'bb\'bc\'fc\'bd\'e2\'b7\'e2
\f0  BT/PT/SPAM (iptables)\
\'97\'97\'97\'97\'97\'97\'97\'97\'97\'97\'97\'97\
  $\{Green_font_prefix\}6.$\{Font_color_suffix\} 
\f1 \'c7\'d0\'bb\'bb
\f0  ShadowsocksR
\f1 \'c8\'d5\'d6\'be\'ca\'e4\'b3\'f6\'c4\'a3\'ca\'bd
\f0 \
  \'97\'97 
\f1 \'cb\'b5\'c3\'f7\'a3\'ba
\f0 SSR
\f1 \'c4\'ac\'c8\'cf\'d6\'bb\'ca\'e4\'b3\'f6\'b4\'ed\'ce\'f3\'c8\'d5\'d6\'be\'a3\'ac\'b4\'cb\'cf\'ee\'bf\'c9\'c7\'d0\'bb\'bb\'ce\'aa\'ca\'e4\'b3\'f6\'cf\'ea\'cf\'b8\'b5\'c4\'b7\'c3\'ce\'ca\'c8\'d5\'d6\'be\'a1\'a3
\f0 \
  $\{Green_font_prefix\}7.$\{Font_color_suffix\} 
\f1 \'bc\'e0\'bf\'d8
\f0  ShadowsocksR
\f1 \'b7\'fe\'ce\'f1\'b6\'cb\'d4\'cb\'d0\'d0\'d7\'b4\'cc\'ac
\f0 \
  \'97\'97 
\f1 \'cb\'b5\'c3\'f7\'a3\'ba\'b8\'c3\'b9\'a6\'c4\'dc\'ca\'ca\'ba\'cf\'d3\'da
\f0 SSR
\f1 \'b7\'fe\'ce\'f1\'b6\'cb\'be\'ad\'b3\'a3\'bd\'f8\'b3\'cc\'bd\'e1\'ca\'f8\'a3\'ac\'c6\'f4\'b6\'af\'b8\'c3\'b9\'a6\'c4\'dc\'ba\'f3\'bb\'e1\'c3\'bf\'b7\'d6\'d6\'d3\'bc\'ec\'b2\'e2\'d2\'bb\'b4\'ce\'a3\'ac\'b5\'b1\'bd\'f8\'b3\'cc\'b2\'bb\'b4\'e6\'d4\'da\'d4\'f2\'d7\'d4\'b6\'af\'c6\'f4\'b6\'af
\f0 SSR
\f1 \'b7\'fe\'ce\'f1\'b6\'cb\'a1\'a3
\f0 " && echo\
	stty erase '^H' && read -p "(
\f1 \'c4\'ac\'c8\'cf
\f0 : 
\f1 \'c8\'a1\'cf\'fb
\f0 ):" other_num\
	[[ -z "$\{other_num\}" ]] && echo "
\f1 \'d2\'d1\'c8\'a1\'cf\'fb
\f0 ..." && exit 1\
	if [[ $\{other_num\} == "1" ]]; then\
		Configure_BBR\
	elif [[ $\{other_num\} == "2" ]]; then\
		Configure_Server_Speeder\
	elif [[ $\{other_num\} == "3" ]]; then\
		Configure_LotServer\
	elif [[ $\{other_num\} == "4" ]]; then\
		BanBTPTSPAM\
	elif [[ $\{other_num\} == "5" ]]; then\
		UnBanBTPTSPAM\
	elif [[ $\{other_num\} == "6" ]]; then\
		Set_config_connect_verbose_info\
	elif [[ $\{other_num\} == "7" ]]; then\
		Set_crontab_monitor_ssr\
	else\
		echo -e "$\{Error\} 
\f1 \'c7\'eb\'ca\'e4\'c8\'eb\'d5\'fd\'c8\'b7\'b5\'c4\'ca\'fd\'d7\'d6
\f0  [1-7]" && exit 1\
	fi\
\}\
# 
\f1 \'b7\'e2\'bd\'fb
\f0  BT PT SPAM\
BanBTPTSPAM()\{\
	wget -N --no-check-certificate https://raw.githubusercontent.com/ToyoDAdoubi/doubi/master/ban_iptables.sh && chmod +x ban_iptables.sh && bash ban_iptables.sh banall\
	rm -rf ban_iptables.sh\
\}\
# 
\f1 \'bd\'e2\'b7\'e2
\f0  BT PT SPAM\
UnBanBTPTSPAM()\{\
	wget -N --no-check-certificate https://raw.githubusercontent.com/ToyoDAdoubi/doubi/master/ban_iptables.sh && chmod +x ban_iptables.sh && bash ban_iptables.sh unbanall\
	rm -rf ban_iptables.sh\
\}\
Set_config_connect_verbose_info()\{\
	SSR_installation_status\
	[[ ! -e $\{jq_file\} ]] && echo -e "$\{Error\} JQ
\f1 \'bd\'e2\'ce\'f6\'c6\'f7
\f0  
\f1 \'b2\'bb\'b4\'e6\'d4\'da\'a3\'ac\'c7\'eb\'bc\'ec\'b2\'e9
\f0  !" && exit 1\
	connect_verbose_info=`$\{jq_file\} '.connect_verbose_info' $\{config_user_file\}`\
	if [[ $\{connect_verbose_info\} = "0" ]]; then\
		echo && echo -e "
\f1 \'b5\'b1\'c7\'b0\'c8\'d5\'d6\'be\'c4\'a3\'ca\'bd
\f0 : $\{Green_font_prefix\}
\f1 \'bc\'f2\'b5\'a5\'c4\'a3\'ca\'bd\'a3\'a8\'d6\'bb\'ca\'e4\'b3\'f6\'b4\'ed\'ce\'f3\'c8\'d5\'d6\'be\'a3\'a9
\f0 $\{Font_color_suffix\}" && echo\
		echo -e "
\f1 \'c8\'b7\'b6\'a8\'d2\'aa\'c7\'d0\'bb\'bb\'ce\'aa
\f0  $\{Green_font_prefix\}
\f1 \'cf\'ea\'cf\'b8\'c4\'a3\'ca\'bd\'a3\'a8\'ca\'e4\'b3\'f6\'cf\'ea\'cf\'b8\'c1\'ac\'bd\'d3\'c8\'d5\'d6\'be
\f0 +
\f1 \'b4\'ed\'ce\'f3\'c8\'d5\'d6\'be\'a3\'a9
\f0 $\{Font_color_suffix\}
\f1 \'a3\'bf
\f0 [y/N]"\
		stty erase '^H' && read -p "(
\f1 \'c4\'ac\'c8\'cf
\f0 : n):" connect_verbose_info_ny\
		[[ -z "$\{connect_verbose_info_ny\}" ]] && connect_verbose_info_ny="n"\
		if [[ $\{connect_verbose_info_ny\} == [Yy] ]]; then\
			ssr_connect_verbose_info="1"\
			Modify_config_connect_verbose_info\
			Restart_SSR\
		else\
			echo && echo "	
\f1 \'d2\'d1\'c8\'a1\'cf\'fb
\f0 ..." && echo\
		fi\
	else\
		echo && echo -e "
\f1 \'b5\'b1\'c7\'b0\'c8\'d5\'d6\'be\'c4\'a3\'ca\'bd
\f0 : $\{Green_font_prefix\}
\f1 \'cf\'ea\'cf\'b8\'c4\'a3\'ca\'bd\'a3\'a8\'ca\'e4\'b3\'f6\'cf\'ea\'cf\'b8\'c1\'ac\'bd\'d3\'c8\'d5\'d6\'be
\f0 +
\f1 \'b4\'ed\'ce\'f3\'c8\'d5\'d6\'be\'a3\'a9
\f0 $\{Font_color_suffix\}" && echo\
		echo -e "
\f1 \'c8\'b7\'b6\'a8\'d2\'aa\'c7\'d0\'bb\'bb\'ce\'aa
\f0  $\{Green_font_prefix\}
\f1 \'bc\'f2\'b5\'a5\'c4\'a3\'ca\'bd\'a3\'a8\'d6\'bb\'ca\'e4\'b3\'f6\'b4\'ed\'ce\'f3\'c8\'d5\'d6\'be\'a3\'a9
\f0 $\{Font_color_suffix\}
\f1 \'a3\'bf
\f0 [y/N]"\
		stty erase '^H' && read -p "(
\f1 \'c4\'ac\'c8\'cf
\f0 : n):" connect_verbose_info_ny\
		[[ -z "$\{connect_verbose_info_ny\}" ]] && connect_verbose_info_ny="n"\
		if [[ $\{connect_verbose_info_ny\} == [Yy] ]]; then\
			ssr_connect_verbose_info="0"\
			Modify_config_connect_verbose_info\
			Restart_SSR\
		else\
			echo && echo "	
\f1 \'d2\'d1\'c8\'a1\'cf\'fb
\f0 ..." && echo\
		fi\
	fi\
\}\
Set_crontab_monitor_ssr()\{\
	SSR_installation_status\
	crontab_monitor_ssr_status=$(crontab -l|grep "ssrmu.sh monitor")\
	if [[ -z "$\{crontab_monitor_ssr_status\}" ]]; then\
		echo && echo -e "
\f1 \'b5\'b1\'c7\'b0\'bc\'e0\'bf\'d8\'c4\'a3\'ca\'bd
\f0 : $\{Green_font_prefix\}
\f1 \'ce\'b4\'bf\'aa\'c6\'f4
\f0 $\{Font_color_suffix\}" && echo\
		echo -e "
\f1 \'c8\'b7\'b6\'a8\'d2\'aa\'bf\'aa\'c6\'f4\'ce\'aa
\f0  $\{Green_font_prefix\}ShadowsocksR
\f1 \'b7\'fe\'ce\'f1\'b6\'cb\'d4\'cb\'d0\'d0\'d7\'b4\'cc\'ac\'bc\'e0\'bf\'d8
\f0 $\{Font_color_suffix\} 
\f1 \'b9\'a6\'c4\'dc\'c2\'f0\'a3\'bf
\f0 (
\f1 \'b5\'b1\'bd\'f8\'b3\'cc\'b9\'d8\'b1\'d5\'d4\'f2\'d7\'d4\'b6\'af\'c6\'f4\'b6\'af
\f0 SSR
\f1 \'b7\'fe\'ce\'f1\'b6\'cb
\f0 )[Y/n]"\
		stty erase '^H' && read -p "(
\f1 \'c4\'ac\'c8\'cf
\f0 : y):" crontab_monitor_ssr_status_ny\
		[[ -z "$\{crontab_monitor_ssr_status_ny\}" ]] && crontab_monitor_ssr_status_ny="y"\
		if [[ $\{crontab_monitor_ssr_status_ny\} == [Yy] ]]; then\
			crontab_monitor_ssr_cron_start\
		else\
			echo && echo "	
\f1 \'d2\'d1\'c8\'a1\'cf\'fb
\f0 ..." && echo\
		fi\
	else\
		echo && echo -e "
\f1 \'b5\'b1\'c7\'b0\'bc\'e0\'bf\'d8\'c4\'a3\'ca\'bd
\f0 : $\{Green_font_prefix\}
\f1 \'d2\'d1\'bf\'aa\'c6\'f4
\f0 $\{Font_color_suffix\}" && echo\
		echo -e "
\f1 \'c8\'b7\'b6\'a8\'d2\'aa\'b9\'d8\'b1\'d5\'ce\'aa
\f0  $\{Green_font_prefix\}ShadowsocksR
\f1 \'b7\'fe\'ce\'f1\'b6\'cb\'d4\'cb\'d0\'d0\'d7\'b4\'cc\'ac\'bc\'e0\'bf\'d8
\f0 $\{Font_color_suffix\} 
\f1 \'b9\'a6\'c4\'dc\'c2\'f0\'a3\'bf
\f0 (
\f1 \'b5\'b1\'bd\'f8\'b3\'cc\'b9\'d8\'b1\'d5\'d4\'f2\'d7\'d4\'b6\'af\'c6\'f4\'b6\'af
\f0 SSR
\f1 \'b7\'fe\'ce\'f1\'b6\'cb
\f0 )[y/N]"\
		stty erase '^H' && read -p "(
\f1 \'c4\'ac\'c8\'cf
\f0 : n):" crontab_monitor_ssr_status_ny\
		[[ -z "$\{crontab_monitor_ssr_status_ny\}" ]] && crontab_monitor_ssr_status_ny="n"\
		if [[ $\{crontab_monitor_ssr_status_ny\} == [Yy] ]]; then\
			crontab_monitor_ssr_cron_stop\
		else\
			echo && echo "	
\f1 \'d2\'d1\'c8\'a1\'cf\'fb
\f0 ..." && echo\
		fi\
	fi\
\}\
crontab_monitor_ssr()\{\
	SSR_installation_status\
	check_pid\
	if [[ -z $\{PID\} ]]; then\
		echo -e "$\{Error\} [$(date "+%Y-%m-%d %H:%M:%S %u %Z")] 
\f1 \'bc\'ec\'b2\'e2\'b5\'bd
\f0  ShadowsocksR
\f1 \'b7\'fe\'ce\'f1\'b6\'cb
\f0  
\f1 \'ce\'b4\'d4\'cb\'d0\'d0
\f0  , 
\f1 \'bf\'aa\'ca\'bc\'c6\'f4\'b6\'af
\f0 ..." | tee -a $\{ssr_log_file\}\
		/etc/init.d/ssrmu start\
		sleep 1s\
		check_pid\
		if [[ -z $\{PID\} ]]; then\
			echo -e "$\{Error\} [$(date "+%Y-%m-%d %H:%M:%S %u %Z")] ShadowsocksR
\f1 \'b7\'fe\'ce\'f1\'b6\'cb
\f0  
\f1 \'c6\'f4\'b6\'af\'ca\'a7\'b0\'dc
\f0 ..." | tee -a $\{ssr_log_file\} && exit 1\
		else\
			echo -e "$\{Info\} [$(date "+%Y-%m-%d %H:%M:%S %u %Z")] ShadowsocksR
\f1 \'b7\'fe\'ce\'f1\'b6\'cb
\f0  
\f1 \'c6\'f4\'b6\'af\'b3\'c9\'b9\'a6
\f0 ..." | tee -a $\{ssr_log_file\} && exit 1\
		fi\
	else\
		echo -e "$\{Info\} [$(date "+%Y-%m-%d %H:%M:%S %u %Z")] ShadowsocksR
\f1 \'b7\'fe\'ce\'f1\'b6\'cb
\f0  
\f1 \'bd\'f8\'b3\'cc\'d4\'cb\'d0\'d0\'d5\'fd\'b3\'a3
\f0 ..." exit 0\
	fi\
\}\
crontab_monitor_ssr_cron_start()\{\
	crontab -l > "$file/crontab.bak"\
	sed -i "/ssrmu.sh monitor/d" "$file/crontab.bak"\
	echo -e "\\n* * * * * /bin/bash $file/ssrmu.sh monitor" >> "$file/crontab.bak"\
	crontab "$file/crontab.bak"\
	rm -r "$file/crontab.bak"\
	cron_config=$(crontab -l | grep "ssrmu.sh monitor")\
	if [[ -z $\{cron_config\} ]]; then\
		echo -e "$\{Error\} ShadowsocksR
\f1 \'b7\'fe\'ce\'f1\'b6\'cb\'d4\'cb\'d0\'d0\'d7\'b4\'cc\'ac\'bc\'e0\'bf\'d8\'b9\'a6\'c4\'dc
\f0  
\f1 \'c6\'f4\'b6\'af\'ca\'a7\'b0\'dc
\f0  !" && exit 1\
	else\
		echo -e "$\{Info\} ShadowsocksR
\f1 \'b7\'fe\'ce\'f1\'b6\'cb\'d4\'cb\'d0\'d0\'d7\'b4\'cc\'ac\'bc\'e0\'bf\'d8\'b9\'a6\'c4\'dc
\f0  
\f1 \'c6\'f4\'b6\'af\'b3\'c9\'b9\'a6
\f0  !"\
	fi\
\}\
crontab_monitor_ssr_cron_stop()\{\
	crontab -l > "$file/crontab.bak"\
	sed -i "/ssrmu.sh monitor/d" "$file/crontab.bak"\
	crontab "$file/crontab.bak"\
	rm -r "$file/crontab.bak"\
	cron_config=$(crontab -l | grep "ssrmu.sh monitor")\
	if [[ ! -z $\{cron_config\} ]]; then\
		echo -e "$\{Error\} ShadowsocksR
\f1 \'b7\'fe\'ce\'f1\'b6\'cb\'d4\'cb\'d0\'d0\'d7\'b4\'cc\'ac\'bc\'e0\'bf\'d8\'b9\'a6\'c4\'dc
\f0  
\f1 \'cd\'a3\'d6\'b9\'ca\'a7\'b0\'dc
\f0  !" && exit 1\
	else\
		echo -e "$\{Info\} ShadowsocksR
\f1 \'b7\'fe\'ce\'f1\'b6\'cb\'d4\'cb\'d0\'d0\'d7\'b4\'cc\'ac\'bc\'e0\'bf\'d8\'b9\'a6\'c4\'dc
\f0  
\f1 \'cd\'a3\'d6\'b9\'b3\'c9\'b9\'a6
\f0  !"\
	fi\
\}\
Update_Shell()\{\
	echo -e "
\f1 \'b5\'b1\'c7\'b0\'b0\'e6\'b1\'be\'ce\'aa
\f0  [ $\{sh_ver\} ]
\f1 \'a3\'ac\'bf\'aa\'ca\'bc\'bc\'ec\'b2\'e2\'d7\'ee\'d0\'c2\'b0\'e6\'b1\'be
\f0 ..."\
	sh_new_ver=$(wget --no-check-certificate -qO- "https://softs.fun/Bash/ssrmu.sh"|grep 'sh_ver="'|awk -F "=" '\{print $NF\}'|sed 's/\\"//g'|head -1) && sh_new_type="softs"\
	[[ -z $\{sh_new_ver\} ]] && sh_new_ver=$(wget --no-check-certificate -qO- "https://raw.githubusercontent.com/ToyoDAdoubi/doubi/master/ssrmu.sh"|grep 'sh_ver="'|awk -F "=" '\{print $NF\}'|sed 's/\\"//g'|head -1) && sh_new_type="github"\
	[[ -z $\{sh_new_ver\} ]] && echo -e "$\{Error\} 
\f1 \'bc\'ec\'b2\'e2\'d7\'ee\'d0\'c2\'b0\'e6\'b1\'be\'ca\'a7\'b0\'dc
\f0  !" && exit 0\
	if [[ $\{sh_new_ver\} != $\{sh_ver\} ]]; then\
		echo -e "
\f1 \'b7\'a2\'cf\'d6\'d0\'c2\'b0\'e6\'b1\'be
\f0 [ $\{sh_new_ver\} ]
\f1 \'a3\'ac\'ca\'c7\'b7\'f1\'b8\'fc\'d0\'c2\'a3\'bf
\f0 [Y/n]"\
		stty erase '^H' && read -p "(
\f1 \'c4\'ac\'c8\'cf
\f0 : y):" yn\
		[[ -z "$\{yn\}" ]] && yn="y"\
		if [[ $\{yn\} == [Yy] ]]; then\
			cd "$\{file\}"\
			if [[ $sh_new_type == "softs" ]]; then\
				wget -N --no-check-certificate https://softs.fun/Bash/ssrmu.sh && chmod +x ssrmu.sh\
			else\
				wget -N --no-check-certificate https://raw.githubusercontent.com/ToyoDAdoubi/doubi/master/ssrmu.sh && chmod +x ssrmu.sh\
			fi\
			echo -e "
\f1 \'bd\'c5\'b1\'be\'d2\'d1\'b8\'fc\'d0\'c2\'ce\'aa\'d7\'ee\'d0\'c2\'b0\'e6\'b1\'be
\f0 [ $\{sh_new_ver\} ] !"\
		else\
			echo && echo "	
\f1 \'d2\'d1\'c8\'a1\'cf\'fb
\f0 ..." && echo\
		fi\
	else\
		echo -e "
\f1 \'b5\'b1\'c7\'b0\'d2\'d1\'ca\'c7\'d7\'ee\'d0\'c2\'b0\'e6\'b1\'be
\f0 [ $\{sh_new_ver\} ] !"\
	fi\
	exit 0\
\}\
# 
\f1 \'cf\'d4\'ca\'be
\f0  
\f1 \'b2\'cb\'b5\'a5\'d7\'b4\'cc\'ac
\f0 \
menu_status()\{\
	if [[ -e $\{ssr_folder\} ]]; then\
		check_pid\
		if [[ ! -z "$\{PID\}" ]]; then\
			echo -e " 
\f1 \'b5\'b1\'c7\'b0\'d7\'b4\'cc\'ac
\f0 : $\{Green_font_prefix\}
\f1 \'d2\'d1\'b0\'b2\'d7\'b0
\f0 $\{Font_color_suffix\} 
\f1 \'b2\'a2
\f0  $\{Green_font_prefix\}
\f1 \'d2\'d1\'c6\'f4\'b6\'af
\f0 $\{Font_color_suffix\}"\
		else\
			echo -e " 
\f1 \'b5\'b1\'c7\'b0\'d7\'b4\'cc\'ac
\f0 : $\{Green_font_prefix\}
\f1 \'d2\'d1\'b0\'b2\'d7\'b0
\f0 $\{Font_color_suffix\} 
\f1 \'b5\'ab
\f0  $\{Red_font_prefix\}
\f1 \'ce\'b4\'c6\'f4\'b6\'af
\f0 $\{Font_color_suffix\}"\
		fi\
		cd "$\{ssr_folder\}"\
	else\
		echo -e " 
\f1 \'b5\'b1\'c7\'b0\'d7\'b4\'cc\'ac
\f0 : $\{Red_font_prefix\}
\f1 \'ce\'b4\'b0\'b2\'d7\'b0
\f0 $\{Font_color_suffix\}"\
	fi\
\}\
check_sys\
[[ $\{release\} != "debian" ]] && [[ $\{release\} != "ubuntu" ]] && [[ $\{release\} != "centos" ]] && echo -e "$\{Error\} 
\f1 \'b1\'be\'bd\'c5\'b1\'be\'b2\'bb\'d6\'a7\'b3\'d6\'b5\'b1\'c7\'b0\'cf\'b5\'cd\'b3
\f0  $\{release\} !" && exit 1\
action=$1\
if [[ "$\{action\}" == "clearall" ]]; then\
	Clear_transfer_all\
elif [[ "$\{action\}" == "monitor" ]]; then\
	crontab_monitor_ssr\
else\
	echo -e "  ShadowsocksR MuJSON
\f1 \'d2\'bb\'bc\'fc\'b9\'dc\'c0\'ed\'bd\'c5\'b1\'be
\f0  $\{Red_font_prefix\}[v$\{sh_ver\}]$\{Font_color_suffix\}\
  ---- Toyo | doub.io/ss-jc60 ----\
\
  $\{Green_font_prefix\}1.$\{Font_color_suffix\} 
\f1 \'b0\'b2\'d7\'b0
\f0  ShadowsocksR\
  $\{Green_font_prefix\}2.$\{Font_color_suffix\} 
\f1 \'b8\'fc\'d0\'c2
\f0  ShadowsocksR\
  $\{Green_font_prefix\}3.$\{Font_color_suffix\} 
\f1 \'d0\'b6\'d4\'d8
\f0  ShadowsocksR\
  $\{Green_font_prefix\}4.$\{Font_color_suffix\} 
\f1 \'b0\'b2\'d7\'b0
\f0  libsodium(chacha20)\
\'97\'97\'97\'97\'97\'97\'97\'97\'97\'97\'97\'97\
  $\{Green_font_prefix\}5.$\{Font_color_suffix\} 
\f1 \'b2\'e9\'bf\'b4
\f0  
\f1 \'d5\'cb\'ba\'c5\'d0\'c5\'cf\'a2
\f0 \
  $\{Green_font_prefix\}6.$\{Font_color_suffix\} 
\f1 \'cf\'d4\'ca\'be
\f0  
\f1 \'c1\'ac\'bd\'d3\'d0\'c5\'cf\'a2
\f0 \
  $\{Green_font_prefix\}7.$\{Font_color_suffix\} 
\f1 \'c9\'e8\'d6\'c3
\f0  
\f1 \'d3\'c3\'bb\'a7\'c5\'e4\'d6\'c3
\f0 \
  $\{Green_font_prefix\}8.$\{Font_color_suffix\} 
\f1 \'ca\'d6\'b6\'af
\f0  
\f1 \'d0\'de\'b8\'c4\'c5\'e4\'d6\'c3
\f0 \
  $\{Green_font_prefix\}9.$\{Font_color_suffix\} 
\f1 \'c7\'e5\'c1\'e3
\f0  
\f1 \'d2\'d1\'d3\'c3\'c1\'f7\'c1\'bf
\f0 \
\'97\'97\'97\'97\'97\'97\'97\'97\'97\'97\'97\'97\
 $\{Green_font_prefix\}10.$\{Font_color_suffix\} 
\f1 \'c6\'f4\'b6\'af
\f0  ShadowsocksR\
 $\{Green_font_prefix\}11.$\{Font_color_suffix\} 
\f1 \'cd\'a3\'d6\'b9
\f0  ShadowsocksR\
 $\{Green_font_prefix\}12.$\{Font_color_suffix\} 
\f1 \'d6\'d8\'c6\'f4
\f0  ShadowsocksR\
 $\{Green_font_prefix\}13.$\{Font_color_suffix\} 
\f1 \'b2\'e9\'bf\'b4
\f0  ShadowsocksR 
\f1 \'c8\'d5\'d6\'be
\f0 \
\'97\'97\'97\'97\'97\'97\'97\'97\'97\'97\'97\'97\
 $\{Green_font_prefix\}14.$\{Font_color_suffix\} 
\f1 \'c6\'e4\'cb\'fb\'b9\'a6\'c4\'dc
\f0 \
 $\{Green_font_prefix\}15.$\{Font_color_suffix\} 
\f1 \'c9\'fd\'bc\'b6\'bd\'c5\'b1\'be
\f0 \
 "\
	menu_status\
	echo && stty erase '^H' && read -p "
\f1 \'c7\'eb\'ca\'e4\'c8\'eb\'ca\'fd\'d7\'d6
\f0  [1-15]
\f1 \'a3\'ba
\f0 " num\
case "$num" in\
	1)\
	Install_SSR\
	;;\
	2)\
	Update_SSR\
	;;\
	3)\
	Uninstall_SSR\
	;;\
	4)\
	Install_Libsodium\
	;;\
	5)\
	View_User\
	;;\
	6)\
	View_user_connection_info\
	;;\
	7)\
	Modify_Config\
	;;\
	8)\
	Manually_Modify_Config\
	;;\
	9)\
	Clear_transfer\
	;;\
	10)\
	Start_SSR\
	;;\
	11)\
	Stop_SSR\
	;;\
	12)\
	Restart_SSR\
	;;\
	13)\
	View_Log\
	;;\
	14)\
	Other_functions\
	;;\
	15)\
	Update_Shell\
	;;\
	*)\
	echo -e "$\{Error\} 
\f1 \'c7\'eb\'ca\'e4\'c8\'eb\'d5\'fd\'c8\'b7\'b5\'c4\'ca\'fd\'d7\'d6
\f0  [1-15]"\
	;;\
esac\
fi\
}