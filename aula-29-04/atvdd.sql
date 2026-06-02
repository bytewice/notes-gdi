CREATE TABLE autores (
    id_autor INT PRIMARY KEY,
    nome VARCHAR(100) unique not null
);

CREATE TABLE livros (
    id_livro INT PRIMARY KEY,
    titulo VARCHAR(100),
    
    id_autor INT,
    FOREIGN KEY (id_autor) REFERENCES autores(id_autor)
);

INSERT INTO autores VALUES (1, 'Machado de Assis');
INSERT INTO autores VALUES (2, 'Clarice Lispector');
insert into autores VALUES (3, 'Jorge Amado');
insert into autores VALUES (4, 'Graciliano Ramos');
insert INTO autores VALUES (5, 'Carlos Drummond de Andrade');

INSERT INTO livros VALUES (1, 'Dom Casmurro', 1);
INSERT INTO livros VALUES (2, 'A Hora da Estrela', 2);
insert into livros values (6, 'Água viva', 2);
insert into livros VALUES (3, 'Capitães da Areia', 3);
insert into livros VALUES (4, 'Vidas Secas', 4);
insert into livros VALUES (5, 'Alguma Poesia', 5);

CREATE VIEW view_livros_autores AS
SELECT 
    l.id_livro,
    l.titulo,
    a.nome AS autor
FROM livros l
JOIN autores a ON l.id_autor = a.id_autor;

CREATE VIEW view_livros_simples AS
SELECT id_livro, titulo, id_autor
FROM livros;

INSERT INTO view_livros_simples VALUES (7, 'Memórias Póstumas', 1);
select * from view_livros_simples;
select * from livros;

CREATE VIEW view_livros_ordenados AS
SELECT 
    l.titulo,
    a.nome AS autor
FROM livros l
JOIN autores a ON l.id_autor = a.id_autor
ORDER BY a.nome;

select * from view_livros_ordenados;