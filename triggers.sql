-- -----------------------------------------------------
-- TRIGGER 1: ATUALIZAR NÚMERO DE EXEMPLARES
-- -----------------------------------------------------
-- -----------------------------------------------------
/* A função a seguir vai verificar se ouve uma inserção ou remoção de linha e em conjunto com a trigger vai garantir que:
Caso tenha tido alguma remocao da uma linha na tabela exempares, significa que um exemplar deixou de exitir, 
nesse caso o campo de quantidade de exemplares no livro ira diminuir. Caaso o contrário, se foi inserido uma linha, 
significa que um novo exemplar foi cadastrado, sendo assim a quantidade de exemplares desse livro irá aumentar*/
-- -----------------------------------------------------
-- -----------------------------------------------------
-- Função
-- -----------------------------------------------------
CREATE OR REPLACE FUNCTION atualizar_numero_exemplares() 
RETURNS TRIGGER AS $$ 
BEGIN
    IF TG_OP = 'INSERT' THEN
        UPDATE livro SET numero_de_exemplares = numero_de_exemplares + 1 WHERE isbn = NEW.isbn;
    ELSIF TG_OP = 'DELETE' THEN
        UPDATE livro SET numero_de_exemplares = numero_de_exemplares - 1 WHERE isbn = OLD.isbn;
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- -----------------------------------------------------
-- Trigger
-- -----------------------------------------------------
CREATE TRIGGER atualizar_numero_exemplares 
AFTER INSERT OR DELETE ON exemplar
FOR EACH ROW 
EXECUTE FUNCTION atualizar_numero_exemplares();


-- -----------------------------------------------------
-- TRIGGER 2: VERIFICAR SE O EMPRÉSTIMO É POSSIVEL
-- -----------------------------------------------------
-- -----------------------------------------------------
/* A função a seguir em conjunto com o trigger vai impedir que o mesmo exemplar ja emprestado seja emprestado novamente.
A chave primária da relação emprestimo é formado pelo ID do usuário, o código e o isbn do exemplar, pois exemplar é uma entidade fraca.
Com isso, caso o ID usuario seja diferente, mas o isbn e o codigo do exemplar inicialmente sejam o mesmo de um livro ja inserido antes, 
esse novo emprestimo irá acontecer da mesma forma. Para impedir que isso aconteça, sempre antes de realizar um novo emprestimo, 
é verificado se o exemplar com mesmo isbn e mesmo código já não foi emprestado anteriomente para outro usuário, caso já tenha sido emprestado
será lançada uma exceção*/
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Função
-- -----------------------------------------------------
CREATE OR REPLACE FUNCTION verificar_emprestimo() RETURNS TRIGGER AS $$
DECLARE
    quantidade_emprestada INTEGER;
    quantidade_disponivel INTEGER;
BEGIN
	IF EXISTS(SELECT 1 FROM emprestimo) THEN
		IF EXISTS(SELECT 1 FROM emprestimo WHERE isbn = NEW.isbn AND codigo_exemplar = NEW.codigo_exemplar) THEN
			RAISE EXCEPTION 'Não é possível realizar o empréstimo. O exemplar já está emprestado.';
		END IF;
	END IF;
	RETURN NEW;
END;
$$ LANGUAGE plpgsql;


-- -----------------------------------------------------
-- Trigger
-- -----------------------------------------------------
CREATE TRIGGER emprestimo_trigger 
BEFORE INSERT ON emprestimo 
FOR EACH ROW 
EXECUTE FUNCTION verificar_emprestimo();

