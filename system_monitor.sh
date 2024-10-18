#!/bin/bash

# ==============================================================================
# Script Name: system_monitor.sh
# Author: Shubham Saini
# Version: 1.0
# Date: 2024-10-18
# Description: This script monitors system metrics such as CPU, memory, and disk
#              usage. It also checks the status of specified services and provides
#              a user-friendly menu for interaction. Continuous monitoring is
#              supported with a specified sleep interval.
# ==============================================================================

# ==============================================================================
# Functions Definitions
# ==============================================================================

# Function to display CPU usage
show_cpu_usage() {
    echo "CPU Usage:"
    top -bn1 | grep "Cpu(s)" | awk '{print "CPU Load: " $2 "%"}'
}

# Function to display memory usage
show_memory_usage() {
    echo "Memory Usage:"
    free -h | awk '/^Mem/ {print "Used: " $3 " / Total: " $2}'
}

# Function to display disk space usage
show_disk_usage() {
    echo "Disk Space Usage:"
    df -h | grep '^/dev/' | awk '{print $1 ": " $5 " used"}'
}

# Function to display menu
display_menu() {
    echo "===================="
    echo " System Monitoring "
    echo "===================="
    echo "1. View CPU Usage"
    echo "2. View Memory Usage"
    echo "3. View Disk Space Usage"
    echo "4. Monitor a Service"
    echo "5. Exit"
    echo -n "Enter your choice [1-5]: "
}

# Function to get sleep interval for continuous monitoring
get_sleep_interval() {
    echo -n "Enter how often you want to refresh the metrics (in seconds): "
    read sleep_interval
    # Validate if the sleep interval is a positive integer
    if ! [[ "$sleep_interval" =~ ^[0-9]+$ ]]; then
        echo "Invalid input. Please enter a positive number."
        get_sleep_interval
    fi
}

# Function to monitor a specific service
monitor_service() {
    local service_name=$1
    systemctl is-active --quiet $service_name
    if [ $? -eq 0 ]; then
        echo "$service_name is running."
    else
        echo "$service_name is not running."
        echo -n "Would you like to start $service_name? (y/n): "
        read start_choice
        if [ "$start_choice" == "y" ]; then
            sudo systemctl start $service_name
            if [ $? -eq 0 ]; then
                echo "$service_name started successfully."
            else
                echo "Failed to start $service_name. Please check the logs."
            fi
        else
            echo "No action taken for $service_name."
        fi
    fi
}

# Function to get service name from user
get_service_name() {
    echo -n "Enter the name of the service you want to monitor: "
    read service_name
    # Validate if the service name exists
    if ! systemctl list-units --type=service | grep -q "$service_name"; then
        echo "Service $service_name not found. Please check the service name."
        get_service_name
    else
        monitor_service $service_name
    fi
}

# ==============================================================================
# Main Program
# ==============================================================================

# Get sleep interval for continuous monitoring
get_sleep_interval

while true; do
    display_menu
    read choice
    case $choice in
    1) show_cpu_usage ;;
    2) show_memory_usage ;;
    3) show_disk_usage ;;
    4) get_service_name ;;
    5)
        echo "Exiting the script. Have a great day!"
        exit 0
        ;;
    *) echo "Invalid choice. Please select an option between 1 and 5." ;;
    esac
    echo ""
    sleep $sleep_interval
done

# ==============================================================================
# End of Script
# ==============================================================================
