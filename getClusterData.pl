#! perl -w
use strict;
use warnings;
use Cluster;
use Pathway;
use JSON;
use LWP::Simple;
#298,aav00720,10,9,2,3,1,1.466667,1.8,0,2.391667,0.9,0.7,0,0,1.8,0.016667,0.9,1,0.486667,0.783333,0.075,cluster5


unless ($ARGV[0]){die "ERROR: File not found\n"};
my$file_name=$ARGV[0];
open (IN, $file_name);
my%clusters;

while (my$line=<IN>){
    next if ($line =~/^[@|\n|#|%]/); #Skip header
    my@elem = split ",",$line;
    my$cluster=$elem[scalar@elem-1];
    chomp$cluster;
    push @{$clusters{$cluster}}, $elem[1];
}
# my@fam=keys%clusters;
# print "@fam\n";
# foreach my$cl ( keys %clusters ) {
#     print "$cl:\n @{ $clusters{$cl} }\n\n";
# }

#Construct cluster objects
my($cluster_data, $pathway_data)=&createObjects(\%clusters);

print "\nFINAL REPORT\n";
foreach my$key(keys%{$cluster_data}){
    print "\n-----------\n";
    print $cluster_data->{$key}->clusterName . "\n";
    foreach my$path(@{$cluster_data->{$key}->pathwayID}){
        print $path->class->[0] . ", " .$path->class->[1]. "\n";
    }
}


##### SUBRUTINES

sub createObjects {
    my(%clusters)=%{$_[0]};
    my%cluster_data;
    my%pathway_data;
    foreach my$key(keys%clusters){
        $cluster_data{$key} = Cluster->new(
            clusterName => $key,
        );
        foreach my$id (@{$clusters{$key}}){
            $pathway_data{$id} = Pathway->new(
                ID => $id,
            );
            $pathway_data{$id}->annotatePathway;
            $cluster_data{$key}->setPathwayID($pathway_data{$id});
        }
    }
    return \%cluster_data, \%pathway_data;
}
