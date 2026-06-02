create table funcionario(
    id_funcionario int primary key auto_increment,
    nome varchar(100) not null,
    cpf VARCHAR(14) not null unique,
    cargo varchar(50) not null,
    salario float(8,2) not null,
    data_admissao date not null
);

create table cliente(
    id_cliente int primary key auto_increment,
    pontos_fidelidade int not null,
    nome varchar(100) not null,
    telefone varchar(20) not null,
    data_cadastro date not null,

    id_mesa int
);

create table categoria(
    id_categoria int primary key auto_increment,
    nome varchar(50) not null,
    descricao varchar(255)
);

create table produto(
    id_produto int primary key auto_increment,
    nome varchar(100) not null,
    preco float(8,2) not null,
    status varchar(20) not null,
    tempo_preparo float(8,2) not null,
    descricao varchar(255),

    id_categoria int
);

create table item_pedido(
    id_item int primary key auto_increment,
    quantidade int not null,
    obs varchar(255),
    
    id_produto int,
    id_pedido int
);


create table pedido(
    id_pedido int primary key auto_increment,
    data_pedido date not null,
    valor_total float(8,2) not null,
    status varchar(20) not null,
    
    id_funcionario int,
    id_mesa int
);

create table mesa(
    id_mesa int primary key auto_increment,
    numero int not null,
    capacidade int not null,
    status varchar(20) not null,

    id_funcionario int
);

create table conta(
    id_conta int primary key auto_increment,
    valor float(8,2) not null,
    valor_pago float(8,2) default 0,

    status enum('Aberto', 'Em andamento', 'Pago', 'Cancelado') not null,

    data_pagamento date,
    metodo_pagamento varchar(50),

    id_pedido int,
    id_funcionario int not NULL,
    id_mesa int not NULL,
    id_cliente int
);

-- criação das chaves estrangeiras!

alter table produto
    add constraint fk_produto_categoria foreign key (id_categoria) references categoria(id_categoria);

-- um pedido pode ter vários itens, mas um item pertence a apenas um pedido
alter table item_pedido
    add constraint fk_item_pedido_produto foreign key (id_produto) references produto(id_produto),
    add constraint fk_item_pedido_pedido foreign key (id_pedido) references pedido(id_pedido);

alter table pedido
    add constraint fk_pedido_funcionario foreign key (id_funcionario) references funcionario(id_funcionario),
    add constraint fk_pedido_mesa foreign key (id_mesa) references mesa(id_mesa);

alter table mesa
    add constraint fk_mesa_funcionario foreign key (id_funcionario) references funcionario(id_funcionario);

alter table conta
    add constraint fk_conta_pedido foreign key (id_pedido) references pedido(id_pedido),
    add constraint fk_conta_funcionario foreign key (id_funcionario) references funcionario(id_funcionario),
    add constraint fk_conta_mesa foreign key (id_mesa) references mesa(id_mesa),
    add constraint fk_conta_cliente foreign key (id_cliente) references cliente(id_cliente);


-- pode ter mais de um cliente na mesa, mas um cliente só pode estar em uma mesa
alter table cliente
    add constraint fk_cliente_mesa foreign key (id_mesa) references mesa(id_mesa);

-- povoamento das tabelas

INSERT INTO funcionario
(nome, cpf, cargo, salario, data_admissao)
VALUES
('João Silva', '111.111.111-11', 'Garçom', 2200.00, '2023-01-15'),
('Maria Oliveira', '222.222.222-22', 'Garçom', 2200.00, '2023-03-10'),
('Carlos Santos', '333.333.333-33', 'Caixa', 2800.00, '2022-11-05'),
('Ana Costa', '444.444.444-44', 'Gerente', 5500.00, '2021-08-20'),
('Pedro Lima', '555.555.555-55', 'Cozinheiro', 3500.00, '2022-04-18'),
('Fernanda Souza', '666.666.666-66', 'Cozinheira', 3400.00, '2023-02-01'),
('Lucas Pereira', '777.777.777-77', 'Garçom', 2200.00, '2024-01-12'),
('Juliana Rocha', '888.888.888-88', 'Caixa', 2800.00, '2024-02-15');

