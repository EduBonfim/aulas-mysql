-- Seleciona todos os registros da tabela 'actor'
SELECT * FROM actor;

-- Criação de uma função para obter o nome completo de um ator pelo ID
CREATE FUNCTION nome_ator (id INT)
RETURNS VARCHAR(60)
DETERMINISTIC
BEGIN
    -- Declaração de uma variável para armazenar o nome completo
    DECLARE nome_completo VARCHAR(60);
    
    -- Consulta que concatena o primeiro e o último nome do ator
    SELECT CONCAT(first_name, ' ', last_name) INTO nome_completo 
    FROM actor 
    WHERE actor_id = id;
    
    -- Retorna o nome completo
    RETURN nome_completo;
END;

-- Testa a função passando um ID específico
SELECT nome_ator(2);

-- Aplica a função a todos os registros da tabela 'actor'
SELECT nome_ator(actor_id) FROM actor;

-- Remove a função criada
DROP FUNCTION nome_ator;

-- Seleciona todos os registros da tabela 'payment'
SELECT * FROM payment;

-- Seleciona todos os registros da tabela 'staff'
SELECT * FROM staff;

-- Criação de uma função para obter o nome completo de um funcionário pelo ID
CREATE FUNCTION Pagamento (id INT)
RETURNS VARCHAR(60)
DETERMINISTIC
BEGIN
    -- Declaração de variável para armazenar o nome completo do funcionário
    DECLARE dadosCliente VARCHAR(60);
    
    -- Consulta que concatena o primeiro e o último nome do funcionário
    SELECT CONCAT(first_name, ' ', last_name) INTO dadosCliente 
    FROM staff 
    WHERE staff_id = id;
    
    -- Retorna o nome completo
    RETURN dadosCliente;
END;

-- Consulta que retorna o nome do cliente, o nome do funcionário e o total pago por um cliente específico
SELECT customer.first_name, staff.first_name, SUM(payment.amount) 
FROM payment
INNER JOIN customer USING(customer_id)
INNER JOIN staff USING(staff_id)
WHERE payment.customer_id = 1;

-- Criação de uma função para calcular o total pago por um cliente e a comissão do funcionário
CREATE FUNCTION total_pago(id INT)
RETURNS VARCHAR(100)
DETERMINISTIC
BEGIN
    -- Declaração de variável para armazenar a mensagem de retorno
    DECLARE mensagem VARCHAR(100);
    
    -- Consulta que gera uma mensagem contendo o nome do cliente, o nome do funcionário, o total pago e a comissão
    SELECT CONCAT(
        'Cliente = ', customer.first_name, 
        ' Staff = ', staff.first_name, 
        ' Total = ', SUM(payment.amount),
        ' Comissão = ',
        CASE staff.staff_id
            WHEN 1 THEN SUM(payment.amount) * 0.05
            WHEN 2 THEN SUM(payment.amount) * 0.03
        END
    ) INTO mensagem
    FROM payment
    INNER JOIN customer USING(customer_id)
    INNER JOIN staff USING(staff_id)
    WHERE payment.customer_id = id;
    
    -- Retorna a mensagem formatada
    RETURN mensagem;
END;

-- Remove a função criada
DROP FUNCTION total_pago;

-- Tentativa de execução da função sem passar um parâmetro (o que provavelmente causará erro)
SELECT total_pago;

-- Explicação do código:

-- 1. Consulta inicial: Lista todos os registros da tabela 'actor'.
-- 2. Criação da função 'nome_ator': Retorna o nome completo de um ator com base no 'actor_id'.
-- 3. Testes da função: A função 'nome_ator' é chamada para um ID específico e depois aplicada a todos os registros.
-- 4. Exclusão da função 'nome_ator' para limpeza do banco.
-- 5. Consultas às tabelas 'payment' e 'staff' para análise dos dados.
-- 6. Criação da função 'Pagamento': Retorna o nome completo de um funcionário pelo 'staff_id'.
-- 7. Consulta de pagamentos: Retorna o nome do cliente, o nome do funcionário e o total pago pelo cliente com 'customer_id' = 1.
-- 8. Criação da função 'total_pago': Retorna uma mensagem contendo o nome do cliente, o nome do funcionário, o total pago e a comissão.
--    - A comissão varia: 5% para 'staff_id' = 1 e 3% para 'staff_id' = 2.
-- 9. Exclusão da função 'total_pago' para evitar conflitos no banco.
-- 10. Tentativa de execução da função sem argumento: Causa erro, pois 'total_pago' exige um ID como parâmetro.

