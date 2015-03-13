#!/usr/bin/perl 
use warnings; 
use strict; 
use  File::Copy  qw/ copy /;
use  File::Copy  qw/move/;

# /home et /tmp sont sur deux disques différents
my $i = 0;
my $chaine = "$i";

#Dossier de destination des index.html
my $rep = 'C:\Users\Marine\Documents\cmi\M1\BE\BE-M1\index';

#Dossier où on va chercher les index.html
my $repertoire = 'C:\Users\Marine\Desktop\www.psychologiesport.fr';

#Pour chaque fichier du répertoire www.psychologiesport.fr\
foreach my $fichier ( lister_fichiers( $repertoire, 1 ) ) { 
  #On va seulement sélectionner les index.html qui ne se trouvent PAS dans un dossier feed
  
  my $longueur = (length($fichier) - 10) < 0 ? 0 : (length($fichier)-10);
  #Si le fichier se nomme index.html et qu'il ne se trouve pas dans un dossier feed
  if(substr($fichier,$longueur) eq "index.html" & !($fichier =~ m/feed/)) {
	#incrément pour récupérer le nombre de fichier index.html trouvés
	$i++;
	
	$chaine = "$i";
	#Copie du fichier index.html dans le répertoire index\ et renommage avec la variable incrémentée
	copy( $fichier, $rep.'\\'.$chaine.'.html') or die  "Copy failed: $!";
	print "OK\n";
  }
}
print("\n FIN : $i fichiers recuperes"); 
  
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