INSERT INTO categoria(nome, descricao)
VALUES
('Entradas', 'Porções e aperitivos'),
('Pratos Principais', 'Pratos completos'),
('Massas', 'Massas artesanais'),
('Sobremesas', 'Doces e sobremesas'),
('Bebidas', 'Bebidas em geral');

INSERT INTO produto
(nome, preco, status, tempo_preparo, descricao, id_categoria)
VALUES
('Batata Frita', 18.00, 'Disponivel', 10, 'Porção grande', 1),
('Calabresa Acebolada', 24.00, 'Disponivel', 15, 'Porção para compartilhar', 1),
('Onion Rings', 22.00, 'Disponivel', 12, 'Anéis de cebola crocantes', 1),
('Camarão Empanado', 34.00, 'Disponivel', 18, 'Porção de camarão', 1),

('Hamburguer Artesanal', 32.00, 'Disponivel', 20, '200g de carne', 2),
('Filé à Parmegiana', 48.00, 'Disponivel', 30, 'Filé bovino com queijo', 2),
('Picanha Completa', 65.00, 'Disponivel', 35, 'Serve até 2 pessoas', 2),
('Frango Grelhado', 29.00, 'Disponivel', 25, 'Com arroz e salada', 2),
('Costela Barbecue', 59.00, 'Disponivel', 40, 'Costela ao molho barbecue', 2),
('Salmão Grelhado', 68.00, 'Disponivel', 30, 'Com legumes', 2),

('Lasanha Bolonhesa', 42.00, 'Disponivel', 30, 'Lasanha da casa', 3),
('Espaguete Carbonara', 39.00, 'Disponivel', 20, 'Receita italiana', 3),
('Nhoque ao Molho Branco', 36.00, 'Disponivel', 20, 'Nhoque artesanal', 3),
('Rondelli de Presunto e Queijo', 44.00, 'Disponivel', 25, 'Massa recheada', 3),

('Pudim', 12.00, 'Disponivel', 5, 'Pudim de leite condensado', 4),
('Petit Gateau', 18.00, 'Disponivel', 10, 'Com sorvete', 4),
('Cheesecake', 16.00, 'Disponivel', 5, 'Fatia', 4),
('Brownie com Sorvete', 20.00, 'Disponivel', 8, 'Brownie artesanal', 4),

('Refrigerante Lata', 6.00, 'Disponivel', 1, '350ml', 5),
('Suco Natural', 9.00, 'Disponivel', 5, '300ml', 5),
('Água Mineral', 4.00, 'Disponivel', 1, '500ml', 5),
('Café Expresso', 5.00, 'Disponivel', 2, '50ml', 5),
('Chá Gelado', 7.00, 'Disponivel', 2, '300ml', 5),
('Energético', 12.00, 'Disponivel', 1, 'Lata 250ml', 5),
('Vinho Tinto', 45.00, 'Disponivel', 5, 'Garrafa 750ml', 5);




INSERT INTO mesa
(numero, capacidade, status, id_funcionario)
VALUES
(1, 2, 'Livre', 1),
(2, 2, 'Livre', 1),
(3, 4, 'Ocupada', 2),
(4, 4, 'Ocupada', 2),
(5, 6, 'Reservada', 7),
(6, 6, 'Livre', 7),
(7, 8, 'Livre', 1),
(8, 8, 'Ocupada', 2),
(9, 2, 'Livre', 1),
(10, 4, 'Livre', 2),
(11, 4, 'Ocupada', 7),
(12, 6, 'Livre', 1),
(13, 2, 'Reservada', 2),
(14, 8, 'Ocupada', 7),
(15, 6, 'Livre', 1);

INSERT INTO cliente
(pontos_fidelidade, nome, telefone, data_cadastro, id_mesa)
VALUES
(120, 'Bruno Alves', '81999991111', '2024-01-10', 3),
(50, 'Marcos Pereira', '81999992222', '2024-02-15', 3),

(300, 'Larissa Gomes', '81999993333', '2023-10-20', 4),
(80, 'Paula Nunes', '81999994444', '2024-04-08', 4),

