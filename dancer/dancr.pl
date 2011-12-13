use DBI;
use Dancer;
use Template;

set 'views' => 'c:\perl5lib_mho\dancer\dancr\views';
set 'public' => 'c:\perl5lib_mho\dancer\dancr\public';
set 'database' => 'c:\perl5lib_mho\dancer\dancr\dancr_db.sqlite';
set 'session' => 'Simple';
set 'template' => 'template_toolkit';
set 'logger' => 'console';
set 'log' => 'debug';
set 'show_errors' => 1;
set 'access_log' => 1;
set 'warnings' => 1;
set 'username' => 'admin';
set 'password' => 'password';

layout 'main';

my $flash;

sub set_flash {
	my $message = shift;

	$flash = $message;
}

sub get_flash {

	my $msg = $flash;
	$flash = "";

	return $msg;
}

sub connect_db{
    my $dbh = DBI->connect("dbi:SQLite:dbname=".setting('database'))
        or die $DBI::errstr;
    
    return $dbh;
}

sub init_db {
    my $db = connect_db();
    #my $schema = read_file('.schema.sql');
    #$db->do($schema) or die $db->errstr;
}

before_template sub{
    my $tokens = shift;
    
    $tokens->{'css_url'} = request->base . 'css/style.css';
    $tokens->{'login_url'} = uri_for('/login');
    $tokens->{'logout_url'} = uri_for('/logout');
};

get '/' => sub{
    my $dbh = connect_db();
    my $sql = 'SELECT id, title, text FROM entries ORDER BY id DESC';
    my $sth = $dbh->prepare($sql) or die $dbh->errstr;
    $sth->execute or die $sth->errstr;
    template 'show_entries.tt', {
        'msg' => get_flash(),
        'add_entry_url' => uri_for('add'),
        'entries' => $sth->fetchall_hashref('id'),
    };
};

post '/add' => sub{
    if (not session('logged_in')){
        send_error("Not logged in", 401);
    }
    
    my $dbh = connect_db();
    my $sql = 'insert into entries (title, text) values (?, ?)';
    my $sth = $dbh->prepare($sql) or die $dbh->errstr;
    $sth->execute(params->{'title'}, params->{'text'}) or die $sth->errstr;
    
    set_flash('New entry posted!');
    redirect '/';
};

any ['get', 'post'] => '/login' => sub{
    my $err;
    
    if (request->method() eq 'POST'){
        #process form input
        if (params->{'username'} ne setting('username')){
            $err = "invalid username";
        }
        elsif(params->{'password'} ne setting('password')){
            $err = "Invalid password";
        }
        else{
            session 'logged_in' => true;
            set_flash('You are logged in.');
            redirect '/';
        }
    }
    
    #display login form
    template 'login.tt', {
        'err' => $err,
    };

};

get '/logout' => sub{
    session->destroy;
    set_flash('You are logged out.');
    redirect '/';
};

init_db();
start;