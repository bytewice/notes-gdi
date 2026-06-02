-- atividade dia 22/04
-- comandos DDL e DML para criar e manipular as tabelas do banco de dados

CREATE TABLE aluno (
    matricula INT PRIMARY KEY auto_increment
);

CREATE TABLE emails (
    fk_matricula INT REFERENCES aluno(matricula),
    email VARCHAR(100),
    PRIMARY KEY (fk_matricula, email)
);

CREATE TABLE endereco (
    id_endereco SERIAL PRIMARY KEY auto_increment,
    cep VARCHAR(10),
    rua VARCHAR(100),
    numero INT,
    fk_matricula INT UNIQUE REFERENCES aluno(matricula)
);

CREATE TABLE telefone (
    id_telefone SERIAL PRIMARY KEY auto_increment,
    ddd VARCHAR(3),
    numero VARCHAR(15),
    fk_matricula INT REFERENCES aluno(matricula)
);

-- Passo 1: O Aluno
INSERT INTO aluno (matricula) VALUES (2);
INSERT INTO aluno (matricula) VALUES (3);
INSERT INTO aluno (matricula) VALUES (1);


-- Passo 2: O E-mail (0, n)
INSERT INTO emails (fk_matricula, email) VALUES (2, 'carlos.alberto@email.com');
INSERT INTO emails (fk_matricula, email) VALUES (2, 'carlinhos232@email.com');
INSERT INTO emails (fk_matricula, email) VALUES (3, 'carlos-rei-delas@gmail.com');
INSERT INTO emails (fk_matricula, email) VALUES (1, 'root@gmail.com');


-- Passo 3: O Endereço (0, 1)
INSERT INTO endereco (cep, rua, numero, fk_matricula) VALUES ('50000-123', 'Rua das Palmeiras', 45, 2);
INSERT INTO endereco (cep, rua, numero, fk_matricula) VALUES ('60000-456', 'Avenida dos Pinheiros', 123, 3);

-- Passo 4: Os 2 Telefones (0, n)
INSERT INTO telefone (ddd, numero, fk_matricula) VALUES ('11', '98888-1111', 2);
INSERT INTO telefone (ddd, numero, fk_matricula) VALUES ('81', '97777-2222', 2);
INSERT INTO telefone (ddd, numero, fk_matricula) VALUES ('21', '96666-3333', 3);
INSERT INTO telefone (ddd, numero, fk_matricula) VALUES ('81', '95555-4444', 1);

-- DDL - Data Definition Language

/* inserts */
-- povoando um pouco mais as tabelas:
insert into aluno (matricula) values (4);
insert into aluno (matricula) values (5);
insert into aluno (matricula) values (6);
insert into aluno (matricula) values (7);

insert into emails (fk_matricula, email) values (4, 'ana@email.com');
insert into emails (fk_matricula, email) values (5, 'bia@email.com');
insert into emails (fk_matricula, email) values (6, 'carlos@email.com');
insert into emails (fk_matricula, email) values (7, 'duda@email.com');

insert into endereco (cep, rua, numero, fk_matricula) values ('70000-789', 'Praça das Flores', 10, 4);
insert into endereco (cep, rua, numero, fk_matricula) values ('90000-111', 'Avenida dos Jacarandás', 200, 6);
insert into endereco (cep, rua, numero, fk_matricula) values ('10000-222', 'Rua dos Ipês', 300, 7);

insert into telefone (ddd, numero, fk_matricula) values ('31', '98888-3333', 4);
insert into telefone (ddd, numero, fk_matricula) values ('81', '97777-4444', 4);
insert into telefone (ddd, numero, fk_matricula) values ('41', '96666-5555', 5);
insert into telefone (ddd, numero, fk_matricula) values ('81', '95555-6666', 5);

/* where */
select * from telefone where ddd = '81';

/* update */
-- precisa colocar o numero pq telefone é multivalorado, aí so identificar pela matricula n da certo
update telefone set ddd='82' where fk_matricula = 4 and numero = '97777-4444';

/* delete */
delete from telefone where fk_matricula = 4 and numero = '97777-4444';

-- relatorio da tabela q eu mexi no dml
select * from telefone where ddd = '81';

-- DDL - Data Definition Language

create table dados (
    aluno_id int primary key auto_increment,
    nome varchar(30) not null,
    sexo char(1) not null,
    peso float(5,2) not null,

    fk_matricula INT UNIQUE REFERENCES aluno(matricula)
    );

insert into dados values(null, "joao", "M", 70.5, 2);
insert into dados values(null, "maria", "F", 60.0, 4);
insert into dados values(null, "carlos", "M", 80.0, 5);

/* change */
-- aparentemente o change também funciona com um modify embutido
alter table dados CHANGE nome nome_completo varchar(50) not null;
show columns from dados;

/* modify */
alter table dados modify nome_completo varchar(60) not null;
show columns from dados;

/* apagando coluna */
alter table dados drop column nome_completo;
show columns from dados;

/* adicionando coluna */
-- colocando o first pra ele entrar em primeira posição na tabela
alter table dados add column nome varchar(50) not null first;

-- relatorio final!

SELECT 
    c.matricula, 
    d.nome, 
    e.rua, 
    GROUP_CONCAT(DISTINCT em.email SEPARATOR ', ') AS todos_emails,
    GROUP_CONCAT(DISTINCT CONCAT('(', t.ddd, ') ', t.numero) SEPARATOR ', ') AS todos_telefones
FROM aluno c
LEFT JOIN dados d ON c.matricula = d.fk_matricula
LEFT JOIN endereco e ON c.matricula = e.fk_matricula
LEFT JOIN emails em ON c.matricula = em.fk_matricula
LEFT JOIN telefone t ON c.matricula = t.fk_matricula
GROUP BY c.matricula;
