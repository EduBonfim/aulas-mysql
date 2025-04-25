-- Seleciona todos os registros da tabela 'payment'
SELECT * FROM payment;

-- Consulta que retorna o código do cliente, nome do funcionário (staff), valor pago e a comissão
-- A comissão será de 5% se o valor pago for maior ou igual a 3.00, caso contrário, será de 3%
SELECT  payment.customer_id AS Codigo,
        customer.first_name AS Nome,
        staff.first_name AS Gerente,
        payment.amount AS Valor_pago,
        IF(payment.amount >= 3, (payment.amount * 0.05), (payment.amount * 0.03)) AS Comissao
FROM payment
INNER JOIN customer USING(customer_id)
INNER JOIN staff USING(staff_id)
WHERE customer_id = 1;

-- Criação de uma procedure chamada 'lista_comissao'
-- Retorna os mesmos dados da consulta anterior, mas permitindo a busca para qualquer cliente específico
CREATE PROCEDURE lista_comissao(id INT)
BEGIN
    SELECT  payment.customer_id AS Codigo,
            customer.first_name AS Nome,
            staff.first_name AS Gerente2,
            payment.amount AS Valor_pago,
            IF(payment.amount >= 3, (payment.amount * 0.05), (payment.amount * 0.03)) AS Comissao
    FROM payment
    INNER JOIN customer USING(customer_id)
    INNER JOIN staff USING(staff_id)
    WHERE customer_id = id;
END;

-- Chamando a procedure para o cliente com ID 2
CALL lista_comissao(2);

-- Alteração da procedure para que a comissão seja determinada pelo nome do funcionário:
--  - Se o funcionário for "Mike", a comissão será de 5%
--  - Se for "John", a comissão será de 4%
--  - Para outros funcionários, a comissão será de 3%
CREATE PROCEDURE lista_comissao2(id INT)
BEGIN
    SELECT  payment.customer_id AS Codigo,
            customer.first_name AS Nome,
            staff.first_name AS Gerente2,
            payment.amount AS Valor_pago,
            CASE payment.staff_id
                WHEN 1 THEN payment.amount * 0.05  -- Comissão de 5%
                WHEN 2 THEN payment.amount * 0.04  -- Comissão de 4%
                ELSE payment.amount * 0.03         -- Comissão de 3%
            END AS Comissao,
            CASE payment.staff_id
                WHEN 1 THEN '5%'
                WHEN 2 THEN '4%'
                ELSE '3%'
            END AS Percentual
    FROM payment
    INNER JOIN customer USING(customer_id)
    INNER JOIN staff USING(staff_id)
    WHERE customer_id = id;
END;

-- Chamando a nova procedure para o cliente com ID 1
CALL lista_comissao2(1);

-- Removendo a procedure 'lista_comissao2'
DROP PROCEDURE lista_comissao2;

-- Criação de uma procedure para retornar o nome do cliente com seu endereço completo
CREATE PROCEDURE endereco(id INT)
BEGIN
    SELECT
        CONCAT(customer.first_name, ' ', customer.last_name) AS nome_completo,
        address.address AS rua,
        address.district AS Bairro,
        city.city AS cidade,
        country.country AS pais
    FROM customer
    INNER JOIN address USING(address_id)
    INNER JOIN city ON address.city_id = city.city_id
    INNER JOIN country ON city.country_id = country.country_id
    WHERE customer.customer_id = id;
END;

-- Chamando a procedure para obter o endereço do cliente com ID 1
CALL endereco(1);

-- Explicação geral do código:
-- 1. São feitas consultas na tabela 'payment' para obter informações sobre pagamentos e comissões.
-- 2. Criada a procedure 'lista_comissao' para retornar os pagamentos e calcular a comissão com base no valor pago.
-- 3. Criada a procedure 'lista_comissao2', onde a comissão varia conforme o funcionário.
-- 4. Criada a procedure 'endereco' para exibir o nome do cliente junto ao seu endereço completo.
-- 5. Todas as procedures permitem a passagem de um parâmetro 'id' para buscar dados de um cliente específico.
