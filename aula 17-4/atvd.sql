-- versao corrigida

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
INSERT INTO aluno (matricula) VALUES (202405);
INSERT INTO aluno (matricula) VALUES (203456);
INSERT INTO aluno (matricula) VALUES (1);


-- Passo 2: O E-mail (0, n)
INSERT INTO emails (fk_matricula, email) VALUES (202405, 'carlos.alberto@email.com');
INSERT INTO emails (fk_matricula, email) VALUES (202405, 'carlinhos232@email.com');
INSERT INTO emails (fk_matricula, email) VALUES (203456, 'carlos-rei-delas@gmail.com');
INSERT INTO emails (fk_matricula, email) VALUES (1, 'root@gmail.com');


-- Passo 3: O Endereço (0, 1)
INSERT INTO endereco (cep, rua, numero, fk_matricula) VALUES ('50000-123', 'Rua das Palmeiras', 45, 202405);
INSERT INTO endereco (cep, rua, numero, fk_matricula) VALUES ('60000-456', 'Avenida dos Pinheiros', 123, 203456);

-- Passo 4: Os 2 Telefones (0, n)
INSERT INTO telefone (ddd, numero, fk_matricula) VALUES ('11', '98888-1111', 202405);
INSERT INTO telefone (ddd, numero, fk_matricula) VALUES ('11', '97777-2222', 202405);
INSERT INTO telefone (ddd, numero, fk_matricula) VALUES ('21', '96666-3333', 203456);
INSERT INTO telefone (ddd, numero, fk_matricula) VALUES ('21', '95555-4444', 1);

-- pt 1
select matricula, ddd, numero, fk_matricula from aluno inner join telefone on matricula = fk_matricula;

-- pt 2
select matricula, concat(t.ddd,'-',t.numero) as telefone, concat(e.rua,',nº ',e.numero) as endereco 
from aluno 
inner join telefone t on matricula = t.fk_matricula
inner join endereco e on matricula = e.fk_matricula;

-- pt 3
select matricula, numero
from aluno, telefone
where ddd='11' and matricula=fk_matricula;