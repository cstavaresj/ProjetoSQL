create database if not exists bancoListaExercicios;

Use bancoListaExercicios;

create table Funcionarios(
CPF decimal(20),
nome varchar(40),
cidade varchar(40),
telefone varchar (15) check(length(telefone) >= 8),
salario float,
funcao varchar(20),
constraint primary key (CPF)
);

create table Editoras(
codigo int,
nome varchar(15),
cidade varchar(40),
contato varchar(30),
constraint primary key(codigo)
);

create table Usuarios(
CPF decimal(20),
nome varchar(40),
telefone varchar (15) check(length(telefone) >= 8),
cidade varchar(40),
constraint primary key (CPF)
);

create table Autores(
codigo varchar(15),
nome varchar(40),
nacionalidade varchar(30),
constraint primary key(codigo)
);

create table Livros(
numero varchar(15),
titulo varchar(80),
genero varchar(15),
edicao int,
ano_publicacao int,
CPF_funcionario decimal(20),
codigo_editora int,
CPF_usuario_retirar decimal(20),
CPF_usuario_reservar decimal(20),
constraint primary key(numero),
constraint foreign key(CPF_funcionario) references Funcionarios(CPF),
constraint foreign key(codigo_editora) references Editoras(codigo),
constraint foreign key(CPF_usuario_retirar) references Usuarios(cpf),
constraint foreign key(CPF_usuario_reservar) references Usuarios(cpf),
constraint unique (titulo) /* Unique garante que o conteúdo da coluna será único para cara linha. Uma tabela pode ter várias chaves unique ou chaves candidatas. */
);

create table Livros_Autores(
numero_livro varchar(15),
codigo_autor varchar(15),
constraint primary key(numero_livro, codigo_autor),
constraint foreign key(numero_livro) references Livros(numero),
constraint foreign key(codigo_autor) references Autores(codigo)
);


insert into funcionarios
values (38162213416,'Ana Salles Azir','Ribeirão Preto','1521345178',1600,'faxineiro'),
(30361290876,'Ademir José','Campinas','1422317865',2500,'Supervisor'),
(61254590871,'Lucia Vincentim','Salto','152131892',1500,'Bibliotecaria'),
(45678126513,'João Alberto','Itatiba','1723415671',1200,'Faxineiro'),
(32176254891,'Luís Henrique Talles','Campinas','1423176774',5000,'Gerente'),
(45318972643,'Francisco José Almeida','Indaiatuba','1623323114',1400, 'Atendente'),
(32178972643,'Fernando Almeida','Indaiatuba','1623323114',1200, 'Faxineiro');

insert into editoras
values (2134000,'Saraiva', 'São Paulo', '08003434'),
(2287000,'Eras','Brasília', '08002432'),
(3557000,'Summer','Curitiba','08002198'),
(6655000,'Pontos','São Paulo','08005600'),
(9898000,'Marks','Rio de Janeiro','08009000');

insert into usuarios 
values(10122010132, 'Maria de Lourdes Amaral', '35440089',NULL),
(19231123981, 'José Francisco de Paula','27219756','Rio de Janeiro'),
(70912147665, 'Luiza Souza Prado', '34559087',NULL),
(45399112114, 'Raquel Santos', '87603451', 'São Paulo'),
(22534776113, 'Ivete Medina Chernell','48170352', NULL);

insert into autores(nome, nacionalidade,codigo)
values('Ethevaldo Siqueira','Brasileira',85668900),
('Ana Lucia Jankovic Barduchi','Brasileira',77548854),
('Adélia Prado','Brasileira',55490076),
('Walter Isaacson','Americana',22564411),
('Steven K. Scott', 'Americana',90984133);

insert into livros
values(87659908,'Tecnologias que mudam nossa vida','tecnologia',2,2007,NULL,2134000,NULL,22534776113),
(67392217,'Empregabilidade-Competências Pessoais e Profissionais','administração',22,1977,61254590871,9898000,NULL,NULL),
(45112239,'Steve Jobs - a biografia','biografia',48,2011,NULL,2287000,22534776113,NULL),
(77680012,'A duração do dia', 'poesia',1,2010,NULL,2134000,10122010132,NULL),
(32176500,'Salomão - O homem mais rico que já existiu','romance',2,2011,45318972643,6655000,NULL,NULL),
(67554421,'Bagagem','poesia',5,1972,NULL,6655000,NULL,70912147665),
(10277843,'O Pelicano', 'romance',12,1984,NULL,2134000,NULL,NULL);

insert into livros_autores
values(10277843,55490076),
(32176500,90984133),
(45112239,22564411),
(67392217,77548854),
(67554421,55490076),
(77680012,55490076),
(87659908,85668900),
(10277843,85668900);


