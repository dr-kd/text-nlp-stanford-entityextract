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

=head1 Quick Start:

=over

=item *

Grab the Stanford Named Entity recogniser from http://nlp.stanford.edu/ner/index.shtml.

=item *

Run the server, something like as follows:

 java -server -mx400m -cp stanford-ner.jar edu.stanford.nlp.ie.NERServer -loadClassifier classifiers/ner-eng-ie.crf-4-conll-distsim.ser.gz 1234

=item *

Wrte a script to extract the named entities from the text, like the following:

 #!/usr/bin/env perl -w
 use strict;
 use Text::NLP::Stanford::EntityExtract;
 my $ner = Text::NLP::Stanford::EntityExtract->new;
 my $server = $ner->server;
 my @txt = ("Some text\n\n", "Treated as \\n\\n delimieted paragraphs");
 my @tagged_text = $ner->get_entities(@txt);
 my $entities = $ner->entities_list($txt[0]); # rather complicated
                                              # @AOA based data
                                              # structure for further
                                              # processing

=cut

our $VERSION = '0.01';

=head2 METHODS

=head2 new ( host => '127.0.0.1', port => '1234');

=cut

has 'host' => (is => 'ro', isa => 'Str', default => '127.0.0.1');
has 'port' => (is => 'ro', isa => 'Int', default => '1234');


=head2 server

Gets the socket connection.  I think that the ner server will only do
one line per connection, so you want a new connection for every line
of text.

=cut

sub server {
    my ($self) = @_;
    my $sock = IO::Socket::INET->new( PeerAddr => $self->host,
                                      PeerPort => $self->port,
                                      Proto    => 'tcp',
                                  );
    die "$!" if !$sock;
    return $sock;
}

=head2 get_entities(@txt)

Grabs the tagged text for an arbitrary number of paragraphs of text,
and returns as the ner tagged text.

=cut

sub get_entities {
    my ($self, @txt) = @_;
    my @result;
     foreach my $t (@txt) {
         $t =~ s/\n/ /mg;
         push @result, $self->_process_line($t);
     }
    return @result;
}

=head2 _process_line ($line)

processes a single line of text to tagged text

=cut


sub _process_line {
    my ($self, $line) = @_;
    my $server = $self->server;
    print $server $line,"\n";
    my $tagged_txt =  <$server>;
    return $tagged_txt;
}

=head2 entities_list($tagged_line)

returns a rater arcane data structure of the entities from the text.
the position of the word in the line is recorded as is the entity
type, so that the line of text can be recovered in full from the data
structure.

TODO:  This needs some utility subs around it to make it more useful.

=cut

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
