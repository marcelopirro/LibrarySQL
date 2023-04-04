CREATE DATABASE biblioteca
-- -----------------------------------------------------
-- Criando tipo enum para atender as restrições estabelecidas no minimundo.
-- -----------------------------------------------------
-- Criação do type GENERO contendo as opção definidas anteriomente pela tabela 3:
CREATE TYPE GENERO AS ENUM ('Masculino', 'Feminino', 'Outro(a)');

-- Criação do type ESTADO_CIVIL contendo as opções definidas anteriormente pela tabela 2:
CREATE TYPE ESTADO_CIVIL AS ENUM ('Solteiro(a)', 'Casado(a)', 'Divorciado(a)', 'Viúvo(a)', 'Separado(a)');

-- Criação do type CATEGORIA contendo as opções definidas anteriormente pela tabela 5:
CREATE TYPE CATEGORIA AS ENUM ('Ciência', 'Esportes', 'Biografia', 'História', 'Ficção científica', 'Romance', 'Suspense', 'Fantasia', 'Infantil', 'Drama', 'Poesia', 'Religião', 'Ação e Aventura', 'Outro');

-- Criação do type NACIONALIDADE contendo as opções definidas anteriormente pela tabela 6:
CREATE TYPE NACIONALIDADE AS ENUM ('Brasileiro', 'Estadunidense', 'Canadense', 'Alemão', 'Francês', 'Português', 'Espanhol', 'Outro(a)');

-- Criação do type IDIOMA contendo as opções definidas anteriormente pela tabela 4:
CREATE TYPE IDIOMA AS ENUM ('Português', 'Inglês', 'Espanhol', 'Outro');


-- -----------------------------------------------------
-- domínio chamado "telefone" adiciona uma restrição CHECK que garante que o valor do telefone seja um padrão de número de telefone válido do Brasil seguindo os formatos (XX)XXXX-XXXX ou (XX)XXXXX-XXXX, sendo X um dígito de 0 a 9
-- -----------------------------------------------------
CREATE DOMAIN TELEFONE AS text
    CONSTRAINT telefone_valido CHECK(
        VALUE ~ '^\([0-9]{2}\)[0-9]{5}-[0-9]{4}$' OR VALUE ~ '^\([0-9]{2}\)[0-9]{4}-[0-9]{4}$'
    );
	
-- -----------------------------------------------------
-- o domínio "CEP" foi criado como um caractere (CHAR) com tamanho 8, o que é suficiente para armazenar um CEP no formato brasileiro, respeitando o minimundo, apenas dígitos podem ser inseridos.
-- -----------------------------------------------------	
CREATE DOMAIN CEP AS char(8)
    CONSTRAINT cep_valido CHECK(
        VALUE ~ '^[0-9]{8}$'
    );
	
-- -----------------------------------------------------
-- domínio "CPF" foi definido como um campo de 11 caracteres (char(11)), e foi adicionado uma restrição de validação para aceitar apenas valores numéricos com 11 dígitos. 
-- -----------------------------------------------------	
CREATE DOMAIN CPF AS char(11)
    CONSTRAINT cpf_valido CHECK(
        VALUE ~ '^[0-9]{11}$'
    );
	
-- -----------------------------------------------------
-- domínio chamado ISBN que pode ser usado em tabelas para armazenar ISBNs de livros e outras publicações. A restrição CHECK garante o isbn seja composto com 13 dígitos. 
-- -----------------------------------------------------	
CREATE DOMAIN ISBN AS char(13)
	CONSTRAINT isbn_valido CHECK (
		VALUE ~ '^[0-9]{13}$'
	);

-- -----------------------------------------------------
-- o domínio CNPJ é criado com o tipo char(14) para armazenar CNPJs. O Check é usado para garantir que apenas dígitos sejam inseridos, e que o CNPJ seja composto por 14 dígitos.
-- -----------------------------------------------------
CREATE DOMAIN CNPJ AS char(14)
	CONSTRAINT cnpj_valido
	CHECK (VALUE ~ '^[0-9]{14}$');
	
-- -----------------------------------------------------
-- o domínio ANO é usado para garantir que o ano siga a padrão de 4 dígitos.
-- -----------------------------------------------------
CREATE DOMAIN ANO AS char(4)
	CONSTRAINT ano_valido CHECK (
		VALUE ~ '[0-9]{4}$'
	);
	
-- -----------------------------------------------------
-- Table usuario. Criação da tabela do usuário
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS usuario (
	ID INT NOT NULL,
	CPF CPF NOT NULL UNIQUE, --CPF deve ser unico e seguir o padrao definido pelo domínio CPF
	nome VARCHAR(100) NOT NULL,
	idade INT NOT NULL CHECK (idade > 16), --Verifica se a idade é maior de 16 anos
	estado_civil ESTADO_CIVIL NOT NULL,
	genero GENERO NOT NULL, --Genero deve seguir o padrão definido pelo tipo GENERO, só podem ser inseridas opções previamente definidas
	logradouro VARCHAR(45) NOT NULL,
	rua VARCHAR(100) NOT NULL,
	numero INT NOT NULL,
	bairro VARCHAR(100) NOT NULL,
	CEP CEP NOT NULL, --CEP deve seguir o padrao definido pelo domínio CEP
	telefone_1 TELEFONE NOT NULL,
	telefone_2 TELEFONE NOT NULL,
	PRIMARY KEY (ID)
);

