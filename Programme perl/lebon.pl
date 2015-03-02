#!/usr/bin/perl 
use warnings; 
use strict; 
use  File::Copy  qw/ copy /;
use  File::Copy  qw/move/;

# /home et /tmp sont sur deux disques différents
my $i = 0;
my $chaine = "$i";
my $rep = 'C:\CASSIE\TOULOUSE\Cours SID\M1\BE M1\BE-M1\Fichier index'; #dossier de destination des index.html
my $repertoire = 'C:\CASSIE\TOULOUSE\Cours SID\M1\BE M1\BE-M1\Test PERL'; #dossier où on va chercher les index.html
foreach my $fichier ( lister_fichiers( $repertoire, 1 ) ) { 
  my $longueur = (length($fichier) - 10) < 0 ? 0 : (length($fichier)-10);
  if(substr($fichier,$longueur) eq "index.html") {
	$i++;
	$chaine = "$i";
	#move($fichier, $rep) or die  "move failed: $!";
	copy( $fichier, $rep.'\\'.$chaine.'.html') or die  "Copy failed: $!";
	print "OK\n";
  }
}
print("\n FIN : $i fichiers récupérés"); 
  
#====================================================== 
# Nombre d'arguments : 1 ou 2 
# Argument(s)        : un répertoire et valeur 0 ou 1 
# Retourne           : Tableau de fichier (@fichiers) 
#====================================================== 
sub lister_fichiers { 
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
  
  # On récupère tous les fichiers 
  my @fichiers; 
  foreach my $nom (@fic_rep) { 
    my $notre_fichier = File::Spec->catfile( $repertoire, $nom ); 
  
    if ( -f $notre_fichier ) { 
      push @fichiers, $notre_fichier; 
    } 
    elsif ( -d $notre_fichier and $recursivite == 1 ) { 
      push @fichiers, lister_fichiers($notre_fichier, $recursivite);    # recursivité 
    } 
  } 
  
  chdir $cwd; 
  
  return @fichiers; 
}