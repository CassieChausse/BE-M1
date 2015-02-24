#!/usr/bin/perl
# tetra_mat_vers_rel.pl, version 4 mars 2009
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

# Création/écrasement du fichier .rel, après avoir testé s'il existe déjà
if(! defined($ARGV[0]))
{ die "usage: tetra_mat_vers_rel.pl XX-XX-XX (matrice 3D) ou XX-XX (si matrice 2D)\n"; }
$matrices = "$ARGV[0]" ;
$sortie = "$matrices.rel" ;
if (-e "$sortie" )
{ print "$sortie => existe déjà ! Ecraser ? (o/n) ";
  $rep = <STDIN> ; chomp($rep);
  if ( $rep ne "o" ) { die "j'laisse béton\n"; } }
open REL, ">$sortie" ;
print "$sortie => créé\n" ;


# Boucle de lecture successives des matrices;
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
    $courant = @nombres[0];        # nom de la ligne courante
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

die "$matrices.$m   => y'en n'a pas...à la prochaine fois!\n";

# Autre version, qui lit les fichiers .ind, .var, .ref, et utilise
# l'info pour mettre les noms entiers dans le .rel
# Pb: génère un fichier trop gros quand il y a bcp de données...

if(! defined($ARGV[0]))
{ die "usage: tetra_mat_vers_rel.pl XX-XX-XX (matrice 3D) ou XX-XX (si matrice 2D)\n"; }
$matrices = "$ARGV[0]" ;
$sortie = "$matrices.rel" ;
if (-e "$sortie" )
{ print "$sortie => existe déjà ! Ecraser ? (o/n) ";
  $rep = <STDIN> ; chomp($rep);
  if ( $rep ne "o" ) { die "j'laisse béton\n"; } }
open REL, ">$sortie" ;
print "$sortie => créé\n" ;

@cols = &lire_lignes("$matrices.var") ;

if (defined($ARGV[1]) && $ARGV[1] eq "sym")
{ print "$matrices.ind => pas lu (t'as dit qu'c'est symétrique)\n";
  @lignes=@cols; }
else { @lignes = &lire_lignes("$matrices.ind") ; }

if (-e "$matrices.ref")
{ @refs = &lire_lignes("$matrices.ref");
  for ($i=0;$i<=$#refs;$i++)
  { $refs[$i]= substr($refs[$i], index($refs[$i],"	")+1)."\t" ; } }
else { print "$matrices.ref => y'en n'a pas (2D?)\n"}

$m=1 ;

while (-e "$matrices.$m")
{ print "$matrices.$m"; open MAT, "<$matrices.$m" ;
  $ligne = <MAT> ;
  $l=0;
  while (defined($ligne = <MAT>))
  { $ligne =~ / *(.*)/sg; $ligne=$1; # annulation des espaces en début de ligne
    @nombres = split / /, $ligne ; shift @nombres ; shift @nombres ;
    if (defined($ARGV[1]) && $ARGV[1] eq "sym") {$cmax=$l;} else {$cmax=$#cols-1;}
    foreach ($c=0; $c <= $cmax; $c++)
    { if ($nombres[$c] ne 0)
      { print REL "$lignes[$l]\t$cols[$c]\t$refs[$m-1]$nombres[$c]\n" ;
      }
    }
    $l++ ;
  }
  close MAT ; print "   => ok\n" ;
  $m++ ;
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
