package Text::NLP::Stanford::EntityExtract;

use warnings;
use strict;

use Mouse;
use IO::Socket;

=head1 NAME

Text::NLP::Stanford::EntityExtract - Talks to a stanford-ner socket server to get named entities back

=head1 VERSION

Version 0.01

=cut

our $VERSION = '0.01';


has 'host' => (is => 'ro', isa => 'Str', default => '127.0.0.1');
has 'port' => (is => 'ro', isa => 'Int', default => '1234');


sub server {
    my ($self) = @_;
    my $sock = IO::Socket::INET->new( PeerAddr => $self->host,
                                      PeerPort => $self->port,
                                      Proto    => 'tcp',
                                  );
    die "$!" if !$sock;
    return $sock;
}

sub get_entities {
    my ($self, @txt) = @_;
    my @result;
     foreach my $t (@txt) {
         $t =~ s/\n/ /mg;
         push @result, $self->_process_line($t);
     }
    return @result;
}

sub _process_line {
    my ($self, $line) = @_;
    my $server = $self->server;
    print $server $line,"\n";
    my $tagged_txt =  <$server>;
    return $tagged_txt;
}

sub entities_list {
    my ($self, $line) = @_;
    my @tagged_words = split /\s+/, $line;
    my $last_tag = '';
    my $taglist = {};
    my $pos = 1;
    foreach my $w (@tagged_words) {
        my ($word, $tag) = $w =~ m{(.*)/(.*)$};
        $DB::single=1 if $word eq 'Outer';
        if (! $taglist->{$tag}) {
            $taglist->{$tag} = [ ];
        }
        if ($tag ne $last_tag) {
            push @{$taglist->{$tag}}, [$word, $pos++];
        }
        else {
            push @{ $taglist->{$tag}->[ $#{ $taglist->{$tag}} ] }, [$word, $pos++];
        }
        $last_tag = $tag;
    }
    return $taglist;
}

=head1 AUTHOR

Kieren Diment, C<< <zarquon at cpan.org> >>

=head1 BUGS

Please report any bugs or feature requests to C<bug-text-nlp-stanford-entityextract at rt.cpan.org>, or through
the web interface at L<http://rt.cpan.org/NoAuth/ReportBug.html?Queue=Text-NLP-Stanford-EntityExtract>.  I will be notified, and then you'll
automatically be notified of progress on your bug as I make changes.

=head1 SUPPORT

You can find documentation for this module with the perldoc command.

    perldoc Text::NLP::Stanford::EntityExtract

You can also look for information at:

=over 4

=item * RT: CPAN's request tracker

L<http://rt.cpan.org/NoAuth/Bugs.html?Dist=Text-NLP-Stanford-EntityExtract>

=item * AnnoCPAN: Annotated CPAN documentation

L<http://annocpan.org/dist/Text-NLP-Stanford-EntityExtract>

=item * CPAN Ratings

L<http://cpanratings.perl.org/d/Text-NLP-Stanford-EntityExtract>

=item * Search CPAN

L<http://search.cpan.org/dist/Text-NLP-Stanford-EntityExtract/>

=back


=head1 ACKNOWLEDGEMENTS


=head1 COPYRIGHT & LICENSE

Copyright 2008 Kieren Diment, all rights reserved.

This program is released under the following license: GPL


=cut

1; # End of Text::NLP::Stanford::EntityExtract
