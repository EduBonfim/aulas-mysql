-- Seleciona todos os registros da tabela `customer`
SELECT * FROM customer;

-- Cria uma tabela `aud_customer` como cópia da `customer` para fins de auditoria
CREATE TABLE aud_customer AS SELECT * FROM customer;

-- Limpa todos os registros da tabela `aud_customer`
TRUNCATE TABLE aud_customer;

-- Seleciona todos os registros da tabela `aud_customer`
SELECT * FROM aud_customer;

-- Mostra a estrutura da tabela `aud_customer`
DESCRIBE aud_customer;

-- Adiciona uma nova coluna `usuario` na tabela `aud_customer`
ALTER TABLE aud_customer ADD COLUMN usuario VARCHAR(30);

-- Exibe as triggers existentes
SHOW TRIGGERS;

-- Cria uma trigger para inserir ocorrências de auditoria na tabela `aud_customer` após qualquer atualização na tabela `customer`
CREATE TRIGGER ocorrencia_customer
AFTER UPDATE ON customer
FOR EACH ROW
BEGIN
    INSERT INTO aud_customer VALUES (
        OLD.customer_id,
        OLD.store_id,
        OLD.first_name,
        OLD.last_name,
        OLD.email,
        OLD.address_id,
        OLD.active,
        OLD.create_date,
        NOW(),
        'Romulo'
    );
END;

-- Verificar os registros atualizados nas tabelas `customer` e `aud_customer`
SELECT * FROM customer;
SELECT * FROM aud_customer;

-- Exemplo de atualização para ativar a trigger
UPDATE customer SET first_name = 'Mary Silva' WHERE customer_id = 1;

-- Criação da tabela `produto`
CREATE TABLE produto (
    codprod INT PRIMARY KEY,
    descricao VARCHAR(50),
    preco DECIMAL(9,2),
    qtd INT
);

-- Inserção de um produto na tabela `produto`
INSERT INTO produto VALUES (1, 'Lapis', 3, 56);

-- Seleção dos registros da tabela `produto`
SELECT * FROM produto;

-- Criação da tabela `aud_venda` para auditoria de vendas
CREATE TABLE aud_venda (
    codvenda INT PRIMARY KEY,
    cliente VARCHAR(50),
    codprod INT,
    qtd INT
);

-- Exclusão da tabela `venda` caso já exista
DROP TABLE IF EXISTS venda;

-- Criação da trigger `ocorrencia_venda` para dar baixa no estoque após uma venda
CREATE TRIGGER ocorrencia_venda
AFTER INSERT ON venda
FOR EACH ROW
BEGIN
    INSERT INTO aud_venda (codprod, codvenda, cliente, qtd, data, usuario)
    VALUES (NEW.codprod, NEW.codvenda, NEW.cliente, NEW.qtd, NOW(), 'Romulo');

    UPDATE produto
    SET qtd = qtd - NEW.qtd
    WHERE codprod = NEW.codprod AND qtd >= NEW.qtd;
END;

-- Criação da trigger `ocorrencia_estorno` para restituir o estoque após um estorno de venda
CREATE TRIGGER ocorrencia_estorno
AFTER DELETE ON venda
FOR EACH ROW
BEGIN
    INSERT INTO aud_venda (codprod, codvenda, cliente, qtd, data, usuario)
    VALUES (OLD.codprod, OLD.codvenda, OLD.cliente, OLD.qtd, NOW(), 'Romulo');

    UPDATE produto
    SET qtd = qtd + OLD.qtd
    WHERE codprod = OLD.codprod;
END;

-- Visualizar as triggers criadas
SHOW TRIGGERS;

-- Inserir um novo produto na tabela `produto`
INSERT INTO produto (codprod, descricao, preco, qtd)
VALUES (2, 'Produto ', 20.00, 100);

-- Inserir uma nova venda na tabela `venda`
INSERT INTO venda (codprod, codvenda, cliente, qtd)
VALUES (1, 5001, 'Cliente Teste', 5);

-- Verificar os registros na tabela `produto` após a venda
SELECT * FROM produto WHERE codprod = 1;

-- Visualizar os registros na tabela de auditoria `aud_venda`
SELECT * FROM aud_venda;