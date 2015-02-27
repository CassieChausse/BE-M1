#!/usr/bin/perl 
use warnings; 
use strict; 
  
my $repertoire = 'C:\CASSIE\TOULOUSE\Cours SID\M1\BE M1\BE-M1\Test PERL'; 
foreach my $rep ( lister_repertoires( $repertoire, 1 ) ) { 
  #On récupère les 10 derniers caractères du chemin, si on a "index.html" alors on copie le fichier dans "Fichier index"
  print "Rep : $rep\n";
 # print length($rep);  
  #print "\n";
  #my @liste = glob('*.html');
  
  #foreach my $li (@liste) {
#	print ("$li \n");
#  }
#  my $nom = substr($rep,(length($rep)-4));
#  print $nom;
#  if ($nom eq "index.html") {
#	print "OUIIIIIIIIIIII\n";
#  }
} 
  
#====================================================== 
# Nombre d'arguments : 1 ou 2 
# Argument(s)        : un répertoire et valeur 0 ou 1 
# Retourne           : Tableau de répertoires (@repertoires) 
#====================================================== 
sub lister_repertoires { 
  my ( $repertoire, $recursivite ) = @_; 
  
  require Cwd; 
  require File::Spec; 
  
  my $cwd = Cwd::getcwd(); 
  
  # Recherche dans les sous-répertoires ou non 
  if ( ( not defined $recursivite ) || ( $recursivite != 1 ) ) { $recursivite = 0; } 
  
  # Verification répertoire 
  if ( not defined $repertoire ) { die "Aucun repertoire de specifie\n"; } 
  
  # Ouverture d'un répertoire 
  opendir my $fh_rep, $repertoire or die "impossible d'ouvrir le répertoire $repertoire\n"; 
  
  # Liste fichiers et répertoire sauf (. et ..) 
  my @fic_rep = grep { !/^\.\.?$/ } readdir $fh_rep; 
  
  # Fermeture du répertoire 
  closedir $fh_rep or die "Impossible de fermer le répertoire $repertoire\n"; 
  
  chdir $repertoire; 
  $repertoire = Cwd::getcwd(); 
  
  # On récupère tous les répertoires 
  my @repertoires; 
  foreach my $nom (@fic_rep) { 
    my $notre_repertoire = File::Spec->catdir( $repertoire, $nom ); 
  
    if ( -d $notre_repertoire and $recursivite == 0 ) { 
      push @repertoires, $notre_repertoire; 
    } 
    elsif ( -d $notre_repertoire and $recursivite == 1 ) { 
      push @repertoires, $notre_repertoire; 
      push @repertoires, lister_repertoires($notre_repertoire, $recursivite);    # recursivité 
    } 
  } 
  
  chdir $cwd; 
  
  return @repertoires; 
}