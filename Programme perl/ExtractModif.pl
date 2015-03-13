#!/usr/bin/perl
use HTML::TokeParser;

#######################
# Ouverture du fichier donn�e en param�tre
# Fichier dans lequel on stockera les r�sultats
if ( !open(OUT, ">>$ARGV[0]") ) {
  print " Erreur d'ouverture de $ARGV[0] \n"; 
  exit(0);
}

#D�finition du r�p�rtoire contenant tous les .html o� nous devons r�cup�rer
#les informations n�cessaires
my $repertoire = 'C:\CASSIE\TOULOUSE\Cours SID\M1\BE M1\BE-M1\index2';

#Pour chaque fichier dans le r�pertoire
foreach my $fichier ( lister_fichiers( $repertoire, 1 ) ) { 
  #On ouvre le fichier
  if ( !open(IN, "$fichier") ) {
	print " Erreur d'ouverture de $fichier \n"; 
	exit(0);	
  }
  print OUT "------------------------------------------------------\n";
  print OUT "FICHIER : $fichier"; #Affichage du nom du fichier ouvert
  
  #On utilise le module TokeParser qui permet, entre autre, de r�cup�rer le texte dans une balise d�finie en param�tre
  $p = HTML::TokeParser->new("$fichier") || die "Can't open: $!";
  &parse_meta_tags;          # lecture des META TAGS.
  
  #Pour chaque ligne du fichier
  #A noter : le .html a �t� r�duit sur une ligne pour pouvoir r�cup�rer toutes les informations d'un coup
  #Ici, le while n'est donc pas n�cessaire mais on le laisse au cas o�
  while(<IN>) {
	#On r�cup�re tout le texte qui se trouve entre les balises <article>...</article>
	if(my @liste = ($_ =~ m@<article[^>]*>(.*)</article>@)) {
		#On a tout ce qui se trouve entre <article> et </article> dans la liste @liste
		#On va retirer toutes les balises toujours pr�sentes pour ne r�cup�rer que le texte utile
		#Pour chaque �l�ment dans @liste
		foreach my $ligne (@liste) {
			#Retrait des balises inutiles
			$ligne =~ s/<[^<]*>/-/g;
			#On �crit dans le fichier (OUT) la r�ponse nettoy�e
			print OUT "\nAR : $ligne";
		}
	}
  }
  print OUT "\n"; #saut de ligne
  close(IN); #fermeture du fichier .html
}
close(OUT); #fermeture du fichier o� les r�ponses sont stock�es

sub parse_meta_tags {
  &parse_title;            # lecture du Titre du document.
}

sub parse_title {
  if ($p->get_tag("title")) {
    local $title = $p->get_trimmed_text;  

    $title =~ s/�|�|�|�|�|�/A/g;
    $title =~ s/�|�|�|�|�/a/g;
    $title =~ s/�/c/g;
    $title =~ s/�/C/g;
    $title =~ s/�|�|�|�/e/g;
    $title =~ s/�|�|�|�/E/g;
    $title =~ s/�|�|�|�/I/g;
    $title =~ s/�|�|�|�/i/g;
    $title =~ s/�/N/g;
    $title =~ s/�/n/g;
    $title =~ s/�|�|�|�|�|�/O/g;
    $title =~ s/�|�|�|�|�|�/o/g;
    $title =~ s/�|�|�|�/U/g;
    $title =~ s/�|�|�|�/u/g; 
    $Data =~ s/
//g;
    print OUT "\nTI-: $title"; 
  }
}

#close(IN);

#====================================================== 
# Nombre d'arguments : 1 ou 2 
# Argument(s)        : un r�pertoire et valeur 0 ou 1 
# Retourne           : Tableau de fichier (@fichiers) 
#====================================================== 
sub lister_fichiers { 
  my ( $repertoire, $recursivite ) = @_; 
  
  require Cwd; 
  require File::Spec; 
  
  my $cwd = Cwd::getcwd(); 
  
  # Recherche dans les sous-r�pertoires ou non 
  if ( ( not defined $recursivite ) || ( $recursivite != 1 ) ) { $recursivite = 0; } 
  
  # Verification r�pertoire 
  if ( not defined $repertoire ) { die "Aucun repertoire de specifie\n"; } 
  
  # Ouverture d'un r�pertoire 
  opendir my $fh_rep, $repertoire or die "impossible d'ouvrir le r�pertoire $repertoire\n"; 
  
  # Liste fichiers et r�pertoire sauf (. et ..) 
  my @fic_rep = grep { !/^\.\.?$/ } readdir $fh_rep; 
  
  # Fermeture du r�pertoire 
  closedir $fh_rep or die "Impossible de fermer le r�pertoire $repertoire\n"; 
  
  chdir $repertoire; 
  $repertoire = Cwd::getcwd(); 
  
  # On r�cup�re tous les fichiers 
  my @fichiers; 
  foreach my $nom (@fic_rep) { 
    my $notre_fichier = File::Spec->catfile( $repertoire, $nom ); 
  
    if ( -f $notre_fichier ) { 
      push @fichiers, $notre_fichier; 
    } 
    elsif ( -d $notre_fichier and $recursivite == 1 ) { 
      push @fichiers, lister_fichiers($notre_fichier, $recursivite);    # recursivit� 
    } 
  } 
  
  chdir $cwd; 
  
  return @fichiers; 
}



