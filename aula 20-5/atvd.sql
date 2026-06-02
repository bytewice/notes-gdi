
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

create table produto (
    idproduto serial primary key,
    nome varchar(255) not null,
    preco decimal(10,2) not null
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

insert into produto (nome, preco) values ('Produto A', 10.00);
insert into produto (nome, preco) values ('Produto B', 20.00);
insert into produto (nome, preco) values ('Produto C', 30.00);

update produto set preco = 15.00 where idproduto = 1;
update produto set preco = 25.00 where idproduto = 2;

select * from historico_preco;
select * from produto;