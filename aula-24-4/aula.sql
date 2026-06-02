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


-- DCL - Data Control Language

-- TCL - Transaction Control Language

-- nada com nada

select c.nome, 
    ifnull(c.email, "sem email") as email, ifnull(e.cep, "*** *** *** ***") as cep, 
    ifnull(t.numero, "sem telefone") as telefone,
    e.rua, t.numero
from cliente c
inner join endereco e on c.idcliente = e.fk_idcliente
inner join telefone t on c.idcliente = t.fk_idcliente;


/* view */
CREATE view RELATORIO AS
SELECT 
    c.nome, 
    c.sexo, 
    IFNULL(t.ddd, '--') AS ddd, 
    IFNULL(t.numero, 'Sem Telefone') AS telefone, 
    e.rua, 
    e.numero AS num_casa, 
    e.cep 
FROM cliente c
INNER JOIN endereco e ON c.idcliente = e.fk_idcliente
INNER JOIN telefone t ON c.idcliente = t.fk_idcliente;

SELECT * FROM RELATORIO;

insert into RELATORIO values('ana', 'F', '81', '98888-5555', 'Rua das Acacias', 100, '80000-000'); -- não da pra inserir em view, pq ela é so uma consulta, nao tem armazenamento, entao tem q inserir na tabela cliente, endereco e telefone pra aparecer na view