    #!/usr/bin/perl

    use Dancer;

    get '/hello/:name' => sub {
        return "Why, hello there " . params->{name};
    };

    dance