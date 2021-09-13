#!/usr/bin/perl
use strict;

######## THIS PROGRAM CALCULATE THE BASIC STATS OF AN ASSEMBLY
######## Alejandra Escobar, EMBL-EBI/Sanger
######## May 25, 2019

my @longitudes=() ;
my @long=() ;
my @ordenado=() ; 
my @parametros=() ;

my $elemento ;
my $elementoS ;
my $elementoN ;
my $linea ; 
my $N ;
my $totalBases ;
my $valorMedio ;
my $sumaElem ;
my $contadorN ;
my $posicionN ;
my $tamanoProm ;
my $contcontig ;
my $Totalong ;
my $longlinea ;
my $ultVal ;

scalar(@ARGV) == 1 || die "usage: $0 <assembly.fasta>\n";

my $file = $ARGV[0] ;
print "assembly\tTotal_contig\tAverage_contig_size\tLargest_contig_size\tShortest_contig_size\tGenome_size\tN50\tL50\tN50_bases\tN90\tL90\tN90_bases\n";
print "$file\t";
open (ARCH, $file) or die $! ;
while (<ARCH>) {
    chomp ;
    my $linea = $_ ;
    if ($linea =~ /^>/) {
    	$contcontig++ ;
	push (@longitudes, $Totalong) ;
	$Totalong = 0 ;
    }else{
        $longlinea = length($linea) ;
        $Totalong += $longlinea ;
    }
    $ultVal = $Totalong ;
}
push (@longitudes, $ultVal) ;

##################### SORTING CONTIG LENGTHS #############
@ordenado = sort { $b <=> $a } (@longitudes) ;
foreach $elemento (@ordenado) {
    $totalBases += $elemento ;
}
$tamanoProm = int $totalBases/$contcontig ;
print "$contcontig\t$tamanoProm\t$ordenado[0]\t$ordenado[-2]\t$totalBases\t" ;

#####################  SPECIFYING VALUES OF N ##############################################
@parametros = (50,90) ;
foreach $elementoS (@parametros) {
    $valorMedio = 0 ;
    $sumaElem = 0 ;
    $contadorN = 0 ;
    &calcN($elementoS) ;
}
print "\n";
exit;

####################  COMPUTING N VALUES ####################

sub calcN {
    $N = $_[0] ;
    $valorMedio = ($N/100)*$totalBases ;
    foreach $elementoN (@ordenado) {
        unless ($sumaElem >= $valorMedio) {
            $sumaElem+= $elementoN ;
            $contadorN++ ;
        }
    }
    $posicionN = $contadorN -1 ;
    return print "$ordenado[$posicionN]\t$contadorN\t$sumaElem\t" ;
}

