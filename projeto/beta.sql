--  SISTEMA DE CONTROLE DE PEDIDOS DE RESTAURANTE
--  Banco de Dados Relacional - MySQL
--  Disciplina: Gerenciamento de Banco de Dados

--  DDL - CRIAÇÃO DAS TABELAS

CREATE TABLE categoria (
    id_categoria   INT           NOT NULL AUTO_INCREMENT,
    nome           VARCHAR(60)   NOT NULL,
    descricao      VARCHAR(200),
    PRIMARY KEY (id_categoria)
);

CREATE TABLE produto (
    id_produto     INT             NOT NULL AUTO_INCREMENT,
    id_categoria   INT             NOT NULL,
    nome           VARCHAR(100)    NOT NULL,
    descricao      VARCHAR(300),
    preco          DECIMAL(8,2)    NOT NULL,
    disponivel     TINYINT(1)      NOT NULL DEFAULT 1,
    PRIMARY KEY (id_produto),
    CONSTRAINT fk_produto_categoria FOREIGN KEY (id_categoria)
        REFERENCES categoria(id_categoria)
);

CREATE TABLE mesa (
    id_mesa        INT           NOT NULL AUTO_INCREMENT,
    numero         INT           NOT NULL UNIQUE,
    capacidade     INT           NOT NULL,
    status         ENUM('livre','ocupada','reservada') NOT NULL DEFAULT 'livre',
    PRIMARY KEY (id_mesa)
);

CREATE TABLE funcionario (
    id_funcionario INT           NOT NULL AUTO_INCREMENT,
    nome           VARCHAR(100)  NOT NULL,
    cpf            CHAR(11)      NOT NULL UNIQUE,
    cargo          ENUM('garcom','cozinheiro','caixa','gerente') NOT NULL,
    salario        DECIMAL(8,2)  NOT NULL,
    data_admissao  DATE          NOT NULL,
    ativo          TINYINT(1)    NOT NULL DEFAULT 1,
    PRIMARY KEY (id_funcionario)
);

CREATE TABLE cliente (
    id_cliente     INT           NOT NULL AUTO_INCREMENT,
    nome           VARCHAR(100)  NOT NULL,
    telefone       VARCHAR(20),
    email          VARCHAR(120)  UNIQUE,
    data_cadastro  DATE          NOT NULL,
    PRIMARY KEY (id_cliente)
);

CREATE TABLE pedido (
    id_pedido      INT           NOT NULL AUTO_INCREMENT,
    id_mesa        INT           NOT NULL,
    id_funcionario INT           NOT NULL,
    id_cliente     INT,
    data_hora      DATETIME      NOT NULL DEFAULT CURRENT_TIMESTAMP,
    status         ENUM('aberto','em_preparo','pronto','entregue','cancelado') NOT NULL DEFAULT 'aberto',
    observacao     VARCHAR(300),
    PRIMARY KEY (id_pedido),
    CONSTRAINT fk_pedido_mesa        FOREIGN KEY (id_mesa)        REFERENCES mesa(id_mesa),
    CONSTRAINT fk_pedido_funcionario FOREIGN KEY (id_funcionario) REFERENCES funcionario(id_funcionario),
    CONSTRAINT fk_pedido_cliente     FOREIGN KEY (id_cliente)     REFERENCES cliente(id_cliente)
);

-- Tabela associativa N:N  pedido <-> produto
CREATE TABLE item_pedido (
    id_item        INT             NOT NULL AUTO_INCREMENT,
    id_pedido      INT             NOT NULL,
    id_produto     INT             NOT NULL,
    quantidade     INT             NOT NULL DEFAULT 1,
    preco_unitario DECIMAL(8,2)    NOT NULL,
    observacao     VARCHAR(200),
    PRIMARY KEY (id_item),
    CONSTRAINT fk_item_pedido   FOREIGN KEY (id_pedido)  REFERENCES pedido(id_pedido),
    CONSTRAINT fk_item_produto  FOREIGN KEY (id_produto) REFERENCES produto(id_produto)
);

