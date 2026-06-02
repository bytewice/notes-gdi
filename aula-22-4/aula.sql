create table cliente (
    idcliente int primary key auto_increment,
    nome varchar(30) not null,
    sexo char(1) not null,
    email varchar(50) UNIQUE,
    cpf varchar(14) UNIQUE
    );

create table endereco (
    idendereco int primary key auto_increment,
    cep char(9) not null,
    rua varchar(100) not null,
    numero int not null,
    
    fk_idcliente int not null,    foreign key (fk_idcliente) references cliente(idcliente) 
);

create table telefone(
    idtelefone int primary key auto_increment,
    ddd char(3) not null,
    numero varchar(15) not null,
    
    fk_idcliente int not null,
    foreign key (fk_idcliente) references cliente(idcliente)
);

insert into cliente values(null, "joao", "M", "joao@joao.com", "123.456.789-00");
insert into cliente values(null, "maria", "F", "maria@maria.com", "987.654.321-00");
insert into cliente values(null, "carlos", "M", "carlos@carlos.com", "111.222.333-44");

insert into endereco values(null, "50000-123", "Rua das Palmeiras", 45, 1);
insert into endereco values(null, "60000-456", "Avenida dos Pinheiros", 123, 2);
insert into endereco values(null, "70000-789", "Praça das Flores", 10, 3);


insert into telefone VALUES(null, '11', '98888-1111', 1);
insert into telefone VALUES(null, '11', '97777-2222', 1);
insert into telefone VALUES(null, '21', '96666-3333', 2);
insert into telefone VALUES(null, '21', '95555-4444', 3);


-- DML- Data Manipulation Language

/* Insert */
insert into cliente values(null, "ana", "M", "ana@ana.com", "222.333.444-55"); -- ana é female mas ta como male, como arrumar dps?
insert into endereco values(null, "80000-000", "Rua das Acacias", 100, 4);

select * from cliente;
select nome, idcliente from cliente where nome = 'ana';

/* where */
select * from cliente where sexo = 'M';

/* update */
update cliente set sexo = 'F' where idcliente = 4; -- tentar so usar chaves primarias aqui pra nao corrigir varias pessoas com o mesmo nome, por exemplo
select * from cliente;

/* delete*/
-- não deletar se tiver alguma relação com outra tabela!
insert into cliente values(null, "duda", "M", "duda@duda.com", "333.444.555-66"); --  id = 8
select * from cliente;
delete from cliente where idcliente =5; -- deletando a cliente que acabamos de criar
select * from cliente;

-- DDL - Data Definition Language
-- geralmente têm o alter table + [nome tabela] + [comando]

create table cliente2 (
    idcliente int primary key auto_increment,
    nome varchar(30) not null,
    sexo char(1) not null,
    email varchar(50) UNIQUE,
    cpf varchar(14) UNIQUE
    );

/* change */
alter table cliente2 CHANGE nome nome_completo varchar(50) not null;
show columns from cliente2;
/* modify */
alter table cliente2 MODIFY cpf varchar(20) UNIQUE; -- alterando cpf para varchar(20) e mantendo a restrição de UNIQUE

/* apagar coluna */
alter table cliente2 DROP COLUMN nome_completo;
show columns from cliente2;

/* adicionar coluna */
alter table cliente2 add column peso float(5,2) not null after sexo;
show columns from cliente2;
alter table cliente2 drop column peso;

-- adicionando coluna na primeira posição
alter table cliente2 add column peso float(10,2) not null first; -- o first pode ser trocado por after [nome da coluna] para colocar a nova coluna depois de uma coluna específica

-- RELATORIO GERAL DE TODAS AS TABELAS
desc cliente2;

select c.idcliente, c.nome, c.sexo, c.email, c.cpf, e.cep, e.rua, e.numero, t.ddd, t.numero from cliente2 c
left join endereco e on c.idcliente = e.fk_idcliente
left join telefone t on c.idcliente = t.fk_idcliente;


-- DCL - Data Control Language

-- TCL - Transaction Control Language