-- Tabla de dimensión ->1
SELECT*
FROM company;

-- Tabla de echos ->N
SELECT*
FROM transaction;

-- Llista dels països que estan fent compres
SELECT  distinct c.country
FROM company AS c
JOIN transaction AS t 
ON c.id = t.company_id
WHERE t.declined= 0;

-- Des de quants països es realitzen les compres.

SELECT COUNT(DISTINCT c.country) AS PaisosCompradors
FROM company AS c
JOIN transaction AS t 
ON c.id = t.company_id
WHERE t.declined = 0;



-- Identifica la companyia amb la mitjana més gran de vendes

SELECT c.company_name AS Empresa, round(AVG(t.amount),2) AS Venda_Mitjana
FROM company AS c
JOIN transaction AS t ON c.id = t.company_id
WHERE t.declined = 0
GROUP BY c.company_name
ORDER BY Venda_Mitjana DESC
LIMIT 1;



-- Exercici 3. Utilitzant només subconsultes (sense utilitzar JOIN):

-- Mostra totes les transaccions realitzades per empreses d'Alemanya.
SELECT *
FROM transaction as t
WHERE (SELECT c.country
		FROM company as c
        WHERE c.id = t.company_id ) = 'Germany'
;

-- Llista les empreses que han realitzat transaccions per un amount superior a la mitjana de totes les transaccions.
SELECT c.company_name
FROM company AS c
WHERE EXISTS (
			SELECT *
			FROM transaction AS t
			WHERE t.company_id = c.id
			AND t.amount > (
							SELECT AVG(amount) AS avg_transaction
							FROM transaction
											)
);

SELECT c.company_name
FROM company AS c
WHERE EXISTS (
  SELECT *  -- Seleccionar cualquier columna del registro es suficiente
  FROM transaction AS t
  WHERE t.company_id = c.id
  AND t.amount > (
    SELECT AVG(amount) AS avg_transaction
    FROM transaction AS t
  )
);

-- Eliminaran del sistema les empreses que no tenen transaccions registrades, entrega el llistat d'aquestes empreses.

SELECT c.company_name
FROM company AS c
WHERE NOT EXISTS (
  SELECT *
  FROM transaction AS t
  WHERE t.company_id = c.id
);

