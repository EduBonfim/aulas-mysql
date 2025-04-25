
CREATE USER 'duzinhoww'@'localhost' IDENTIFIED BY 'duzinhoww';

GRANT ALL PRIVILEGES ON * . * TO 'duzinhoww'@'localhost'; /* Privileges on *.* ( primeiro * significa todos os servidores, exemplo sakila.* ) */

FLUSH PRIVILEGES;