CREATE TABLE pagamento (
    id_pagamento   INT             NOT NULL AUTO_INCREMENT,
    id_pedido      INT             NOT NULL UNIQUE,
    id_funcionario INT             NOT NULL,
    forma_pagamento ENUM('dinheiro','cartao_credito','cartao_debito','pix') NOT NULL,
    valor_total    DECIMAL(8,2)    NOT NULL,
    valor_pago     DECIMAL(8,2)    NOT NULL,
    troco          DECIMAL(8,2)    NOT NULL DEFAULT 0.00,
    data_hora      DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (id_pagamento),
    CONSTRAINT fk_pagamento_pedido      FOREIGN KEY (id_pedido)      REFERENCES pedido(id_pedido),
    CONSTRAINT fk_pagamento_funcionario FOREIGN KEY (id_funcionario) REFERENCES funcionario(id_funcionario)
);

--  DDL - ALTER TABLE

ALTER TABLE produto ADD COLUMN tempo_preparo_min INT DEFAULT 15;
ALTER TABLE cliente ADD COLUMN pontos_fidelidade INT NOT NULL DEFAULT 0;

--  DML - INSERT  (mínimo 10 registros por tabela)

-- Categorias
INSERT INTO categoria (nome, descricao) VALUES
('Entradas',      'Petiscos e aperitivos para compartilhar'),
('Pratos Principais', 'Refeições completas'),
('Massas',        'Pratos à base de macarrão e lasanha'),
('Sobremesas',    'Doces e sobremesas da casa'),
('Bebidas',       'Refrigerantes, sucos e água'),
('Grelhados',     'Carnes e frutos do mar grelhados'),
('Vegetariano',   'Opções sem carne'),
('Crianças',      'Porções menores para crianças');

-- Produtos
INSERT INTO produto (id_categoria, nome, descricao, preco, disponivel, tempo_preparo_min) VALUES
(1, 'Batata Frita',          'Porção de batata frita',             19.90, 1, 15),
(1, 'Bolinho de Bacalhau',   '8 unidades com molho',                        28.50, 1, 20),
(1, 'Bruschetta',            'Pão italiano com tomate e manjericão',        22.00, 1, 10),
(2, 'Frango Grelhado',       'Peito de frango com legumes salteados',       42.90, 1, 30),
(2, 'File de Tilapia',       'Tilápia grelhada com arroz e salada',         49.90, 1, 35),
(2, 'Picanha na Brasa',      '300g de picanha com farofa e vinagrete',      79.90, 1, 40),
(3, 'Espaguete Bolonhesa',   'Macarrão com molho à bolonhesa',              38.50, 1, 25),
(3, 'Lasanha de Carne',      'Lasanha com queijo gratinado',    44.00, 1, 35),
(4, 'Pudim de Leite',        'Pudim caseiro com calda',         14.90, 1, 5),
(4, 'Brownie com Sorvete',   'Brownie quente com sorvete de baunilha',      18.90, 1, 5),
(5, 'Refrigerante Lata',     'Coca-Cola, Guaraná ou Sprite 350ml',          7.00, 1, 2),
(5, 'Suco Natural',          'Laranja, maracujá ou limão 400ml',            12.00, 1, 5),
(5, 'Água Mineral',          'Garrafa 500ml com ou sem gás',                5.00, 1, 1),
(6, 'Salmão Grelhado',       'Salmão com molho de maracujá e aspargos',     68.90, 1, 30),
(7, 'Risoto de Cogumelos',   'Risoto cremoso de cogumelos variados',        45.00, 1, 30);

-- Mesas
INSERT INTO mesa (numero, capacidade, status) VALUES
(1, 2, 'livre'),
(2, 4, 'ocupada'),
(3, 4, 'livre'),
(4, 6, 'ocupada'),
(5, 6, 'livre'),
(6, 8, 'reservada'),
(7, 2, 'livre'),
(8, 4, 'ocupada'),
(9, 4, 'livre'),
(10, 8, 'livre');

