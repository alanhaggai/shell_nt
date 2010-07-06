package Shell_NT::Plugin::Perl_listsubs;
use base 'Shell_NT::Base';

24; #require

use warnings;
use strict;

use Data::Dumper;

# TODO : getopt reads from @ARGS, should take from @_ when specified

# simple list the subs from a file

sub listsubs {
	
    my ($self, $file ) = @_;
	my $ctx = $self->{ctx};

    my %subs = $self->_listsubs( $file );

    my ( $lines, $intvar, $fullline, $normal);
    # hardcoded options for now
    $lines = 1;
    $intvar = 1;
    $normal = 1;
    $fullline = 1;

    $ctx->add( "Displaying the lines of $file") ;

    for ( sort { $a <=> $b } keys %subs ){
        my $output;
        if ($subs{$_}[0] =~ /^_/ ){
            $output .= "line:$_\t " if $lines and $intvar;
            $output .= "$subs{$_}[0]\t"  if $intvar;
            $output .= "$subs{$_}[1]\t"  if $intvar and $fullline;
        }else{
            $output .= "line:$_\t " if $lines and $normal;
            $output .= "$subs{$_}[0]\t" if $normal;
            $output .= "$subs{$_}[1]\t" if $fullline and $normal;
        }
        $ctx->add ( $output );
    }

    $ctx->output;
    1;

}

sub _listsubs {

    my ( $self, $file ) = @_;

    $DB::single = 1;
    
    print "Reading ./$file\n" if $ENV{SHELL_NT_DEBUG};

    die "Can't find $file\n" if (! -e "./$file" );

    open my $fh, "<", "./$file" or die "can't open ./$file";

    my ( $ignore, $total, $internal );
    my %subs;

    while ( my $line =  <$fh> ) {

        chomp $line;
        next if $line =~ /\s*?#/;

        $ignore = 1 if $line =~ /^=\w+/;
        $ignore = 0 if $line =~ /^=cut/;

        if ( ( $line =~ /sub\s+([\w\:]+)/ ) and !$ignore){
            my $subname = $1;
            $subs{$.} = [$subname , $line];
            $total++;
            $internal++ if $subname =~ /^_/;
        }


    }

    close $fh;

    return %subs;


}


__END__

use Getopt::Long;

my ($filename, $stats, $lines, $fullline, $all, $intvar);
my $normal = 1;

my $cmd_line = GetOptions ( "file=s" => \$filename,
                            "stats"  => \$stats,
                            "lines"  => \$lines,
                            "fullline" => \$fullline,
                            "all" => sub {$intvar =1;$normal = 1},
                            "internal" => sub { $intvar = 1;$normal =0} ,
                            "help" => sub { die "file stats lines fullline all internal \n" } ,
                             );

die "Is necessary pass the perl file name as --file filename\nfile stats lines fullline all internal \n" if !$filename;


open my $fh, "<", $filename;

my ($ignore, $total, $internal);
my %subs;

while (<$fh>){
    chomp;
    next if /\s*?#/;
    
    $ignore = 1 if /^=\w+/;
    $ignore = 0 if /^=cut/;
    
    if (/sub\s+([\w\:]+)/ and !$ignore){
        my $subname = $1;
        $subs{$.} = [$subname , $_];
        $total++;
        $internal++ if $subname =~ /^_/;
    }
    
    
}

close $fh;

for ( sort { $a <=> $b } keys %subs) {
    
    if ($subs{$_}[0] =~ /^_/ ){
        print "line:$_\t " if $lines and $intvar;
        print "$subs{$_}[0]\n" if $intvar;
        print "\t$subs{$_}[1]\n" if $intvar and $fullline;
    }else{
        print "line:$_\t " if $lines and $normal;
        print "$subs{$_}[0]\n" if $normal;
        print "\t$subs{$_}[1]\n" if $fullline and $normal;
    }
    

}

if($stats){
    print "Total of subs: $total\n";
    print "Internal ( start with _): $internal\n";
}