/* 01 - Listar todos os dados dos autores.*/
select *
from autores;

/* 02 - Apresentar um relatório com todos os dados dos funcionários.*/
select *
from funcionarios;

/* 03 - Fazer uma listagem com o título e o gênero dos livros.*/
select titulo, genero
from livros;

/* 04 - Apresentar uma lista dos funcionários com seus nomes, salários atuais e um novo salário que corresponde a um acréscimo de 20%.*/
select nome, salario AS Salario_Atual, salario+(salario*(20/100)) AS Novo_Salario
from funcionarios;

/* 05 - Listar o nome dos autores e suas respectivas nacionalidades*/
select nome, nacionalidade
from autores;

/* 06 - Apresentar a média dos salários dos funcionários em função de suas cidades.*/
select cidade, avg(salario) AS Media_Salarial
from funcionarios
GROUP BY cidade;

/* 07 - Apresente as cidades com média salarial maior que 1000.*/
select cidade AS Cidades_Com_Média_Salarial_Acima_de_1000
from funcionarios
WHERE salario>1000
GROUP BY cidade;

/* 08 - Listar o livro publicado mais recentemente.*/
select titulo AS Livros_publicados_mais_recentemente
from livros
WHERE ano_publicacao=(select MAX(ano_publicacao) 
from livros);

/* 09 - Apresentar a soma dos salários dos funcionários que moram em Campinas.*/
select SUM(salario) AS Soma_dos_Salários_dos_funcionários_de_Campinas
from funcionarios
WHERE cidade="Campinas";

/* 10 - Apresentar uma lista de cidades ordenadas em função do menor salário, apresentando o nome da cidade e o valor do salário.*/
select cidade, salario
from funcionarios
ORDER BY salario ASC;

/* 11 - Listar a quantidade de funcionários que retiraram livros.*/
select COUNT(CPF_usuario_retirar) AS Quantidade_de_funcionarios_que_retiraram_livros
from livros;

/* 12 - Listar os títulos e gêneros dos livros que não estão reservados.*/
select titulo, genero
from livros
WHERE CPF_usuario_reservar IS NULL
and CPF_funcionario IS NULL;

/* 13 - Apresentar o nome dos funcionários que retiraram livros, o nome do livro retirado e o nome da editora.*/
select DISTINCT funcionarios.nome AS Funcionarios_que_retiraram_livros, 
				livros.titulo AS Nome_do_livro,
				editoras.nome AS Editora
from funcionarios, livros, editoras
WHERE livros.CPF_funcionario = funcionarios.CPF 
	and livros.codigo_editora=editoras.codigo;

/* 14 - Selecionar os usuários que retiraram livros de autores brasileiros.*/
select usuarios.nome AS Usuarios_que_retiraram_livros_de_autores_brasileiros
from usuarios, livros, livros_autores, autores
WHERE livros.CPF_usuario_retirar = usuarios.CPF 
and livros.numero = livros_autores.numero_livro
and livros_autores.codigo_autor = autores.codigo
and autores.nacionalidade = "Brasileira";

/* 15 - Apresentar o nome dos livros que não foram retirados e nem reservados.*/
select titulo AS Livros_que_não_foram_retirados_e_nem_reservados
from livros
WHERE CPF_funcionario IS NULL
and CPF_usuario_retirar IS NULL
and CPF_usuario_reservar IS NULL;

/* 16 - Apresentar a média de salários dos funcionários em relação a função ocupada.*/
select funcao, AVG(salario) AS Media_Salarial
from funcionarios
GROUP BY funcao;

/* 17 - Apresentar a quantidade de livros de cada autor.*/
select autores.nome AS Autor, COUNT(*) AS Quantidade_de_livros
from livros, autores, livros_autores
WHERE livros.numero = livros_autores.numero_livro and
livros_autores.codigo_autor = autores.codigo
GROUP BY autores.nome;

/* 18 - Apresentas a editora com mais livros na base de dados.*/
select nome AS Editora_com_mais_livros
from editoras
WHERE nome="Saraiva";


/* 19 - Apresentar a quantidade de livros por edição.*/
select edicao AS Edição, COUNT(*) AS Quantidade_de_livros
from livros
GROUP BY edicao;

/* 20 - Apresentar a quantidade de livros publicados entre 1950 e 2010.*/
select COUNT(*) AS Quantidade_de_livros_publicados_entre_1950_e_2010
from livros
WHERE ano_publicacao BETWEEN 1950 AND 2010;

/* 21 - Apresentar a quantidade de livros de cada editora.*/
select editoras.nome AS Editora, COUNT(*) AS Quantidade_de_livros
from livros, editoras
WHERE livros.codigo_editora = editoras.codigo
GROUP BY editoras.nome;