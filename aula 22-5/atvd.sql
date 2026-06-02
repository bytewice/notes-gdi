-- auto relacionamento

/* Imagine uma tabela de funcionários com os seguintes atributos:
  Nome, cargo, IDGERENTE.
  Nesse caso o ID GERENTE é a sua FK.
  Elabore uma tabela de auto relacionamento e utilize
  os queries usados em sala; */

create table funcionario(
idfuncionario serial primary key,
nome varchar(50) not null,
cargo varchar(50) not null,

id_gerente bigint UNSIGNED
);

alter table funcionario add constraint fk_gerente_funcionario foreign key (id_gerente) references funcionario(idfuncionario);

show create table funcionario;

insert into funcionario (nome, cargo) values ('JOAO', 'ANALISTA');
insert into funcionario (nome, cargo, id_gerente) values ('MARIA', 'ANALISTA', 1);
insert into funcionario (nome, cargo, id_gerente) values ('CARLOS', 'ANALISTA', 1);
insert into funcionario (nome, cargo, id_gerente) values ('ANA', 'ANALISTA', 2);
insert into funcionario (nome, cargo, id_gerente) values ('PEDRO', 'ANALISTA', 2);
insert into funcionario (nome, cargo, id_gerente) values ('LUCAS', 'ANALISTA', 3);
insert into funcionario (nome, cargo, id_gerente) values ('MARCELO', 'ANALISTA', 3);

select * from funcionario;

select c.nome, c.cargo, IFNULL(g.nome, 'Sem gerente') as nome_gerente
from funcionario c
left join funcionario g on c.id_gerente = g.idfuncionario;
