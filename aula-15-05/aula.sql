-- subqueries
-- min, max, avg, sum, count
-- alterar linhas
-- add column
-- alter table


-- aula de hoje CHAVES PRIMÁRIAS E ESTRANGEIRAS!! organização de dados, relacionamentos entre tabelas, integridade referencial
create table jogo (
    idjogo serial primary key,
    nome varchar(50) not null
);

create table time(
    idtime serial primary key,
    nome_time varchar(50) not null,

    id_jogo int not null,
    foreign key(id_jogo) references jogo(idjogo)
);

insert into jogo values (null, 'PAULO');
insert into time values (null, 'SÃO PAULO', 1);

show create table jogo;
show create table time;

-- mostrando como normalizar
create table cliente(
    idcliente int,
    nome VARCHAR(50) not null
);
create table telefone(
    idtelefone int,
    tipo char(3) not null,
    numero varchar(15) not null, 

    id_cliente INT not null 
);

-- fabricando chave primaria e chave estrangeira (normalização)
alter table cliente add constraint pk_cliente primary key (idcliente);
alter table telefone add constraint fk_cliente_telefone foreign key (id_cliente) references cliente(idcliente);

show create table telefone;

-- apagando chave estrangeira
alter table telefone drop foreign key fk_cliente_telefone;
-- colocando de volta kkkk
-- colocou com o cascade
-- dps colocou com set null no final, mas tem que ser nullável a coluna
alter table telefone add constraint fk_cliente_telefone foreign key (id_cliente) references cliente(idcliente) on delete cascade;;

insert into cliente values (1, 'JOAO');
insert into cliente values (2, 'MARIA');
insert into cliente values (3, 'CARLOS');
insert into cliente VALUES (4, 'ANA');

insert into telefone values (10, 'CEL', '99999-9999', 2);
insert into telefone values (20, 'RES', '88888-8888', 2);
insert into telefone values (30, 'CEL', '77777-7777', 1);
insert into telefone values (40, 'RES', '66666-6666', 3);
insert into telefone values (50, 'CEL', '55555-5555', 4);

select nome, tipo, numero 
from cliente c inner join telefone t on c.idcliente = t.id_cliente;

-- agr q colocou o 'on delete cascade' no nome da coluna esse delete funciona
delete from cliente where idcliente = 1;

-- dicionarios de dados
show database;
