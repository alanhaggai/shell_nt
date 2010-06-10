package Shell_NT::System;

24; #require

#
# It is supposed to be a true fork to enable
# a second plane
#

sub system_fallback {

    my ($self, $command, @args) = @_;

    for $path (split(/:/ , $ENV{PATH}) ) {
        if ( -x "$path/$command" ){
            print "run: $path/$command @args\n";
            system("$path/$command @args");
            #$self->process_out( @output );
            return 0;
        }
    }

    return 1;
}


# 
# system_fallback and process_out should be 
# forked and processed in background
# 

sub process_out {

    my ($self, @output) = @_;

    my $i = (scalar @output) -1 ;

    for my $line ( @output ) {

        push @{ $self->{out_stack} }, $line;

        print "$i: $line";

    }



}

