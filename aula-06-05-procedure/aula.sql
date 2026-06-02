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

/* procedure */


-- status
-- delimiter ;

/*
create procedure NOME_EMPRESA()
begin
    select "dados" as nome_empresa;
end;
*/

/*
create procedure conta(numero1 int, numero2 int)
begin
    select numero1 + numero2 as conta;
end;
*/

create table curso (
    idcurso int primary key auto_increment,
    nome varchar(30) not null,
    horas int not null,
    preco float(5,2) not null
);

insert into curso values (null, "SQL Básico", 20, 199.99);
insert into curso values (null, "SQL Avançado", 40, 299.99);
select * from curso;

delimiter $
create Procedure cad_curso ( nome varchar(30), horas int, preco float(5,2))
begin
    insert into curso values (null, nome, horas, preco);
end$

delimiter ;

-- Testando a Procedure
call cad_curso('Lógica de Programação', 30, 150.00); -- como se fosse uma chamada de função

select * from curso;


create table vendedores (
    idvendedor int primary key auto_increment,
    nome varchar(30) not null,
    sexo char(1)    not null,
    janeiro float(10,2) not null,
    fevereiro float(10,2) not null,
    marco float(10,2) not null
);

insert into vendedores values (null, "Ana", "F", 1000.00, 1500.00, 2000.00);
insert into vendedores values (null, "Bruno", "M", 2000.00, 2500.00, 3000.00);
insert into vendedores values (null, "Carla", "F", 1500.00, 2000.00, 2500.00); 
insert into vendedores values (null, "Diego", "M", 3000.00, 3500.00, 4000.00);

/* MAX - valor maximo de uma coluna */
select max(janeiro) as top_janeiro from vendedores;
select max(fevereiro) as top_fevereiro from vendedores;
select max(marco) as top_marco from vendedores;

/* MIN - valor minimo de uma coluna */
select min(janeiro) as low_janeiro from vendedores;
select min(fevereiro) as low_fevereiro from vendedores;
select min(marco) as low_marco from vendedores;

select max(janeiro), min(janeiro), avg(janeiro) from vendedores; --  avg é a média

-- TRUNCATE
select max(janeiro), min(janeiro), truncate(avg(janeiro), 2) from vendedores; --  avg é a média

select sum(janeiro) as total_janeiro from vendedores; -- sum é a soma de uma coluna