-- Funcionários
INSERT INTO funcionario (nome, cpf, cargo, salario, data_admissao) VALUES
('Carlos Andrade',    '11122233344', 'gerente',     4500.00, '2018-03-10'),
('Ana Lima',          '22233344455', 'caixa',       2200.00, '2020-06-15'),
('Roberto Silva',     '33344455566', 'garcom',      1800.00, '2021-01-20'),
('Fernanda Costa',    '44455566677', 'garcom',      1800.00, '2021-07-05'),
('Marcos Pereira',    '55566677788', 'cozinheiro',  2600.00, '2019-11-12'),
('Juliana Souza',     '66677788899', 'cozinheiro',  2600.00, '2020-04-01'),
('Pedro Alves',       '77788899900', 'garcom',      1800.00, '2022-02-14'),
('Beatriz Nunes',     '88899900011', 'caixa',       2200.00, '2022-09-30'),
('Lucas Ferreira',    '99900011122', 'garcom',      1800.00, '2023-03-18'),
('Tatiane Oliveira',  '10011122233', 'cozinheiro',  2600.00, '2023-08-22');

-- Clientes
INSERT INTO cliente (nome, telefone, email, data_cadastro) VALUES
('João Mendes',       '81991110001', 'joao.mendes@email.com',    '2023-01-05'),
('Maria Barbosa',     '81992220002', 'maria.barbosa@email.com',  '2023-02-14'),
('Paulo Rodrigues',   '81993330003', 'paulo.rod@email.com',      '2023-04-20'),
('Luciana Torres',    '81994440004', 'lu.torres@email.com',      '2023-05-11'),
('Felipe Castro',     '81995550005', 'felipe.c@email.com',       '2023-07-30'),
('Renata Gomes',      '81996660006', 'renata.gomes@email.com',   '2023-08-19'),
('Eduardo Ramos',     '81997770007', 'edu.ramos@email.com',      '2024-01-03'),
('Cristina Pinto',    '81998880008', 'cris.pinto@email.com',     '2024-02-28'),
('André Melo',        '81999990009', 'andre.melo@email.com',     '2024-05-15'),
('Sabrina Freitas',   '81900000010', 'sabrina.f@email.com',      '2024-06-01'),
('Rafael Teixeira',   '81911110011', 'rafael.t@email.com',       '2024-09-10'),
('Patricia Leal',     '81922220012', NULL,                       '2025-01-22');

-- Pedidos
INSERT INTO pedido (id_mesa, id_funcionario, id_cliente, data_hora, status, observacao) VALUES
(2, 3, 1,  '2025-05-20 12:05:00', 'entregue',   NULL),
(4, 4, 2,  '2025-05-20 12:30:00', 'entregue',   'Sem pimenta'),
(8, 7, 3,  '2025-05-20 13:00:00', 'entregue',   NULL),
(2, 3, 4,  '2025-05-21 19:15:00', 'entregue',   NULL),
(4, 4, 5,  '2025-05-21 19:45:00', 'entregue',   'Aniversário'),
(8, 7, 6,  '2025-05-21 20:00:00', 'cancelado',  'Cliente desistiu'),
(2, 9, 7,  '2025-05-22 12:10:00', 'entregue',   NULL),
(4, 3, 8,  '2025-05-22 12:50:00', 'entregue',   NULL),
(8, 4, 9,  '2025-05-22 20:05:00', 'entregue',   NULL),
(4, 9, 10, '2025-05-23 13:00:00', 'entregue',   NULL),
(2, 3, 11, '2025-05-28 12:20:00', 'em_preparo', NULL),
(8, 7, 12, '2025-05-28 12:35:00', 'aberto',     NULL);

