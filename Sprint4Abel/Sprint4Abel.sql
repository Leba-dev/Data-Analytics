-- Creación de SCHEMA

CREATE DATABASE economy;

-- Crea tabla Users
CREATE TABLE users ( 
id VARCHAR(255) NOT NULL PRIMARY KEY,
name VARCHAR(50) ,
surname VARCHAR(50),
phone VARCHAR(50) ,
email VARCHAR(255) ,
birth_date VARCHAR(50) ,
country VARCHAR(50) ,
city VARCHAR(50) ,
post_code VARCHAR(20),
address VARCHAR(255)
);

-- DESCRIBE users;
-- SELECT * FROM users;
-- DROP TABLE users;

-- Crea tabla credit_cards
CREATE TABLE credit_cards ( 
id VARCHAR(255) NOT NULL PRIMARY KEY,
user_id VARCHAR(255),
iban VARCHAR(255),
pan VARCHAR(255),
pin VARCHAR(255),
cvv VARCHAR(50) ,
track1 VARCHAR(255) ,
track2 VARCHAR(255) ,
expiring_date VARCHAR(50) 
);

-- DESCRIBE credit_cards;
-- SELECT * FROM credit_cards;
-- DROP TABLE credit_cards;

--  Crea tabla companies
CREATE TABLE companies (
company_id VARCHAR(255) NOT NULL PRIMARY KEY,
company_name VARCHAR(255) ,
phone VARCHAR(15) ,
email VARCHAR(100) ,
country VARCHAR(100) ,
website VARCHAR(255) 
);

-- DESCRIBE companies;
-- SELECT * FROM companies;
-- DROP TABLE companies;

-- Crea tabla productos
CREATE  TABLE products (
id  VARCHAR(255) NOT NULL PRIMARY KEY,
product_name VARCHAR(255) ,
price VARCHAR(20) ,
colour VARCHAR(255) ,
weight VARCHAR(255) ,
warehouse_id VARCHAR(255) 
);

DROP TABLE products;
/* Al final decidi desecharla, porque crearia una relación n->m 
Otra posible solucion es crear una tabla intermedia en trasaction - product
Pero esta labor no es necesaria hasta el nivel III. */



-- tabla transactions

CREATE TABLE transactions (
id VARCHAR(255) NOT NULL PRIMARY KEY,
card_id VARCHAR(255),
business_id VARCHAR(255) ,
timestamp VARCHAR(20) ,
amount VARCHAR (20) ,
declined VARCHAR(1) ,
product_ids VARCHAR(255),
user_id VARCHAR(255) ,
lat VARCHAR(255) ,
longitude VARCHAR(255) 
);
-- DESCRIBE transactions;
-- SELECT * FROM transactions;
-- DROP TABLE transactions;


-- Directorio para importar datos
SHOW VARIABLES LIKE 'secure_file_priv';


-- Importar tablas .csv

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/companies.csv'
INTO TABLE companies
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES;

SELECT * FROM companies;

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/credit_cards.csv'
INTO TABLE credit_cards
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES;

SELECT	* FROM credit_cards;

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/transactions.csv'
INTO TABLE transactions
FIELDS TERMINATED BY ';'
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES; 

SELECT * FROM transactions;

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/users_usa.csv'
INTO TABLE users
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED by '\r\n'
IGNORE 1 ROWS;

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/users_uk.csv'
INTO TABLE users
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED by '\r\n'
IGNORE 1 ROWS;

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/users_ca.csv'
INTO TABLE users
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED by '\r\n'
IGNORE 1 ROWS;

SELECT * FROM users;

-- Combinación de tablas

ALTER TABLE transactions
  ADD CONSTRAINT fk_transactions_card
  FOREIGN KEY (card_id) REFERENCES credit_cards(id);

ALTER TABLE transactions
  ADD CONSTRAINT fk_transactions_company
  FOREIGN KEY (business_id) REFERENCES companies(company_id);

ALTER TABLE transactions
  ADD CONSTRAINT fk_transactions_user
  FOREIGN KEY (user_id) REFERENCES users(id);


-- Índice para la tabla companies
CREATE INDEX index_a_companies_id ON companies(company_id);

-- Índice para la tabla users
CREATE INDEX index_a_users_id ON users(id);

-- Índice para la tabla credit_cards
CREATE INDEX index_a_credit_cards_id ON credit_cards(id);





-- Ej1
-- Version join, para tener una idea del resultado final.
/*SELECT u.id, u.name, u.surname ,COUNT(t.id) AS transactions_count
FROM users u
JOIN transactions t 
ON u.id = t.user_id
GROUP BY u.id,, u.name, u.surname
HAVING COUNT(t.id) > 30
ORDER BY transactions_count DESC;*/





-- Vs subsqwery

/* Esta queda descartada por revision de pares , la(,) en el from es un join.
SELECT u.id, u.name, u.surname, tsc.transactions_count
FROM users u,
     (SELECT user_id, COUNT(id) AS transactions_count
      FROM transactions
      GROUP BY user_id) tsc
WHERE u.id = tsc.user_id
  AND tsc.transactions_count > 30
ORDER BY tsc.transactions_count DESC;*/

-- Version Subqwery 
SELECT u.id, u.name, u.surname,
       (SELECT COUNT(ts.id)
        FROM transactions ts
        WHERE ts.user_id = u.id) AS transactions_count
FROM users u
WHERE (SELECT COUNT(ts.id)
        FROM transactions ts
        WHERE ts.user_id = u.id) > 30
ORDER BY transactions_count DESC;




-- Ej 2

SELECT cc.iban, c.company_name, ROUND(AVG(t.amount), 2) AS media				
FROM credit_cards cc				
JOIN transactions t 
ON cc.id = t.card_id				
JOIN companies c 
ON t.business_id = c.company_id				
WHERE c.company_name = 'Donec Ltd'				
GROUP BY cc.iban, c.company_name;	

/* 
Solo muestra dos resultados, si dejara los declined 1 fuera,
no tendria mucho sentido, para hacer una media de un solo resultado.
SELECT cc.iban, c.company_name, t.declined, t.amount				
FROM credit_cards cc				
JOIN transactions t 
ON cc.id = t.card_id				
JOIN companies c 
ON t.business_id = c.company_id				
WHERE c.company_name = 'Donec Ltd'				
*/ 		

-- Nivel 3
/*Crea una taula amb la qual puguem unir les dades del nou arxiu products.csv amb la base de dades creada,
 tenint en compte que des de transaction tens product_ids. Genera la següent consulta:
Exercici 1
Necessitem conèixer el nombre de vegades que s'ha venut cada producte. */

CREATE  TABLE products (
id varchar(20) primary key,
product_name varchar(100),
price varchar(30),
colour varchar(20),
weight varchar(10),
warehouse_id varchar(20)
); 

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/products.csv'
INTO TABLE products
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES;

SELECT * FROM products;

-- Creacion de tabla , con pk y relacion con otras tablas.
create table trans_products (
id_transaction varchar(50) NOT NULL,
id_product varchar(20) NOT NULL,
primary key (id_transaction, id_product),
foreign key (id_transaction) references transactions(id),
foreign key (id_product) references products(id));

insert into trans_products (
id_transaction, id_product)
select t.id, p.id
from transactions t
inner join products p on find_in_set(p.id, replace(t.product_ids,', ',','))
where declined = 0;

SELECT * FROM trans_products;
-- Nivel 3
-- ej 1
select p.id, p.product_name, count(id_transaction) as total_transaction
from trans_products t
inner join products p 
on t.id_product = p.id
group by p.id, p.product_name
order by total_transaction desc;
	