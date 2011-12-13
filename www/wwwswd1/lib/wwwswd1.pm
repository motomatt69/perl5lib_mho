package wwwswd1;
use Dancer ':syntax';
use File::Slurp;

our $VERSION = '0.1';

get '/' => sub {
    my $p = config->{database}{json};
    my $json = read_file($p) if -e $p;
    my $data = ($json) ? from_json($json) : {};
    
    template 'index', {data => $data};
};

get '/testseite' => sub{
    template 'testseite'
};

post '/testseite' => sub{
    my $p = config->{database}{json};
    my $json = read_file($p) if -e $p;
    my $data = ($json) ? from_json($json) : {};
    
    my $now = time;
    $data->{$now} = {
        title => params->{title},
        text  => params->{text},
    };
    
    write_file ($p, to_json $data);
    
    redirect '/';
};

true;