-- -----------------------------------------------------
-- Table funcionario. Criação da tabela funcionário
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS funcionario (
  	ID INT NOT NULL,
	nome VARCHAR(100) NOT NULL,
  	cpf CPF  UNIQUE NOT NULL, --CPF deve ser unico e seguir o padrão definido pelo domínio CPF
  	genero GENERO NOT NULL, --Genero deve seguir o padrão definido pelo tipo GENERO, só podem ser inseridas opções previamente definidas
  	idade INT NOT NULL CHECK (idade > 18), --verifica se a idade do funcionário é maior que 18 anos
	telefone_1 TELEFONE NOT NULL, --O telefone deve seguir um dos padrões definidos pele domínio TELEFONE
	telefone_2 TELEFONE NOT NULL, --O telefone deve seguir um dos padrões definidos pele domínio TELEFONE
	PRIMARY KEY (ID)
);

-- -----------------------------------------------------
-- Table editora. Criação da tabela Editora
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS editora (
  	cnpj CNPJ NOT NULL, --cnpj deve ser unico e seguir o padrão definido pelo domínio CNPJ
  	nome VARCHAR(100) NOT NULL,
  	telefone TELEFONE, -- opcional --O telefone deve seguir um dos padrões definidos pele domínio TELEFONE
  	logradouro VARCHAR(45) NOT NULL,
	rua VARCHAR(100) NOT NULL,
	numero INT NOT NULL,
	bairro VARCHAR(100) NOT NULL,
	cep CEP NOT NULL, --cep deve ser unico e seguir o padrão definido pelo domínio CEP
	PRIMARY KEY (cnpj)
);


-- -----------------------------------------------------
-- Table livro. Criação da tabela livro
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS livro (
  	isbn ISBN NOT NULL, --isbn deve ser unico e seguir o padrão definido pelo domínio ISBN
  	titulo VARCHAR(100) NOT NULL,
  	ano_de_publicacao ANO NOT NULL, --ano_de_publicacao deve ser unico e seguir o padrão de 4 dígitos definido pelo domínio ANO
  	numero_de_exemplares INT NOT NULL DEFAULT 0, --número_de_exemplares é calculado por trigger, logo não precisa ser inserido. O Default é dado como 0.
	categoria CATEGORIA NOT NULL, --Categoria deve seguir o padrão definido pelo tipo CATEGORIA, só podem ser inseridas opções previamente definidas
	numero_de_paginas INT NOT NULL CHECK (numero_de_paginas >= 1),
	idioma IDIOMA NOT NULL, --Idioma deve seguir o padrão definido pelo tipo IDIOMA, só podem ser inseridas opções previamente definidas
	cnpj CNPJ NOT NULL, --cnpj deve ser unico e seguir o padrão definido pelo domínio CNPJ
	PRIMARY KEY (isbn),
	FOREIGN KEY (cnpj) REFERENCES editora(cnpj)
		ON UPDATE CASCADE
		ON DELETE CASCADE
);


-- -----------------------------------------------------
-- Table autor. Criação da tabela de autor.
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS autor (
  	nome VARCHAR(100) NOT NULL,
  	nacionalidade NACIONALIDADE NOT NULL, --Nacionalidade deve seguir o padrão definido pelo tipo NACIONALIDADE, só podem ser inseridas opções previamente definidas
	PRIMARY KEY (nome)
);

-- -----------------------------------------------------
-- Table exemplar. Criação da tabela de exemplar
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS exemplar (
	codigo INT NOT NULL, 
  	isbn ISBN NOT NULL, --isbn deve ser unico e seguir o padrão definido pelo domínio ISBN
  	nivel_de_conservacao int NOT NULL CHECK (nivel_de_conservacao >= 0 AND nivel_de_conservacao <= 5), --verifica se o nível de conservação está dentro do intervalo estipulado
	FOREIGN KEY (isbn) REFERENCES livro(isbn)
		ON UPDATE CASCADE
		ON DELETE CASCADE,
	PRIMARY KEY (codigo, isbn)
);

-- -----------------------------------------------------
-- Table escreve. Criação da tabela que representa o relacionamento escreve
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS escreve (
  	nome_autor VARCHAR(100) NOT NULL,
  	isbn ISBN NOT NULL, --isbn deve ser unico e seguir o padrão definido pelo domínio ISBN
	FOREIGN KEY (nome_autor) REFERENCES autor(nome)
		ON UPDATE CASCADE
		ON DELETE CASCADE,
	FOREIGN KEY (isbn) REFERENCES livro(isbn)
		ON UPDATE CASCADE
		ON DELETE CASCADE,
	PRIMARY KEY (nome_autor, isbn)
);

-- -----------------------------------------------------
-- Table emprestimo. Criação da tabela que representa o relacionamento ternário Empréstimo.
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS emprestimo (
	ID_usuario INT NOT NULL,
  	isbn ISBN NOT NULL, --isbn deve ser unico e seguir o padrão definido pelo domínio ISBN
	codigo_exemplar INT NOT NULL,
	ID_funcionario INT NOT NULL, 
  	data_retirada DATE NOT NULL, --data de retirada do exemplar
	data_devolucao DATE NOT NULL,  --data prevista de devolução do exemplar
	FOREIGN KEY (ID_usuario) REFERENCES usuario(ID)
		ON UPDATE CASCADE
		ON DELETE CASCADE,
	FOREIGN KEY (ID_funcionario) REFERENCES funcionario(ID)
		ON UPDATE CASCADE
		ON DELETE CASCADE,
	FOREIGN KEY (codigo_exemplar, isbn) REFERENCES exemplar(codigo, isbn)
		ON UPDATE CASCADE
		ON DELETE CASCADE,
	PRIMARY KEY (ID_usuario, isbn, codigo_exemplar)
);