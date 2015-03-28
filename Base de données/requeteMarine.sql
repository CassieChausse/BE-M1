SELECT A1.AU, SUM(occurences_AU_AU) AS NB_copublication
FROM AU A1, AU_AU A2
WHERE A1.AU=A2.AU1 OR A1.AU=A2.AU2
HAVING SUM(occurences_AU_AU)>25
GROUP BY A1.AU
ORDER BY SUM(occurences_AU_AU) DESC;

SELECT Pays 
FROM 
( 
SELECT * 
FROM PAYS_DA
 WHERE DA_PD like '1994-2005' 
ORDER BY occurences_PAYS_DA desc 
) 
WHERE rownum <=10;

SELECT Pays 
FROM 
( 
SELECT * 
FROM PAYS_DA
 WHERE DA_PD like '2006-2010' 
ORDER BY occurences_PAYS_DA desc 
) 
WHERE rownum <=10

SELECT Pays 
FROM 
( 
SELECT * 
FROM PAYS_DA
 WHERE DA_PD like '2011-2015' 
ORDER BY occurences_PAYS_DA desc 
) 
WHERE rownum <=10

-- Pays qui ont des publi que à partir de 2011 si yen a bcp prendre les 10 qui ont le plus publié
SELECT pays, occurences_pays_da as "Nombre de publication"
FROM PAYS_DA
WHERE DA_PD = '2011-2015'
ORDER BY occurences_PAYS_DA DESC

SELECT pays, SUM(occurences_PAYS_DA) as "Nombre de publication"
FROM PAYS_DA
WHERE rownum <=30
GROUP BY pays
ORDER BY "Nombre de publication" DESC