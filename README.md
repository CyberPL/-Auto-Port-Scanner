# Auto-Port-Scanner

By using bash script, I made an "auto_port_scanner" tool via help of some tools like Masscan, Rustscan and Nmap. Use all these tools because of accuracy and catch as much as open ports and service running on the port for better result. After getting all open ports by using "Nmap script scan" we can find a possible vulnerability on running services on an open port.


For using this tool first you need to:

1.Install masscan if masscan doesn't installed in your OS.

masscan github link :- https://github.com/robertdavidgraham/masscan

2.Install rustscan if rustscan doesn't installed in your OS.

rustscan github link :- https://github.com/RustScan/RustScan

3.Install Nmap if Nmap doesn't installed in your OS.

Nmap github link :- https://github.com/nmap/nmap

# Usage

sudo ./auto_port_scanner.sh targets.txt

![alt text](https://github.com/CyberPL/-Auto-Port-Scanner/blob/main/sample.png)
