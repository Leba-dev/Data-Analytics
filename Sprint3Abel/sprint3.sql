-- Abel.
-- Comprovaciones
SHOW TABLES;
SHOW CREATE TABLE company;
SHOW CREATE TABLE transaction;
SHOW CREATE TABLE credit_card;
DESCRIBE credit_card;
DESCRIBE company;
DESCRIBE transaction;
SELECT * FROM company;
SELECT * FROM credit_card;
SELECT * FROM transaction;



-- Ej 1
-- Creación de la tabla dentro del esquema transaction. La tabla con los campos y el tipo de formato que es.
CREATE TABLE credit_card ( 
id VARCHAR(50) DEFAULT NULL ,
iban VARCHAR(255),
pan VARCHAR(255),
pin VARCHAR(255),
cvv VARCHAR(255),
expiring_date VARCHAR(255)
);
-- Cuando he creado el campo expiring_date, me dio problemas el formato date. Y deje VARCHAR.
-- Aquí l tener problemas con el formato date, borre la tabla credit_card para retomar el ejercio de nuevo.
DROP TABLE credit_card;

-- Asignación de la Pk, en tabla credit_card
ALTER TABLE credit_card
ADD PRIMARY KEY (id);

-- Unión de la tabla transaction (Fk credit_car_id) -> tabla credit_car (Pk Id) 
ALTER TABLE transaction
ADD CONSTRAINT fk_transaction_credit_card
FOREIGN KEY (credit_card_id) REFERENCES credit_card(id);


-- Ej 2 Modificar un registo de una tabla -SPAM ABEL XD-
UPDATE credit_card
SET iban = 'R323456312213576817699999'
WHERE id ='CcU-2938';

-- Ej 3 Ingresar datos nuevo usuario y llenar el resto de campos.

INSERT INTO credit_card (id)
VALUES ('CcU-9999');

INSERT INTO transaction (id, credit_card_id, company_id, user_id, lat, longitude, amount, declined)
VALUES ('108B1D1D-5B23-A76C-55EF-C568E49A99DD', 'CcU-9999', 'b-9999', 9999, 829.999, -177.999, 111.11, 0);

-- Comprobaciones
INSERT INTO company (id)
VALUES ('b-9999');
SELECT * FROM company
where id = 'b-9999';
SELECT * FROM transaction
where company_id = 'b-9999';
SELECT * FROM credit_card
where id = 'Ccu-9999';


-- Ej 4

ALTER TABLE credit_card
DROP COLUMN pan;

SELECT * FROM credit_card;

-- Nivel 2
-- Ex1
select * from transaction t
where t.id = '02C6201E-D90A-1859-B4EE-88D2986D3B02' ;


DELETE FROM transaction
WHERE ID = '02C6201E-D90A-1859-B4EE-88D2986D3B02';

CREATE VIEW vista_marketing AS
SELECT c.company_name, c.phone, c.country, c.id, ROUND(AVG(t.amount), 2) AS media_compras
FROM company c
JOIN transaction t
ON c.id = t.company_id
GROUP BY c.id
ORDER BY media_compras DESC;


select* from company;
select* from transaction;



/*
La secció de màrqueting desitja tenir accés a informació específica per a realitzar anàlisi i estratègies efectives.
 S'ha sol·licitat crear una vista que proporcioni detalls clau sobre les companyies i les seves transaccions. 
 Serà necessària que creïs una vista anomenada VistaMarketing que contingui la següent informació: Nom de la companyia. 
 Telèfon de contacte. País de residència. Mitjana de compra realitzat per cada companyia. 
Presenta la vista creada, ordenant les dades de major a menor mitjana de compra.

*/

-- Ex 2
CREATE VIEW vista_marketing AS
SELECT c.company_name, c.phone, c.country, c.id, ROUND(AVG(t.amount), 2) AS media_compras
FROM company c
JOIN transaction t
ON c.id = t.company_id
GROUP BY c.id
ORDER BY media_compras DESC;

/*select t.company_id,round(avg(t.amount) ,2)
from transaction t
group by t.company_id
having t.company_id = 'b-2398';  comprobacion media*/

-- Ex 3

SELECT * FROM vista_marketing
WHERE country = 'Germany';




