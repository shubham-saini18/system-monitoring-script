# System Monitoring Scripts

## Overview
This project consists of a Bash script that monitors key system metrics, including CPU usage, memory usage, and disk space usage. The script provides a user-friendly interface and supports continuous monitoring with a customizable sleep interval. Additionally, it allows you to monitor specific services like Nginx and provides options to start them if they are not running.

## Features
- **CPU Usage Monitoring**: Displays real-time CPU load.
- **Memory Usage Monitoring**: Shows used and total memory.
- **Disk Space Monitoring**: Lists the disk space usage of mounted file systems.
- **Service Monitoring**: Check the status of specified services (e.g., Nginx) and offers the ability to start them.
- **User-Friendly Interface**: Easy-to-navigate menu for selecting options.
- **Continuous Monitoring**: Runs in a loop with a configurable sleep interval.

## Installation
To use these scripts, follow these steps:

1. **Clone the Repository**:
   ```bash
   git clone https://github.com/shubham-saini18/system-monitoring-script.git
2. Navigate to the Directory:
   ```bash
    cd system-monitoring-script
3. Make the Script Executable:
   ```bash
   chmod +x system_monitor.sh

   
Usage
Run the script using the following command:
```bash
./system_monitor.sh

Menu Options
Once the script is running, you'll see a menu with the following options:

1. View CPU Usage
2. View Memory Usage
3. View Disk Space Usage
4. Monitor a Service
5. Exit