(450, 'Ricardo Souza', '81999995555', '2023-06-30', 5),
(30, 'Amanda Lima', '81999996666', '2025-01-10', 5),
(220, 'Gabriel Costa', '81999997777', '2024-03-15', 5),

(175, 'Eduarda Santos', '81999998888', '2024-07-20', NULL),
(40, 'Felipe Rocha', '81999990000', '2025-01-30', NULL),
(90, 'Camila Martins', '81988887777', '2024-11-15', 8),
(110, 'Thiago Almeida', '81981112222', '2024-08-11', 11),
(65, 'Vanessa Ferreira', '81982223333', '2024-08-18', 11),

(340, 'José Henrique', '81983334444', '2023-09-15', 14),
(280, 'Patricia Gomes', '81984445555', '2023-11-12', 14),
(95, 'André Carvalho', '81985556666', '2024-04-07', 14),

(15, 'Bianca Nogueira', '81986667777', '2025-03-01', NULL),
(45, 'Roberto Azevedo', '81987778888', '2025-02-20', NULL),
(510, 'Tatiane Rocha', '81988889999', '2023-02-01', 13),
(75, 'Daniel Moura', '81989990000', '2024-10-10', 11),
(200, 'Beatriz Santos', '81990001111', '2024-01-15', 14);

INSERT INTO pedido
(data_pedido, valor_total, status, id_funcionario, id_mesa)
VALUES
('2026-06-01', 44.00, 'Finalizado', 1, 3),
('2026-06-01', 80.00, 'Finalizado', 2, 4),
('2026-06-01', 93.00, 'Em preparo', 7, 5),
('2026-06-01', 42.00, 'Aberto', 2, 8),
('2026-06-01', 65.00, 'Finalizado', 1, 3),
('2026-06-01', 57.00, 'Em preparo', 7, 5),
('2026-06-02', 118.00, 'Finalizado', 1, 11),
('2026-06-02', 177.00, 'Finalizado', 2, 14),
('2026-06-02', 41.00, 'Aberto', 7, 13),
('2026-06-02', 95.00, 'Em preparo', 1, 11),
('2026-06-02', 72.00, 'Finalizado', 2, 14),
('2026-06-02', 134.00, 'Em preparo', 7, 14),
('2026-06-02', 24.00, 'Aberto', 1, 9),
('2026-06-02', 58.00, 'Finalizado', 2, 10);

INSERT INTO item_pedido
(quantidade, obs, id_produto, id_pedido)
VALUES

-- pedido 1 = 46
(2, '', 1, 1),
(1, '', 10, 1),
(1, '', 12, 1),

-- pedido 2 = 76
(2, '', 3, 2),
(2, '', 10, 2),

-- pedido 3 = 85
(1, 'Mal passada', 5, 3),
(2, '', 10, 3),
(2, '', 12, 3),

-- pedido 4 = 42
(1, 'Sem queijo', 6, 4),

-- pedido 5 = 65
(1, '', 5, 5),

-- pedido 6 = 57
(1, '', 4, 6),
(1, '', 11, 6),

-- Pedido 7
(2,'',3,7),
(2,'',10,7),
(1,'',8,7),

-- Pedido 8
(1,'Ao ponto',17,8),
(2,'',10,8),
(2,'',21,8),

-- Pedido 9
(1,'',6,9),

-- Pedido 10
(1,'Sem cebola',4,10),
(1,'',20,10),
(3,'',10,10),

-- Pedido 11
(2,'',18,11),
(2,'',22,11),

-- Pedido 12
(2,'',15,12),
(2,'',23,12),
(1,'',21,12),

-- Pedido 13
(1,'',2,13),

-- Pedido 14
(2,'',13,14),
(2,'',22,14),
(1,'',24,14);

INSERT INTO conta
(valor, status, data_pagamento, metodo_pagamento,
id_pedido, id_funcionario, id_mesa, id_cliente)
VALUES

(44.00, 'Pago', '2026-06-01', 'PIX',
1, 3, 3, 1),

(80.00, 'Pago', '2026-06-01', 'Cartao Credito',
2, 8, 4, 3),

