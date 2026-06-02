-- aula de triggers, procedimentos armazenados e funções (DML)

-- criando triggers

create table produto (
    idproduto serial primary key,
    nome varchar(50) not null,
    preco decimal(10,2) not null
);

-- criação tabela backup
create table backup_produto (
    idbackup serial primary key,
    idproduto int not null,
    nome varchar(50) not null,
    preco decimal(10,2) not null
);

insert into produto (nome, preco) values ('TELEVISÃO', 2000.00);
insert into produto (nome, preco) values ('CELULAR', 1500.00);
insert into produto (nome, preco) values ('NOTEBOOK', 3000.00);

select * from produto;

-- criando a trigger

-- 1. Mudamos o delimitador para $$
DELIMITER $$

CREATE TRIGGER backup_produto_trigger
BEFORE DELETE ON produto
FOR EACH ROW 
BEGIN
    INSERT INTO backup_produto (idproduto, nome, preco)
    VALUES (OLD.idproduto, OLD.nome, OLD.preco);
END$$ -- Fechamos a trigger com o novo delimitador

-- 2. Voltamos o delimitador para o padrão (ponto e vírgula)
DELIMITER ;


-- mostrando o trigger funcionando na pratica
delete from produto where idproduto = 2;

select * from produto;
select * from backup_produto;
-- antes de deletar ele coloca o elemento a ser deletado na tabela backup!

-- OUTRO EXEMPLO  DE TRIGGER--

create table usuario(
    idusuario serial primary key,
    nome varchar(50) not null,
    login varchar(30) not null,
    senha varchar(30) not null
);

create table bkp_usuario(
    idbkp serial primary key,
    idusuario int not null,
    nome varchar(50) not null,
    login varchar(30) not null
);

DELIMITER $$

create trigger backup_usuario_trigger
before delete on usuario
for each row
BEGIN
    INSERT INTO bkp_usuario (idusuario, nome, login)
    VALUES (OLD.idusuario, OLD.nome, OLD.login);
END$$

delimiter ;

insert into usuario (nome, login, senha) values ('JOÃO', 'joao123', 'senha123');

select * from usuario;

delete from usuario where idusuario = 1;

select * from bkp_usuario;

-- ATIVIDADE

-- criando um trigger que armazena historico de preços de um produto

-- criar uma trigger com o historico de preços de um produto 
-- sempre que o valor de um produto for alterado, o valor antigo a o novo valor serão armazenados
-- na tabela historico_preco
create table historico_preco (
    idhistorico serial primary key,
    idproduto int not null,
    preco_antigo decimal(10,2) not null,
    preco_novo decimal(10,2) not null,
    data_alteracao timestamp default current_timestamp
);

DELIMITER $$
create trigger historico_preco_trigger
before update on produto
for each row
BEGIN
    IF OLD.preco <> NEW.preco THEN
        INSERT INTO historico_preco (idproduto, preco_antigo, preco_novo)
        VALUES (OLD.idproduto, OLD.preco, NEW.preco);
    END IF;
END$$
DELIMITER ;