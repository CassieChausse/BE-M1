#!/usr/bin/perl
# tetra_mat_vers_rel.pl, version 6 mars 2009
# Usage: tetra_mat_vers_rel.pl AA-BB-CC (matrice 3D) ou AA-BB (si matrice 2D)
# Transforme les matrices de cooccurrences générées par Tetralogie
# en une table de relation :
# si en entrée on a les tables AA-BB-CC,
# la table, écrite dans AA-BB-CC.rel, contient des lignes
# de la forme : AA BB CC nb_occ
# où AA est le premier champs, BB le second, CC est troisième,
# et nb_occ est le nombre qui apparait dans la matrice.
# Si nb_occ vaut 0, la ligne n'est pas écrite.
#
# Si matrice symétrique: on peut ajouter l'argument <<sym>>,
# alors on ne génère les lignes de la table qu'une fois,
# par exemple: tetra_mat_vers_rel.pl AA-AA sym
#
# Créée ensuite les tables AA-BB-CC.rin et AA-BB-CC.rva
# qui donnent correspondance entre les noms abbrégés qui
# apparaissent dans les matrices et les noms complets qui
# apparaissent dans les fichiers AA-BB-CC.ind et AA-BB-CC.var

# Récupération du nom de la relation à traiter
if(! defined($ARGV[0]))
{ die "usage: tetra_mat_vers_rel.pl XX-XX-XX (matrice 3D) ou XX-XX (si matrice 2D)\n"; }
$matrices = "$ARGV[0]" ;

# Création/écrasement du fichier .rel, après avoir testé s'il existe déjà
&ouverture_prudente("$matrices.rel",REL) ;

# Boucle de lecture des matrices successives;
# $m est le num. de la matrice courante
$m=1 ;
while (-e "$matrices.$m")
{ print "$matrices.$m"; open MAT, "<$matrices.$m" ;
  # lecture de la première ligne, qui donne les noms des colonnes,
  # stockés dans le tableau @cols ; on met tout en minuscules,
  # pour avoir les mêmes noms qu'en têtes de lignes
  $ligne = <MAT> ; $ligne =~ s/(\w+)/\L$1/gi ; @cols = split /  /, $ligne ;
  $cols[0] = substr($cols[0],1) ;
  # boucle de lecture des autres lignes de la matrice
  $l=0;
  while (defined($ligne = <MAT>))
  { $ligne =~ m[ *(.*)]sg; $ligne=$1; # annulation des espaces en début de ligne
    @nombres = split / /, $ligne ; # découpage de la ligne, dans @nombres
    $courant = @nombres[0];  $lignes[$l] = $courant;  # nom de la ligne courante
    shift @nombres ; shift @nombres ;
    # definition de l'index max de lecture des lignes,
    # suivant que la matrice est annoncée symétrique ou non:
    if (defined($ARGV[1]) && $ARGV[1] eq "sym") {$cmax=$l;} else {$cmax=$#cols-1;}
    # boucle d'écriture des lignes de la table
    for ($c=0; $c <= $cmax; $c++)
    { if ($nombres[$c] ne 0)
      { print REL "$courant\t$cols[$c]\t$m\t$nombres[$c]\n" ;
      }
    }
    $l++ ;
  }
  close MAT ; print "   => ok\n" ;
  $m++ ;
}

close REL ;


# Construction des tables de correspondance entre les noms et les
# noms abbrégés: .rin (d'après .ind) et .rva (d'après .var)
&ouverture_prudente("$matrices.rva",RVA) ;
@var = &lire_lignes("$matrices.var") ;
for ($i=0; $i<= $#var; $i++) { print RVA "$cols[$i]\t$var[$i]\n" ; }
close RVA ;

&ouverture_prudente("$matrices.rin",RIN) ;
@ind = &lire_lignes("$matrices.ind") ;
for ($i=0; $i<= $#ind; $i++) { ; print RIN "$lignes[$i]\t$ind[$i]\n" ; }
close RIN ;

die "...à la prochaine fois!\n";


sub ouverture_prudente { # 2 paramètre:
                         # - le nom du fichier à ouvrir en sortie
                         # - l'identificateur de fichier
  if (-e "$_[0]" )
  { print "$_[0] => existe déjà ! Ecraser ? (o/n) ";
    $rep = <STDIN> ; chomp($rep);
    if ( $rep ne "o" ) { die "j'laisse béton\n"; } }
  open $_[1], ">$_[0]" ; print "$_[0] => créé\n" ; # FICHIER ;
}

sub lire_lignes { # un paramètre: nom du fichier à lire;
                  # retourne un tableau contenant les lignes lues
  my $fichier = $_[0] ; my @tableau =( ) ;
  if (-e $fichier)
  { print "$fichier" ; open FICHIER, "<$fichier" ;
    my $i=0 ; while (<FICHIER>) { chomp($tableau[$i] = $_) ; $i++ ; } close FICHIER ;
    print " => $#tableau+1 lignes lues\n";
    @tableau ;
  }
  else { die "Pas de fichier $fichier ! J'arrête tout...\n" ; }
}