(93.00, 'Em andamento', NULL, NULL,
3, 3, 5, 5),

(42.00, 'Aberto', NULL, NULL,
4, 8, 8, 10),

(65.00, 'Pago', '2026-06-01', 'Dinheiro',
5, 3, 3, 2),

(57.00, 'Em andamento', NULL, NULL,
6, 8, 5, 6),

(118.00, 'Pago', '2026-06-02', 'PIX',
7, 3, 11, 11),

(177.00, 'Pago', '2026-06-02', 'Cartao Credito',
8, 8, 14, 13),

(41.00, 'Aberto', NULL, NULL,
9, 3, 13, 18),

(95.00, 'Em andamento', NULL, NULL,
10, 8, 11, 12),

(72.00, 'Pago', '2026-06-02', 'Dinheiro',
11, 3, 14, 14),

(134.00, 'Em andamento', NULL, NULL,
12, 8, 14, 15),

(24.00, 'Aberto', NULL, NULL,
13, 3, 9, NULL),

(58.00, 'Pago', '2026-06-02', 'PIX',
14, 8, 10, NULL);

-- adicionei depois esse parâmetro, aí to atualizando aq msm
update conta set valor_pago = valor where status = 'Pago';

-- DML - UPDATE E delete

-- atualizar status da mesa após realizar reserva'
update mesa set status = 'Reservada' where id_mesa = 2;

-- produto indisponível, update para destacar data_admissao
select status from produto where id_produto = 5;
update produto set status = 'Em falta' where id_produto = 5;
select status from produto where id_produto = 5;

-- aumento de salários de um cargo específico
select salario from funcionario where cargo = 'Caixa';
update funcionario set salario = 10 * salario where cargo = 'Caixa';
select salario from funcionario where cargo = 'Caixa';

-- remover produto descontinuado (nenhum pedido!)
select * from produto where id_produto = 25;
delete from produto where id_produto = 25;
select * from produto where id_produto = 25;


-- trigger para atualizar o valor da conta quando um item é adicionado ao pedido
delimiter $$

create trigger adicionar_valor_item_pedido_na_conta
after insert on item_pedido
for each row
begin
    update conta set valor = valor + (new.quantidade * (select preco from produto where id_produto = new.id_produto))
    where id_conta = new.id_pedido;
end$$
delimiter ;

select * from conta;
-- adicionar um item ao pedido 13
insert into item_pedido (quantidade, obs, id_produto, id_pedido)
values (2, 'Sem cebola', 6, 13);
select * from conta;



-- procedure 
delimiter $$

-- procedure pra fechar a conta: não aceitar mais itens, atualizar status para em andamento!
create procedure fechar_conta(
    in p_id_conta int
)
begin
    update conta set status = 'Em andamento'
    where id_conta = p_id_conta;
end$$

create procedure pagar_conta(
    in p_id_conta int,
    in p_valor_pago float(8,2),
    in p_cliente_id int,
    in p_metodo_pagamento varchar(50),
    out p_troco float(8,2),
    out p_falta_pagar float(8,2)
)
begin
    declare valor_conta float(8,2);
    select valor into valor_conta from conta where id_conta = p_id_conta;
    
    if p_valor_pago >= valor_conta then
        update conta set status = 'Pago', valor_pago = p_valor_pago, data_pagamento = current_date, metodo_pagamento = p_metodo_pagamento
        where id_conta = p_id_conta;
        set p_falta_pagar = 0;
        set p_troco = p_valor_pago - valor_conta;
        update cliente set pontos_fidelidade = pontos_fidelidade + floor(valor_conta / 10) where id_cliente = p_cliente_id;
    else
        update conta set valor_pago = p_valor_pago, data_pagamento = current_date, metodo_pagamento = p_metodo_pagamento
        where id_conta = p_id_conta;
        set p_falta_pagar = valor_conta - p_valor_pago;
        set p_troco = 0;
        update cliente set pontos_fidelidade = pontos_fidelidade + floor(p_valor_pago / 10) where id_cliente = p_cliente_id;
    end if;
end$$
