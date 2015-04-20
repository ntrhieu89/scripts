#### Utility functions ####
# verify file deleted
verify_file_del() {
	err=$(ls $1 2>&1)
	if [[ $err == *"No such file or directory"* ]]
	then
		echo "Verify del $1... OK."
	fi
}

# verify file exists
verify_file_exist() {
	err=$(ls $1 2>&1)
	if [[ $err == '' ]]
	then
		echo "Verify exist $1... OK."
	fi
}

# verify a process given process name is running or not
verify_proc_run() {
	
}

# copy BG to other machines
sync_clients() {
  for cli in "${clients[@]}"
  do
		if [ $cli = $origin_client ]
		then
			continue
		fi
		
		echo "Remove client $cli"
    ssh "$user@$cli rm -r $client_src"
    verify_file_del "$user@$cli ls $client_src" 
    
    echo "Create client $cli"    
    ssh "$user@$cli mkdir -p $client_src"
    verify_file_exist "$user@$cli ls $client_src" 
    
    scp -r "$user@$origin_client:$client_src/* $user@$cli:$client_src"
    echo "Copy bg client to $cli... OK."
  done 
}

# copy Core to other machines
sync_cores() {
    for core in "${cores[@]}"
    do
        if [ $core = $origin_core ]
        then
        	continue
        fi        
        
        echo "Remove core $core"
        ssh "$user@$core rm -r $core_src"
        verify_file_del "$user@$core ls $core_src" 
        
        echo "Create core $core"
        ssh "$user@$core mkdir -p $core_src"
        verify_file_exist "$user@$core ls $core_src" 
        
        scp -r "$user@$origin_core:$core_src/* $user@$core:$core_src"
        echo "Copy core to $core... OK."
    done 
}

# gen core config
gen_core_config() {
	
}

# kill clients and cores processes
kill_procs() {

}

# start statistics
# assume all clients and cores are LINUX machines, DBMS is Windows machine
start_stats() {
  for c in "${core[@]}"
  do
  	ssh "$user@$c killall sar"
	  ssh cd $linux_stats_folder | sh stats.sh
  done	
}


load_data() {

}

######################### Start the experiment #########################

## synchronize code ##
# sync clients
# make sure the config is correct
gen_kosar_config $mode
kosar_config=$?
echo "KOSAR config: "
echo $kosar_config
f="$client_src/$kosar_config_file"
write_to_file $kosar_config $f

sync_clients 

# sync core
gen_core_config $policy
core_config=$?
echo "Core config: "
echo $core_config
f="$core_src/$core_config_file"
write_to_file $core_config $f
sync_core

#### Prepare for experiment ####
# clean up
kill_procs

# load data
load_data

# start all the stats
start_stats

#### Run experiment ####

gather_data

stop_and_gather_stats

kill_procs

# analyze results #


# copy to specified folder

# generate graphs and CSVs

echo "Experiment finished."