-- Itens de Pedido
INSERT INTO item_pedido (id_pedido, id_produto, quantidade, preco_unitario, observacao) VALUES
-- Pedido 1
(1, 1, 1, 19.90, NULL),
(1, 4, 1, 42.90, NULL),
(1, 11,2,  7.00, NULL),
-- Pedido 2
(2, 2, 1, 28.50, NULL),
(2, 7, 2, 38.50, 'Al dente'),
(2, 13,2,  5.00, NULL),
-- Pedido 3
(3, 6, 1, 79.90, NULL),
(3, 9, 2, 14.90, NULL),
(3, 12,2, 12.00, NULL),
-- Pedido 4
(4, 5, 1, 49.90, NULL),
(4, 3, 1, 22.00, NULL),
(4, 11,1,  7.00, NULL),
-- Pedido 5
(5, 6, 2, 79.90, NULL),
(5, 14,1, 68.90, NULL),
(5, 10,2, 18.90, NULL),
(5, 12,4, 12.00, NULL),
-- Pedido 6 (cancelado - sem itens relevantes)
(6, 1, 1, 19.90, NULL),
-- Pedido 7
(7, 8, 1, 44.00, NULL),
(7, 11,2,  7.00, NULL),
-- Pedido 8
(8, 15,1, 45.00, NULL),
(8, 9, 1, 14.90, NULL),
(8, 13,1,  5.00, NULL),
-- Pedido 9
(9, 4, 2, 42.90, NULL),
(9, 1, 1, 19.90, NULL),
(9, 12,2, 12.00, NULL),
-- Pedido 10
(10,6, 1, 79.90, NULL),
(10,7, 1, 38.50, NULL),
(10,11,3,  7.00, NULL),
-- Pedido 11
(11,4, 1, 42.90, NULL),
(11,1, 1, 19.90, NULL),
-- Pedido 12
(12,2, 1, 28.50, NULL),
(12,13,2,  5.00, NULL);

-- Pagamentos
INSERT INTO pagamento (id_pedido, id_funcionario, forma_pagamento, valor_total, valor_pago, troco, data_hora) VALUES
(1, 2, 'cartao_debito',  83.70, 83.70,  0.00, '2025-05-20 13:10:00'),
(2, 2, 'pix',           120.50,120.50,  0.00, '2025-05-20 13:40:00'),
(3, 8, 'dinheiro',      133.60,150.00, 16.40, '2025-05-20 14:05:00'),
(4, 2, 'cartao_credito',  78.90, 78.90,  0.00, '2025-05-21 20:20:00'),
(5, 8, 'pix',           344.40,344.40,  0.00, '2025-05-21 21:30:00'),
(7, 2, 'dinheiro',       58.00, 60.00,  2.00, '2025-05-22 13:20:00'),
(8, 8, 'cartao_debito',  64.90, 64.90,  0.00, '2025-05-22 13:55:00'),
(9, 2, 'pix',           109.70,109.70,  0.00, '2025-05-22 21:10:00'),
(10,8, 'cartao_credito', 139.40,139.40,  0.00, '2025-05-23 14:00:00');

--  DML - UPDATE e DELETE

-- Atualizar status da mesa após pedido entregue
UPDATE mesa SET status = 'livre' WHERE id_mesa = 2;

-- Produto temporariamente indisponível
UPDATE produto SET disponivel = 0 WHERE id_produto = 6;

-- Corrigir salário por acordo coletivo
UPDATE funcionario SET salario = salario * 1.05 WHERE cargo = 'garcom';

-- Adicionar pontos de fidelidade ao cliente que mais gastou
UPDATE cliente SET pontos_fidelidade = 500 WHERE id_cliente = 5;

-- Remover produto descontinuado (sem pedidos)
-- (apenas demonstrativo, delete seguro em tabela sem FK pendente)
INSERT INTO produto (id_categoria, nome, descricao, preco, disponivel)
    VALUES (8, 'Mini Pizza Infantil', 'Para exclusão', 9.90, 0);
DELETE FROM produto WHERE nome = 'Mini Pizza Infantil';

--  PROCEDURE
DELIMITER $$

