#!/usr/bin/perl 
use warnings; 
use strict; 
  
my $repertoire = 'C:\CASSIE\TOULOUSE\Cours SID\M1\BE M1\BE-M1\index'; 

#Pour chaque fichier dans index\
foreach my $fichier ( lister_fichiers( $repertoire, 1 ) ) { 
  print "Fichier : $fichier\n";
  #On ouvre le fichier
  open(LAMA,$fichier) || die ("Erreur d'ouverture de $fichier");
  while (<LAMA>) { #pour chaque ligne du fichier
	#On récupère les ../../www. et on met dans un fichier -> URL.txt
	if(my @liste = ($_ =~ m@\.\./\.\./(www\..*?)"@)) { #expression régulière qui récupère les url
		open(URL,">>C:/CASSIE/TOULOUSE/Cours SID/M1/BE M1/BE-M1/URL");
			foreach my $ligne (@liste) {
				print URL "$ligne \n"; #écriture dans URL
			}
		close(URL);
	}
  }
  close(LAMA);
} 
  
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

#egrep -v
#replacer :/: par http://

#récupérer url

#e grep rue89 express tout ce qu'on veut garder choix des journaux à récupérer