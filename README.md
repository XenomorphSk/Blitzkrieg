Blitzkrieg

Blitzkrieg is a Perl script designed for network testing purposes. It allows you to perform various types of network attacks, such as SYN flooding and UDP flooding.
Features

    SYN Flood Attack
    UDP Flood Attack
    Multithreaded
    Customizable attack parameters

Prerequisites

    Perl
    Perl modules:
        Getopt::Long
        Socket
        Time::HiRes
        threads

Usage

bash

./Blitzkrieg.pl --ip=<target_ip> --port=<target_port> --time=<attack_time> --type=<attack_type>

Options

    --ip: Target IP address
    --port: Target port
    --time: Attack duration in seconds
    --type: Type of attack (syn, udp)

Example

bash

./Blitzkrieg.pl --ip=10.0.0.1 --port=80 --time=60 --type=syn

Disclaimer

This tool is intended for educational and testing purposes only. Use it responsibly and only on networks you have permission to test.
License

This project is licensed under the MIT License. See the LICENSE file for details.