CREATE PROCEDURE sp_fechar_conta(
    IN  p_id_pedido      INT,
    IN  p_id_funcionario INT,
    IN  p_forma          ENUM('dinheiro','cartao_credito','cartao_debito','pix'),
    IN  p_valor_pago     DECIMAL(8,2),
    OUT p_total          DECIMAL(8,2),
    OUT p_troco          DECIMAL(8,2)
)
BEGIN
    DECLARE v_total DECIMAL(8,2);

    -- Calcular total do pedido
    SELECT SUM(quantidade * preco_unitario)
      INTO v_total
      FROM item_pedido
     WHERE id_pedido = p_id_pedido;

    SET p_total = IFNULL(v_total, 0);
    SET p_troco = p_valor_pago - p_total;

    -- Registrar pagamento
    INSERT INTO pagamento (id_pedido, id_funcionario, forma_pagamento,
                           valor_total, valor_pago, troco)
    VALUES (p_id_pedido, p_id_funcionario, p_forma,
            p_total, p_valor_pago, p_troco);

    -- Atualizar status do pedido
    UPDATE pedido SET status = 'entregue' WHERE id_pedido = p_id_pedido;

    -- Liberar mesa
    UPDATE mesa m
      JOIN pedido p ON p.id_mesa = m.id_mesa
       SET m.status = 'livre'
     WHERE p.id_pedido = p_id_pedido;
END$$

DELIMITER ;

-- Exemplo de chamada:
-- CALL sp_fechar_conta(11, 2, 'pix', 70.00, @total, @troco);
-- SELECT @total AS total, @troco AS troco;

--  CONSULTAS SQL

-- 1. SELECT simples
-- Listar todos os produtos disponíveis com preço ordenado
SELECT id_produto, nome, preco
FROM produto
WHERE disponivel = 1
ORDER BY preco;

-- 2. SELECT com WHERE
-- Pedidos abertos ou em preparo com data e mesa
SELECT p.id_pedido, m.numero AS mesa, p.data_hora, p.status
FROM pedido p
JOIN mesa m ON m.id_mesa = p.id_mesa
WHERE p.status IN ('aberto', 'em_preparo')
ORDER BY p.data_hora;

-- 3. INNER JOIN
-- Itens detalhados de um pedido específico
SELECT ip.id_pedido, pr.nome AS produto,
       ip.quantidade, ip.preco_unitario,
       (ip.quantidade * ip.preco_unitario) AS subtotal
FROM item_pedido ip
INNER JOIN produto pr ON pr.id_produto = ip.id_produto
WHERE ip.id_pedido = 5;

-- 4. LEFT JOIN
-- Todos os clientes e seus pedidos (inclusive sem pedido)
SELECT c.nome AS cliente, COUNT(p.id_pedido) AS total_pedidos
FROM cliente c
LEFT JOIN pedido p ON p.id_cliente = c.id_cliente
GROUP BY c.id_cliente, c.nome
ORDER BY total_pedidos DESC;

-- 5. GROUP BY + COUNT
-- Quantidade de pedidos por garçom
SELECT f.nome AS funcionario, f.cargo,
       COUNT(p.id_pedido) AS qtd_pedidos
FROM funcionario f
LEFT JOIN pedido p ON p.id_funcionario = f.id_funcionario
WHERE f.cargo = 'garcom'
GROUP BY f.id_funcionario, f.nome, f.cargo
ORDER BY qtd_pedidos DESC;

-- 6. GROUP BY + SUM
-- Faturamento total por forma de pagamento
SELECT forma_pagamento,
       COUNT(*)          AS qtd_transacoes,
       SUM(valor_total)  AS total_arrecadado,
       AVG(valor_total)  AS ticket_medio
FROM pagamento
GROUP BY forma_pagamento
ORDER BY total_arrecadado DESC;

-- 7. Consulta complexa: ranking de produtos mais vendidos
SELECT pr.nome AS produto, c.nome AS categoria,
       SUM(ip.quantidade)                             AS unidades_vendidas,
       SUM(ip.quantidade * ip.preco_unitario)         AS receita_total
