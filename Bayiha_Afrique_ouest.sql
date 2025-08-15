-- Analyse de la base de données sur la productivité agricole des pays d'Afrique de l'ouest

-- 1) Nous commençons par créer les différentes tables (pays, indicateurs, produit,année, valeur) qui vont nous servir

-- Création de la table pays

create table Pays(  
IDPays int primary key auto_increment,
Nom_Pays varchar (250)
);

-- Création de la table indicateurs

create table Indicateurs(  
IDIndicateurs int primary key auto_increment,
Nom_Indicateur varchar(100),
Unité_Indicateur varchar(200)
);

-- Création de la table Produit

create table Produit ( 
IDProduit int primary key auto_increment,
Nom_Produit varchar(250)
);

-- Création de la table Année
create table Année (  
IDAnnée int primary key auto_increment,
Année int);

-- Création de la table Valeur
create table Valeur(  
IDValeur int primary key auto_increment,
Valeur int,
IDIndicateurs int,
IDProduit int,
IDAnnée int,
IDPays int,
FOREIGN KEY(IDIndicateurs) references Indicateurs(IDIndicateurs),
FOREIGN KEY(IDProduit) references Produit(IDProduit),
FOREIGN KEY(IDAnnée) references Année(IDAnnée),
FOREIGN KEY(IDPays) references Pays(IDPays)
);

-- 2) Création des vues spéciques à chaque indicateur : rendement, production, superficies cultivées

-- On créé une vue uniquement pour les rendements par pays, culture et par année
create view Rendement as
select IDPays, Nom_Pays as Pays, IDProduit, Nom_Produit as culture, IDAnnée, Année, valeur as Rendement,Unité_Indicateur
from valeur
join Produit using (IDProduit)
join pays p using (IDPays)
join Année using (IDAnnée)
join Indicateurs using(IDIndicateurs)
where Nom_Indicateur = "Rendement" and Unité_Indicateur = "kg/ha";

select*
from rendement;


-- On créé une vue uniquement pour les productions par pays, culture et par année

create view Production as
select IDPays, Nom_Pays as Pays, IDProduit, Nom_Produit as culture, IDAnnée, Année,valeur as Production, Unité_Indicateur
from valeur
join Produit using (IDProduit)
join pays p using (IDPays)
join Année using (IDAnnée)
join Indicateurs using(IDIndicateurs)
where Nom_indicateur = "Production" and Unité_Indicateur = "tonnes";

select*
from Production;

-- On créé une vue uniquement pour les surperficies récoltées par pays, culture et par année

create view Superficie_Récoltée as
select IDPays, Nom_Pays as Pays, IDProduit, Nom_Produit as culture, IDAnnée, Année, valeur as Superficie_récoltée, Unité_Indicateur
from valeur
join Produit using (IDProduit)
join pays p using (IDPays)
join Année using (IDAnnée)
join Indicateurs using(IDIndicateurs)
where Nom_indicateur = "Superficie récoltée" and Unité_Indicateur = "ha";

select*
from Superficie_Récoltée;

-- 3)	Calculer le rendement moyen par culture et par pays

-- 3.1) Le calcul de cet indicateur n'a pas de sens au regard de l'analyse exploratoire. 
-- Cependant, nous l'avons calcul à titre pédagogique dans le cadre de notre entrainement.

select Pays, culture, Unité_Indicateur, avg(Rendement) as Rendement_moyen
from rendement
where Année between 2000 and 2022
group by Pays, culture, Unité_Indicateur;

-- 3.2) La liste des trois pays sur les 16 en Afrique de l'Ouest ayant les rendements moyens maïs les plus élevés sur la période 2000-2022 

select Pays, culture, Unité_Indicateur, round(avg(Rendement),2) as Rendement_moyen
from rendement
where Année between 2000 and 2022 and culture = "Maïs"
group by Pays, culture, Unité_Indicateur
order by Rendement_moyen desc
limit 3;


-- Le classement des pays ayant des écart-types de rendements moyens de Maïs du plus faible au plus élevé
 
select Pays, culture, Unité_Indicateur, round(sqrt(Rendement),2) as Ecart_type
from rendement
where Année between 2000 and 2022 and culture = "Maïs"
group by Pays, culture, Unité_Indicateur
order by Ecart_type;


-- La liste des trois pays sur les 16 en Afrique de l'Ouest ayant les rendements moyens de tomate les plus élevés sur la période 2000-2022 

select Pays, culture, Unité_Indicateur, round(avg(Rendement),2) as Rendement_moyen
from rendement
where Année between 2000 and 2022 and culture = "Tomates, fraiches"
group by Pays, culture, Unité_Indicateur
order by Rendement_moyen desc
limit 3;

-- -- Le classement des pays ayant des écart-types de rendements moyens de tomate, fraiche du plus faible au plus élevé
 
select Pays, culture, Unité_Indicateur, round(sqrt(Rendement),2) as Ecart_type
from rendement
where Année between 2000 and 2022 and culture = "Tomates, fraiches"
group by Pays, culture, Unité_Indicateur
order by Ecart_type;


select*
from production;

-- 4.	Identifier les pays ayant augmenté leur production entre deux années
select p1.Pays, p1.culture, p1.Année as Annee_precedente, p2.Année as Annee_suivante, p1.production as Prod_precedente, p2.production as Prod_suivante
from production p1
join production p2 on p1.Pays =  p2.Pays
where p2.production > p1.production;



-- Les pays ayant augmenté la production de maiis entre 2000 et 2005
select p1.Pays, p1.culture, p1.Année as Annee_precedente, p2.Année as Annee_suivante, p1.production as Prod_precedente, p2.production as Prod_suivante
from production p1
join production p2 on p1.Pays =  p2.Pays
where p2.production > p1.production and p1.culture = "Maïs" and p1.Année between 2000 and 2005;