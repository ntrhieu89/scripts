#!/bin/bash

#### Global variables ####
user='hieun'                                          # linux username (should be the same for all machines)
db_user='hieunguyen'                                  # DBMS username
db_pass='hieunguyen123'                               # DBMS password

clients=('10.0.0.210' '10.0.0.220' '10.0.0.175')      # list of clients needed to keep in sync
cores=('10.0.0.210' '10.0.0.220' '10.0.0.175')        # list of cores needed to keep in sync
coreport=8888

origin_client='10.0.0.220'                            # original client where contains the source to be copied
client_src="/home/$user/Desktop/BG"                   # bg source code 

origin_core='10.0.0.210'                              # original core
core_src="/home/$user/Desktop/Core"                   # core source code

dbms='10.0.0.195'                                     # DBMS

kosar_config_file='kosarOracle.cfg'
core_config_file='core.properties'

linux_stats_folder="/home/$user/Desktop/stats"

#### Exp variables ####
# num of connections with core and with each other clients
modes=('NO_CACHE' 'CACHE_NO_CORE' 'CACHE_WITH_CORE')
policies=('FULL_REPLICATE' 'STEAL' 'CONSUME')

mode=${modes[2]}
policy='FULL_REPLICATE'

# number of clients and cores to use
num_clients=1
num_cores=3

num_conns=20

num_users=10000
cfriends_per_user=10
pfriends_per_user=0
resources_per_user=0

workload='8SymmetricWorkload'



# write to file
write_to_file() {
	if [ ! -f $2 ];
	then
		echo "File $2 does not exist. Create new one."
	fi
	
	printf "$1" > "$2"
	
	if [ -f $2 ];
	then
		echo "Write to file $2... OK."
	fi
}

# gen kosar config
gen_kosar_config() {
    kosar_cfg=''
    case $1 in
        ${modes[0]})    kosar_cfg='kosarEnabled=false'
        	;;
        ${modes[1]})    kosar_cfg='kosarEnabled=true'
        	;;        
        ${modes[2]})    kosar_cfg='kosarEnabled=true'
        	;;
    esac
    
    kosar_cfg="$kosar_cfg\nwebserverport=9091"
    kosar_cfg="$kosar_cfg\nrdbms=oracle"
    kosar_cfg="$kosar_cfg\nrbmsdriver=oracle.jdbc.driver.OracleDriver"
    
    kosar_cfg="$kosar_cfg\ncores="
    for core in "${cores[@]}"
    do
    	kosar_cfg="$kosar_cfg$core:$coreport;"   	    	
    done
    
    kosar_cfg="$kosar_cfg\nwebserverport=9091"
    
    echo $kosar_cfg
}

## synchronize code ##
# sync clients
# make sure the config is correct
echo "Mode=$mode"

kosar_config=$(gen_kosar_config $mode)
echo "KOSAR config: "
echo $kosar_config
f="$client_src/$kosar_config_file"
#write_to_file $kosar_config $f
write_to_file $kosar_config /home/hieun/Desktop/test.txt
