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
('Hamburguer Artesanal', 32.00, 'Disponivel', 20, '200g de carne', 2),
('Filé à Parmegiana', 48.00, 'Disponivel', 30, 'Filé bovino com queijo', 2),
('Picanha Completa', 65.00, 'Disponivel', 35, 'Serve até 2 pessoas', 2),
('Lasanha Bolonhesa', 42.00, 'Disponivel', 30, 'Lasanha da casa', 3),
('Espaguete Carbonara', 39.00, 'Disponivel', 20, 'Receita italiana', 3),
('Pudim', 12.00, 'Disponivel', 5, 'Pudim de leite condensado', 4),
('Petit Gateau', 18.00, 'Disponivel', 10, 'Com sorvete', 4),
('Refrigerante Lata', 6.00, 'Disponivel', 1, '350ml', 5),
('Suco Natural', 9.00, 'Disponivel', 5, '300ml', 5),
('Água Mineral', 4.00, 'Disponivel', 1, '500ml', 5);

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
(8, 8, 'Ocupada', 2);

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
(90, 'Camila Martins', '81988887777', '2024-11-15', 8);

INSERT INTO pedido
(data_pedido, valor_total, status, id_funcionario, id_mesa)
VALUES
('2026-06-01', 44.00, 'Finalizado', 1, 3),
('2026-06-01', 80.00, 'Finalizado', 2, 4),
('2026-06-01', 93.00, 'Em preparo', 7, 5),
('2026-06-01', 42.00, 'Aberto', 2, 8),
('2026-06-01', 65.00, 'Finalizado', 1, 3),
('2026-06-01', 57.00, 'Em preparo', 7, 5);

INSERT INTO item_pedido
(quantidade, obs, id_produto, id_pedido)
VALUES

(2, '', 1, 1),
(1, '', 10, 1),
(1, '', 12, 1),

(2, '', 3, 2),
(2, '', 10, 2),

(1, 'Mal passada', 5, 3),
(2, '', 10, 3),
(2, '', 12, 3),

(1, 'Sem queijo', 6, 4),

(1, '', 5, 5),

(1, '', 4, 6),
(1, '', 11, 6);

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
6, 8, 5, 6);