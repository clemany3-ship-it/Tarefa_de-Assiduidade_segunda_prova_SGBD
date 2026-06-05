Create database pratica;

Use pratica
Go





create database pratica;

Use pratica
Go
  
create table Cliente(
Id_cliente smallint primary key identity,
Nome_Cliente varchar(100),
Idade int,
Morada varchar(29)
);

create table Produto(
Id_produto smallint primary key identity,
Nome_produto varchar(100),
Marca varchar(50),
preco decimal(3)
);

insert into Cliente values
('Eugenio DInis',24, 'Missão'),
('Fidencio Lencastro',22,'Missão'),
('Gil Dinis ',20,'Capote');


select *from Produto;


select *from Cliente;


SElect	*
into tTemp
from Cliente;

begin transaction;
update tTemp
	set Morada='Belemfryyytrdf ';
	commit;
BEGIN TRANSACTION;
  insert into Cliente values
('Maria Madalena',24, 'Catapa'),
('Feliciana',22,'Mbemba Ngango'),
('Albertina',20,'Capote');
  rollback;


 select *from Cliente;
select *from tTemp;


begin transaction Cli;
insert into Cliente values
('Pedro vitor',45,'Malanga'),
('Afonso viegas',39,'Gulungo');
commit transaction Cli;

begin transaction pro;
insert into Produto values 
('Pão doce','Espiro',200),
('Bolinho','pilinha',900);
commit transaction pro;




select * from Produto;
select *from tTemp;

begin transaction ttemp;
insert into Produto values 
('Magi',15,'Capote'),
('viegas',10,'Dunga');
commit transaction ttemp;




