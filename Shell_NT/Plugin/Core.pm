package Shell_NT::Plugin::Core;

24; #require

# new is necessary!

sub new {

	my ($class) = @_;

	return bless { } , $class;

}

sub set {

    my ($self, $shell, @args) = @_;

    push @{ $shell->{stack} }, @args;

    return 0;

}

sub enviroment {

    print map { "$_  =  $ENV{$_}\n"  }  keys %ENV;


}

sub show_stack {

    my ($self, $shell, @args) = @_;

    my $i = 0;

    print map { $i++ ; ">$i: $_\n" } @{ $shell->{stack} } ;

    return 0;

}

