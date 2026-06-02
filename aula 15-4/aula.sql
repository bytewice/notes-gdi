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
    
    fk_idcliente int not null,
    foreign key (fk_idcliente) references cliente(idcliente)
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

select * from cliente;

insert into endereco values(null, "50000-123", "Rua das Palmeiras", 45, 1);
insert into endereco values(null, "60000-456", "Avenida dos Pinheiros", 123, 2);
insert into endereco values(null, "70000-789", "Praça das Flores", 10, 3);
