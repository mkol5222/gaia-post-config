#!/bin/bash

base=zzzz_post_config

create_log_file() {
    : >"$log_file"
    echo "$(date) : Starting post-config.sh"
}

print_info() {
  echo "$@"
}

setup_run_on_reboot() {
    # Run this script every startup
    # local base=zzzz_post_config
    local origpath=/tmp/post-config.sh

    if [[ ! -f /etc/rc3.d/S99$base ]]; then
        chmod +x $origpath
        cp $origpath /etc/init.d/$base
        ln -s /etc/init.d/$base /etc/rc3.d/S99$base
    fi
}

call_once() {
    echo Once
    date
    touch /var/log/hello.txt
    #cd /var/opt/CPsuite-R81.10/fw1/conf/; cp azure-ha.json azure-ha.json.orig; cat azure-ha.json.orig | jq -r '.clusterNetworkInterfaces.nic1=.clusterNetworkInterfaces.eth0 | del(.clusterNetworkInterfaces.eth0)' > azure-ha.json
    #cd /var/opt/CPsuite-R81.10/fw1/conf/; cp azure-ha.json azure-ha.json.orig; cat azure-ha.json.orig | jq -r '.clusterNetworkInterfaces.nic1=.clusterNetworkInterfaces.eth0 | del(.clusterNetworkInterfaces.eth0) | del(.clusterNetworkInterfaces.nic1[].pub)' > azure-ha.json
    echo Once done
}

call_always() {
    echo Always
    date
    echo Always done
}

run() {
    local postconfigflagfile=/var/log/post_config_completed
    if [ ! -f  $postconfigflagfile ]; then 
        # Code to run only on the first boot 
        # ... 
        echo "Running only once $(date)" >> /var/log/run_once.log
        call_once 2>&1 1>/var/log/run_once.log
        
        # Create the flag file to indicate that the code has been executed 
        touch $postconfigflagfile
    fi

    echo "Running on each boot $(date)" >> /var/log/run_on_boot.log
    call_always 2>&1 1>/var/log/run_on_boot.log
}


main() {
    create_log_file
    print_info "Test info message"

    if [ -f /etc/rc3.d/S99$base ]; then
        print_info "Run on reboot already setup"
        run
    else
        print_info "Setting up run on reboot"
        setup_run_on_reboot
    fi
    
}

log_file=/var/log/post-config.log
main "$@" 2>&1 1>"$log_file" | tee -a "$log_file"
