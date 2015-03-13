-- Requêtes
-- Auteurs --
-- Nombre d'enregistrements
SELECT DISTINCT(COUNT(*)) as "Nombre d'auteurs" FROM AU;
-- Les personnes qui ont publié le plus (garder les 10 premiers)

-- Les personnes qui ont publié le plus ensemble
SELECT au1 as "Auteur 1", au2 as "Auteur 2", COUNT(*) as "Nombre de publications"
FROM AU_AU a
GROUP BY au1, au2
HAVING COUNT(*) > 50;

-- Evolution dans le temps (requêtes de groupement)
SELECT au1 as "Auteur 1", au2 as "Auteur 2", COUNT(*) as "Nombre de publications"
FROM AU_AU_DA a
GROUP BY au1, au2, da
HAVING COUNT(*) > 50;

-- Pays --
-- Nombre d'enregistrements
SELECT DISTINCT(COUNT(*)) as "Nombre de pays" FROM PAYS;
-- Les pays qui ont publié le plus (garder les 10 premiers)

-- Les pays qui ont publié le plus ensemble

-- Evolution dans le temps des 10 premiers (requêtes de groupement)

-- Date dépôt --
SELECT DISTINCT(COUNT(*)) as "Nombre d'années" FROM DA;
-- Les années qui ont publié le plus (garder les 10 premiers)
