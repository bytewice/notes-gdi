/*
Uma empresa deseja gerar um relatório automático contendo o total e a média trimestral de vendas de seus funcionários. Para isso crie uma tabela com as seguintes informações: IDFUNCIONARIO; NOME; JAN; FEV; MAR. 

Considere também uma tabela que armazenará os resultados ( como por exemplo: 

RELATORIO_VENDAS).

a) Crie uma procedure chamada GERAR_RELATORIO utilizando um para percorrer todos os registros da tabela FUNCIONARIOS.
b) Durante a leitura de cada registro, calcule: o TOTAL de vendas do trimestre e a MÉDIA trimestral de vendas.
c) Insira os resultados calculados na tabela RELATORIO_VENDAS e execute a 

procedure criada.
*/

create table funcionarios (
    idfuncionario int primary key auto_increment,
    nome varchar(30) not null,
    janeiro float(10,2) not null,
    fevereiro float(10,2) not null,
    marco float(10,2) not null
);

create table relatorio_vendas (
    idfuncionario int,
    total_vendas float(10,2),
    media_vendas float(10,2)
);


-- vou fazer de uma forma que ele chame o insert na primeira tabela e depois faça o insert na segunda tabela, ou seja,
-- a procedure vai ser chamada em todo insert ja pra ir gerando o relatorio automaticamente


DELIMITER $$

CREATE PROCEDURE GERAR_RELATORIO()
BEGIN
    DECLARE v_id INT;
    DECLARE v_jan, v_fev, v_mar FLOAT(10,2);
    DECLARE v_total, v_media FLOAT(10,2);
    DECLARE fim_tabela INT DEFAULT FALSE;
    DECLARE cursor_funcionarios CURSOR FOR 
        SELECT idfuncionario, janeiro, fevereiro, marco FROM funcionarios;
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET fim_tabela = TRUE;

    -- Limpar o relatório antigo antes de gerar um ano, evitar ambiguidade dos dados
    TRUNCATE TABLE relatorio_vendas;
    OPEN cursor_funcionarios;

    loop_leitura: LOOP
        -- O FETCH lê a linha atual e joga os valores nas variáveis correspondentes
        FETCH cursor_funcionarios INTO v_id, v_jan, v_fev, v_mar;

        -- Se o handler avisar que a tabela acabou, saímos do loop
        IF fim_tabela THEN 
            LEAVE loop_leitura;
        END IF;

        -- 5. Fazendo os cálculos idênticos aos da sua trigger
        SET v_total = v_jan + v_fev + v_mar;
        SET v_media = v_total / 3;

        -- 6. Inserindo o resultado da linha atual na tabela de relatórios
        INSERT INTO relatorio_vendas (idfuncionario, total_vendas, media_vendas)
        VALUES (v_id, v_total, v_media);

    END LOOP loop_leitura;

    -- 7. Fechando o cursor após o término do loop
    CLOSE cursor_funcionarios;
    
END$$

DELIMITER ;   

insert into funcionarios (nome, janeiro, fevereiro, marco) values ('Carlos', 2000.00, 2500.00, 3000.00);
insert into funcionarios (nome, janeiro, fevereiro, marco) values ('Carla', 1500.00, 2000.00, 2500.00);
insert into funcionarios (nome, janeiro, fevereiro, marco) values ('Ana', 1000.00, 1500.00, 2000.00);
insert into funcionarios (nome, janeiro, fevereiro, marco) values ('Bruno', 2000.00, 2500.00, 3000.00);

call GERAR_RELATORIO();

select * from relatorio_vendas;