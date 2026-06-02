-- auto relacionamento!

create table cursos(
    idcurso serial primary key,
    nome varchar(255) not null,
    horas int not null,
    valor float (10,2) not null,

    idcurso_prerequisito bigint unsigned
);

alter table cursos add constraint fk_curso_prerequisito foreign key (idcurso_prerequisito) references cursos(idcurso);

insert into cursos (nome, horas, valor) values ('Curso de SQL', 40, 200.00);
insert into cursos (nome, horas, valor, idcurso_prerequisito) values ('Curso de SQL Avançado', 40, 300.00, 1);
insert into cursos (nome, horas, valor, idcurso_prerequisito) values ('Curso de SQL PRO', 40, 250.00, 1);
insert into cursos (nome, horas, valor) values ('Curso de Python', 40, 250.00);
insert into cursos (nome, horas, valor, idcurso_prerequisito) values ('Curso de Python Avançado', 40, 350.00, 4);

select * from cursos;

select nome, valor, horas, IFNULL(idcurso_prerequisito, 'Sem pré-requisito') from cursos;

-- apresentar o nome, valor, horas e o nome do pre requisito, caso haja um pre requisito, caso contrário, apresentar 'Sem pré-requisito'
select c.nome, c.valor, c.horas, IFNULL(p.nome, 'Sem pré-requisito') as nome_prerequisito
from cursos c
left join cursos p on c.idcurso_prerequisito = p.idcurso;

-- cursores