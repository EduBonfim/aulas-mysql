-- 1) Desenvolva uma função para calcular o desconto do cliente nos pagamentos
-- realizados. Desconto de 5 % para pagamentos acima de 5,00 dolares, 3 % para
-- pagamentos acima de 2,00, e 2% para menores que 2,00.

CREATE FUNCTION calcular_desconto(valor DECIMAL(10, 2))
RETURNS DECIMAL(10, 2)
DETERMINISTIC
BEGIN
    DECLARE desconto DECIMAL(10, 2);
    IF valor > 5.00 THEN
        SET desconto = valor * 0.05;
    ELSEIF valor > 2.00 THEN
        SET desconto = valor * 0.03;
    ELSE
        SET desconto = valor * 0.02;
    END IF;
    RETURN desconto;
end;

select customer_id,amount, calcular_desconto(amount) from payment;

-- 2) Desenvolva uma procedure para listar os descontos obtidos por um
-- determinando cliente.

CREATE PROCEDURE prc_desconto_cliente(customer_id INT)
BEGIN
    SELECT customer_id, amount, calcular_desconto(amount) AS desconto
    FROM payment
    WHERE customer_id = customer_id;
END;

call prc_desconto_cliente(1);

-- 3) Faça uma procedure para gerar, o total de descontos que cada cliente conseguiu

CREATE PROCEDURE prc_total_desconto_cliente()
BEGIN
    SELECT customer_id, SUM(calcular_desconto(amount)) AS total_desconto
    FROM payment
    GROUP BY customer_id;
END;

call prc_total_desconto_cliente();

CREATE PROCEDURE prc_total_desconto_cliente()
BEGIN
    SELECT customer.customer_id AS 'Codigo',
           CONCAT(customer.first_name, ' ', last_name) AS 'Nome Completo',
           SUM(calcular_desconto(payment.amount)) AS 'Total Desconto'
    FROM payment
    JOIN customer USING(customer_id)
    GROUP BY customer_id;
END;

CREATE PROCEDURE prc_total_desconto_cliente()
BEGIN
    SELECT customer.customer_id AS 'Codigo',
           CONCAT(customer.first_name, ' ', last_name) AS 'Nome Completo',
           SUM(calcular_desconto(payment.amount)) AS 'Total Desconto'
    FROM payment
    INNER JOIN customer ON payment.customer_id = customer.customer_id
    GROUP BY customer.customer_id;
END;

drop PROCEDURE prc_total_desconto_cliente;
call prc_total_desconto_cliente();

-- 4) Faça uma procedure para gerar em cada locação de cliente o valor  da locação
-- mais os impostos para cada locação, sendo 8,5 de taxa em cima de cada valor
-- mostrando o nome do cliente, filme locado, valor da locação, valor do imposto
-- e custo total da locação

create PROCEDURE calcular_impostos(id int)
BEGIN
    select p.payment_id as 'Código', CONCAT(c.first_name, ' ', c.last_name) as 'Cliente', f.title as 'Filme', p.amount as 'Preço',
    (p.amount * 0.085) as 'Imposto', (p.amount + (p.amount * 0.085)) as 'Valor Total'
    from payment as p
    inner join customer as c USING (customer_id)
    inner join rental using (rental_id)
    inner join inventory using (inventory_id)
    inner join film as f using (film_id)
    where p.customer_id = id;
END

call calcular_impostos(1);

-- Explicações:

/*
1) Função calcular_desconto:
   - A função "calcular_desconto" calcula o desconto com base no valor da compra.
   - Desconto de 5% para valores acima de 5,00; 3% para valores acima de 2,00; e 2% para valores menores que 2,00.
   - Ela recebe um valor como entrada, calcula o desconto e o retorna.

2) Procedure prc_desconto_cliente:
   - Esta procedure recebe um "customer_id" como parâmetro e retorna os pagamentos feitos por este cliente com o respectivo desconto.
   - Utiliza a função "calcular_desconto" para calcular o desconto de cada pagamento.

3) Procedure prc_total_desconto_cliente:
   - Esta procedure gera o total de descontos de todos os clientes, somando os descontos de seus pagamentos.
   - A primeira versão soma os descontos por "customer_id".
   - A segunda versão inclui o nome completo do cliente, utilizando um "JOIN" com a tabela "customer" para concatenar o "first_name" e "last_name".
   - A terceira versão faz a mesma coisa, mas com o uso do "INNER JOIN" para juntar as tabelas "payment" e "customer".

4) Procedure calcular_impostos:
   - Esta procedure calcula o valor de cada locação (preço), o imposto (8,5% sobre o valor) e o valor total da locação (preço + imposto).
   - Ela exibe o código do pagamento, o nome do cliente, o título do filme, o valor da locação, o valor do imposto e o valor total da locação.
   - A procedure utiliza múltiplos "JOINs" para relacionar as tabelas "payment", "customer", "rental", "inventory" e "film".
*/
