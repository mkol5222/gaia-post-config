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

run_only_once() {
    local postconfigflagfile=/var/run/post_config_completed
    if [ ! -f  $postconfigflagfile ]; then 
        # Code to run only on the first boot 
        # ... 
        print_info "Running only once $(date)"
        
        # Create the flag file to indicate that the code has been executed 
        touch $postconfigflagfile
    fi
}


main() {
    create_log_file
    print_info "Test info message"

    if [ -f /etc/rc3.d/S99$base ]; then
        print_info "Run on reboot already setup"
        run_only_once
    else
        print_info "Setting up run on reboot"
        setup_run_on_reboot
    fi
    
}

log_file=/var/log/post-config.log
main "$@" 2>&1 1>"$log_file" | tee -a "$log_file"
