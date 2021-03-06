package EPrints::Plugin::Screen::EPrint::Box::Paypal;

our @ISA = ( 'EPrints::Plugin::Screen::EPrint::Box' );

use strict;

sub new
{
    my( $class, %params ) = @_; 

    my $self = $class->SUPER::new(%params);

    $self->{appears} = [ 
        {
            place => "summary_right",
            position => 1000,
        },
    ];  

    return $self;
}

sub can_be_viewed
{
	my( $self ) = @_;

	my $eprint = $self->{processor}->{eprint};
	return unless defined $eprint;
	return if $eprint->value( "full_text_status" ) eq "public";
	return 1;
}

sub render
{
	my( $self ) = @_;

	my $repo = $self->{repository};
	my $eprint = $self->{processor}->{eprint};

	my( $currency, $price, $shipping, $tax ) = $repo->call( [ "paypal", "price_for_eprint" ], $self->{procesor}->{eprint} );
	my $button = $eprint->render_citation( "paypal", 
		currency => [ $currency, "STRING" ],
		price => [ $price, "STRING" ],
		shipping => [ $shipping, "STRING" ],
		tax => [ $tax, "STRING" ],
	);

	return $self->html_phrase(
		"content",
		price => $self->{repository}->xml->create_text_node( $price ),
		currency => $self->{repository}->xml->create_text_node( $currency ),
		button => $button,
	);
}

1;
