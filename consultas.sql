-- -----------------------------------------------------
-- Consulta 01: Quantos Autores estão cadastrados?
-- Saida Esperada: Retorna uma tabela com o atributo "qtd_autores" com a quantidade total de autores
-- -----------------------------------------------------
SELECT COUNT(nome) AS qtd_autores FROM autor;

-- -----------------------------------------------------
-- Consulta 02: Qual livro possui o maior número de exemplares?
-- Saida Esperada: Retorna uma tabela com o livro que possui a maior quantidade de exemplares cadastrados e a quantidade do mesmo
-- -----------------------------------------------------
SELECT titulo, numero_de_exemplares
FROM livro
WHERE numero_de_exemplares = (
	SELECT MAX(numero_de_exemplares)
	FROM livro
);


-- -----------------------------------------------------
-- Consulta 03: Qual categoria possui mais livros ?
-- Saida Esperada: Retorna uma tabela com a categoria com o maior número de exemplares
-- -----------------------------------------------------
SELECT categoria, total_livros
FROM (
	SELECT categoria, COUNT(*) AS total_livros
	FROM livro
	GROUP BY categoria
	)t
JOIN (
	SELECT MAX (total_livros) AS MAXIMO
	FROM (
		SELECT categoria, COUNT(*) AS total_livros
		FROM livro
		GROUP BY categoria
		)t
	)m
ON t.total_livros = m.maximo;
-- -----------------------------------------------------
-- Consulta 04: Listar todos os autores que não sejam brasileiros, caso exista.
-- Saida Esperada: Retorna uma tabela com os autores que não são Brasileiros e suas respectivas nacionalidades
-- -----------------------------------------------------
SELECT nome, nacionalidade FROM autor WHERE nacionalidade <> 'Brasileiro';


-- -----------------------------------------------------
-- Consulta 05: Quantos exemplares estão emprestados ?
-- Saida Esperada: Retorna uma tabela com o total de emprestimos emprestados
-- -----------------------------------------------------
SELECT COUNT(*) AS total_emprestados FROM emprestimo;


-- -----------------------------------------------------
-- Consulta 06: Listar todas as Editoras com mais de dois livros, se existir.
-- Saida Esperada: Retorna uma tabela com as editoras que tem mais de dois livros e a respectiva quantidade de livro das mesmas
-- -----------------------------------------------------
SELECT editora.nome, COUNT(*) AS total_livros
FROM editora
NATURAL JOIN livro 
GROUP BY editora.nome
HAVING COUNT(*) > 2;


-- -----------------------------------------------------
-- Consulta 07: Selecionar o nome dos autores que escreveram um livro publicado em um determinado ano
-- Saida Esperada: Retorna uma tabela com ou autores que escreveram livro no ano definido
-- -----------------------------------------------------
SELECT autor.nome
FROM autor
INNER JOIN escreve ON autor.nome = escreve.nome_autor
INNER JOIN livro ON escreve.isbn = livro.isbn
WHERE livro.ano_de_publicacao = '<ano>';


-- -----------------------------------------------------
-- Consulta 08: Selecionar o título e o nome da editora de todos os livros emprestados por um determinado usuário.
-- Saida Esperada: Retorna uma tabela com os livros e as editoras correspondentes que foram emprestados para um determinado usuario
-- -----------------------------------------------------
SELECT livro.titulo, editora.nome
FROM emprestimo
INNER JOIN livro ON emprestimo.isbn = livro.isbn
INNER JOIN editora ON livro.cnpj = editora.cnpj
WHERE emprestimo.ID_usuario = <ID>;


-- -----------------------------------------------------
-- Consulta 09: Liste o titulo do livro e o nome da editora que o publicou, ordenados por ano de publicação em ordem crescente
-- Saida Esperada: Retorna uma tabela com os livros e a editora ordenados por ordem crescente de publicação.
-- -----------------------------------------------------
SELECT livro.titulo, editora.nome
FROM livro
INNER JOIN editora ON livro.cnpj = editora.cnpj
ORDER BY livro.ano_de_publicacao ASC;