#Pathway class

package Pathway;

use Moose;
use strict;
use warnings;
use JSON;
use LWP::Simple;

has 'ID' =>(
    is => 'rw',
    isa => 'Str'
);

has 'name' =>(
    is => 'rw',
    isa => 'Str',
);

has 'species' =>(
    is => 'rw',
    isa => 'Str',
);

has 'class' =>(
    is => 'rw',
    isa => 'ArrayRef[Str]'
);

sub annotatePathway {
    my($self)=@_;
    my$ID=$self->ID;

    my$record=get ("http://togows.dbcls.jp/entry/pathway/$ID.json");
    my$json = JSON->new;
    my$ref_content = $json->decode( $record );
    my$refs=$ref_content->[0];
    if($refs->{'name'}){
        my$name=$refs->{'name'};
        $self->name($name);
    }
    if($refs->{'classes'}){
        my@class=@{$refs->{'classes'}};
        $self->class(\@class);
    }
    if($refs->{'organism'}){
        my$species=$refs->{'organism'};
        $self->species($species);
    }
}

1;
