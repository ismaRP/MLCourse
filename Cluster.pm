#Cluster class

package Cluster;

use Moose;

has 'clusterName' =>(
    is => 'rw',
    isa => 'Str'
);

has 'pathwayID' =>(
    is => 'rw',
    isa => 'ArrayRef[Pathway]',
    predicate => 'hasPathwayID',
);

sub setPathwayID {
    my($self, $pathway)=@_;

    if ($self->hasPathwayID){
        #If there are elements in the ArrayRef
        my@pID = @{$self->pathwayID};
        push @pID, $pathway;
        $self->pathwayID(\@pID);
    }else{
        $self->pathwayID([$pathway]);
    }
}

1;