FROM item_pedido ip
INNER JOIN produto  pr ON pr.id_produto   = ip.id_produto
INNER JOIN categoria c ON c.id_categoria  = pr.id_categoria
INNER JOIN pedido    p ON p.id_pedido     = ip.id_pedido
WHERE p.status != 'cancelado'
GROUP BY pr.id_produto, pr.nome, c.nome
ORDER BY receita_total DESC
LIMIT 10;

-- 8. Faturamento diário
SELECT DATE(data_hora)       AS data,
       COUNT(*)              AS pedidos_pagos,
       SUM(valor_total)      AS faturamento,
       MAX(valor_total)      AS maior_conta,
       MIN(valor_total)      AS menor_conta
FROM pagamento
GROUP BY DATE(data_hora)
ORDER BY data;

-- 9. Clientes com gasto total e média por pedido
SELECT c.nome AS cliente, c.email,
       COUNT(DISTINCT p.id_pedido)              AS visitas,
       SUM(ip.quantidade * ip.preco_unitario)   AS gasto_total,
       AVG(ip.quantidade * ip.preco_unitario)   AS media_por_item
FROM cliente c
INNER JOIN pedido     p  ON p.id_cliente  = c.id_cliente
INNER JOIN item_pedido ip ON ip.id_pedido = p.id_pedido
WHERE p.status != 'cancelado'
GROUP BY c.id_cliente, c.nome, c.email
ORDER BY gasto_total DESC;

-- 10. Mesas com maior rotatividade
SELECT m.numero                                AS mesa,
       m.capacidade,
       COUNT(p.id_pedido)                      AS total_atendimentos,
       SUM(pg.valor_total)                     AS receita_total
FROM mesa m
LEFT JOIN pedido   p  ON p.id_mesa   = m.id_mesa
LEFT JOIN pagamento pg ON pg.id_pedido = p.id_pedido
WHERE p.status IN ('entregue') OR p.id_pedido IS NULL
GROUP BY m.id_mesa, m.numero, m.capacidade
ORDER BY receita_total DESC;

-- 11. Categorias com maior receitas
SELECT c.nome AS categoria,
       COUNT(DISTINCT ip.id_pedido) AS pedidos_com_categoria,
       SUM(ip.quantidade)           AS itens_vendidos,
       SUM(ip.quantidade * ip.preco_unitario) AS receita
FROM categoria c
INNER JOIN produto     pr ON pr.id_categoria = c.id_categoria
INNER JOIN item_pedido ip ON ip.id_produto   = pr.id_produto
INNER JOIN pedido       p ON p.id_pedido     = ip.id_pedido
WHERE p.status != 'cancelado'
GROUP BY c.id_categoria, c.nome
HAVING receita > 50
ORDER BY receita DESC;

-- 12. Subquery: pedidos acima do ticket médio geral
SELECT p.id_pedido,
       m.numero                                    AS mesa,
       f.nome                                      AS garcom,
       SUM(ip.quantidade * ip.preco_unitario)      AS total_pedido
FROM pedido p
INNER JOIN mesa       m  ON m.id_mesa      = p.id_mesa
INNER JOIN funcionario f  ON f.id_funcionario = p.id_funcionario
INNER JOIN item_pedido ip ON ip.id_pedido  = p.id_pedido
WHERE p.status != 'cancelado'
GROUP BY p.id_pedido, m.numero, f.nome
HAVING total_pedido > (
    SELECT AVG(sub_total) FROM (
        SELECT SUM(quantidade * preco_unitario) AS sub_total
        FROM item_pedido ip2
        INNER JOIN pedido p2 ON p2.id_pedido = ip2.id_pedido
        WHERE p2.status != 'cancelado'
        GROUP BY ip2.id_pedido
    ) AS medias
)
ORDER BY total_pedido DESC;

-- DROP TABLE IF EXISTS pagamento, item_pedido, pedido,
-- cliente, funcionario, mesa, produto, categoria;