-- Exibe todos os registros da tabela 'actor' (atores)
select * from actor;

-- Exibe todos os registros da tabela 'customer' (clientes)
select * from customer;

-- Seleciona informações do cliente, como ID, nome, sobrenome, endereço e bairro,
-- utilizando o 'inner join' entre as tabelas 'customer' e 'address' (relacionamento através do 'address_id')
-- A consulta retorna esses dados ordenados pelo nome do cliente.
select customer.customer_id as codigo,
       customer.first_name as Nome,
       customer.last_name as Sobrenome,
       address.address as endereco,
       address.district as Bairro
from customer
inner join address using(address_id)
order by customer.first_name;

-- Cria uma 'view' chamada 'List_cliente' que exibe os mesmos dados que o select anterior
-- A 'view' é uma consulta armazenada que pode ser chamada como se fosse uma tabela.
create view List_cliente as
        select customer.customer_id as codigo,
               customer.first_name as Nome,
               customer.last_name as Sobrenome,
               address.address as endereco,
               address.district as Bairro
        from customer
        inner join address using(address_id)
        order by customer.first_name;

-- Exibe todos os registros da view 'List_cliente'
select * from list_cliente;

-- Atualiza o nome do cliente com ID 367 para 'ADAM_2'
update customer set first_name = 'ADAM_2' where customer_id = 367;

-- Exibe todos os registros da tabela 'payment' (pagamentos)
select * from payment;

-- Cria uma consulta que retorna o código do cliente, o nome do cliente, o valor pago,
-- a comissão do staff (5% para staff 1 e 3% para staff 2), e o nome do gerente (staff),
-- e ordena os resultados pelo nome do cliente.
select payment.customer_id as 'Codigo_do_cliente',
        customer.first_name as Nome_cliente,
        payment.amount as Valor,
        case payment.staff_id
             when 1 then (payment.amount * 0.05)  -- Comissão de 5% para staff 1
             when 2 then (payment.amount * 0.03)  -- Comissão de 3% para staff 2
             end  as Comissao,
        staff.first_name as Gerente
from payment
inner join customer USING(customer_id)
inner join staff using(staff_id)
ORDER BY customer.first_name;

-- Cria uma 'view' chamada 'comissao_paga' que faz a mesma consulta acima, 
-- armazenando a consulta para fácil acesso no futuro.
create view comissao_paga as
        select payment.customer_id as 'Codigo_do_cliente',
               customer.first_name as Nome_cliente,
               payment.amount as Valor,
               case payment.staff_id
                    when 1 then (payment.amount * 0.05)
                    when 2 then (payment.amount * 0.03)
               end as Comissao,
               staff.first_name as Gerente
        from payment
        INNER join customer USING(customer_id)
        inner join staff using(staff_id)
        ORDER BY customer.first_name;

-- Exibe todos os registros da view 'comissao_paga'
select * from comissao_paga;

-- Atualiza a comissão na tabela 'staff' com base no 'staff_id' (staff 1 com 5%, staff 2 com 3%)
select * from staff;

-- Adiciona uma nova coluna 'comis' à tabela 'staff' para armazenar o valor da comissão.
alter table staff add COLUMN comis decimal(5,2);

-- Atualiza a comissão para o staff 1 (5%)
update staff set comis = 0.05 where staff_id = 1;

-- Atualiza a comissão para o staff 2 (3%)
update staff set comis = 0.03 where staff_id = 2;

-- Exclui a view 'comissao_paga' antiga, para que a nova versão seja criada
drop view comissao_paga;

-- Cria a nova 'view' 'comissao_paga', agora utilizando o valor da comissão diretamente da tabela 'staff'
-- O valor da comissão será calculado com base na coluna 'comis' da tabela 'staff'.
create view comissao_paga as
        select payment.customer_id as 'Codigo_do_cliente',
               customer.first_name as Nome_cliente,
               payment.amount as Valor,
               (payment.amount * staff.comis) as Comissao,  -- Comissionamento com base no staff
               staff.first_name as Gerente
        from payment
        INNER join customer USING(customer_id)
        inner join staff using(staff_id)
        ORDER BY customer.first_name;

-- Exibe todos os registros da nova view 'comissao_paga'
select * from comissao_paga;

-- Exibe a data e hora atual (funciona como um timestamp)
select now();

-- Exibe apenas o número do mês atual
select MONTH(now());

-- Exibe todos os registros da tabela 'rental' (locações)
select * from rental;

-- Atualiza a data da locação para a data e hora atuais para todas as locações com a data '2005-05-24'
update rental set rental_date = now() where date(rental_date) = '2005-05-24';

-- Exibe todos os registros de locações realizadas no mês atual, filtrando pelo mês e ano atuais
select rental_id, customer_id, rental_date from rental 
where (month(rental_date) = month(now())) and (YEAR(rental_date) = YEAR(now()));

-- Explicação geral do código:
-- 1. São feitas consultas para exibição de registros das tabelas 'actor', 'customer', 'payment', 'staff' e 'rental'.
-- 2. A consulta principal exibe os dados dos clientes, seus endereços e organiza os resultados em uma 'view' chamada 'List_cliente'.
-- 3. Criação da 'view' 'comissao_paga', que calcula a comissão dos funcionários com base no valor pago por clientes.
-- 4. Adição de uma coluna de comissão na tabela 'staff' e atualização dos valores correspondentes para cada funcionário.
-- 5. Atualização da view 'comissao_paga' para utilizar a nova coluna de comissão em seus cálculos.
-- 6. Uso da função NOW() para recuperar a data e hora atual, além de filtragem de locações com base no mês e ano atual.
-- 7. Atualização de datas de locações antigas para a data atual.
