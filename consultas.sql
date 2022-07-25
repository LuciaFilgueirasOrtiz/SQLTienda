-- consultas para practicar la sintaxis de sql 

USE TiendaPractica
select * from producto
select * from fabricante
-- 1. ¿Cuál es el código de los fabricantes que tienen productos en la tabla productos?
SELECT codigo_fabricante
FROM producto
GROUP BY codigo_fabricante
ORDER BY codigo_fabricante

-- 2. Lista el nombre y el precio del producto más barato. (Utilice solamente las cláusulas ORDER BY y LIMIT)
SELECT TOP(1) nombre, precio
FROM producto
ORDER BY precio ASC

-- 3. Lista el nombre y el precio de los productos en euro, céntimos de euro y en dolares. (Habrá que multiplicar por 100 el valor del precio). Cree un alias para la columna que contiene el precio que se llame céntimos.
SELECT nombre,
precio, 
(precio * 100) as céntimos_euro,
(precio * 1.6) as dólares
FROM producto

-- 4.Devuelve el nombre del producto, su precio y el nombre de su fabricante, del producto más barato.
SELECT TOP(1) p.nombre, p.precio, f.nombre
FROM producto p
INNER JOIN fabricante f ON p.codigo_fabricante = f.codigo
GROUP BY p.nombre, p.precio, f.nombre
ORDER BY p.precio ASC

-- 5. Devuelve un listado de todos los fabricantes que existen en la base de datos, junto con los productos que tiene cada uno de ellos. El listado deberá mostrar también aquellos fabricantes que no tienen productos asociados.
SELECT f.nombre, p.nombre
FROM fabricante f 
LEFT JOIN producto p ON f.codigo = p.codigo_fabricante

-- 6. Calcula el número de valores distintos de código de fabricante aparecen en la tabla productos, mínimo de precio, máximo precio, precio medio y suma del precio de todos los productos. 
SELECT COUNT(codigo_fabricante) AS VALORES_DISTINTOS_CODIGO, 
MIN(precio) AS PRECIO_MINIMO, 
MAX(precio) AS PRECIO_MAXIMO, 
ROUND(AVG(precio),2) AS MEDIA_PRECIO, 
SUM(precio) AS SUMA_PRECIOS
FROM producto

-- 7. Muestra el número total de productos que tiene cada uno de los fabricantes. El listado también debe incluir los fabricantes que no tienen ningún producto. El resultado mostrará dos columnas, una con el nombre del fabricante y otra con el número de productos que tiene. Ordene el resultado descendentemente por el número de productos.
SELECT f.nombre, COUNT(p.codigo) AS total_productos
FROM producto p
RIGHT JOIN fabricante f ON p.codigo_fabricante = f.codigo
GROUP BY f.nombre
ORDER BY total_productos DESC
-- 8. Muestra el precio máximo, precio mínimo y precio medio de los productos de cada uno de los fabricantes. El resultado mostrará el nombre del fabricante junto con los datos que se solicitan.
SELECT f.nombre,
		MAX(p.precio) AS PRECIO_MAXIMO,
		MIN(P.precio) AS PRECIO_MINIMO, 
		ROUND(AVG(p.precio),2) AS MEDIA_PRECIO
FROM producto p
INNER JOIN fabricante f ON p.codigo_fabricante = f.codigo
GROUP BY f.nombre

-- 9. Devuelve un listado con los nombres de los fabricantes donde la suma del precio de todos sus productos es superior a 1000 €.
SELECT f.nombre, SUM(p.precio) AS suma_precio
FROM producto p
INNER JOIN fabricante f ON p.codigo_fabricante = f.codigo
GROUP BY f.nombre
HAVING SUM(p.precio) > 1000

-- 10. Devuelve un listado con el nombre del producto más caro que tiene cada fabricante. 
-- El resultado debe tener tres columnas: nombre del producto, precio y nombre del fabricante. El resultado tiene que estar ordenado alfabéticamente de menor a mayor por el nombre del fabricante.
SELECT p.nombre,
		MAX(p.precio) AS precio_maximo,
		f.nombre
FROM producto p
INNER JOIN fabricante f 
	ON p.codigo_fabricante = f.codigo
GROUP BY p.nombre, f.nombre
ORDER BY f.nombre ASC

-- 11. Devuelve todos los productos del fabricante Lenovo. (Sin utilizar INNER JOIN)
SELECT *
FROM producto
WHERE codigo_fabricante IN ( SELECT codigo FROM fabricante WHERE nombre LIKE '%lenovo%')

-- 12. Devuelve todos los datos de los productos que tienen el mismo precio que el producto más caro del fabricante Lenovo. (Sin utilizar INNER JOIN
SELECT *
FROM producto
WHERE precio >= (SELECT MAX(precio)	
				 FROM producto
				 WHERE codigo_fabricante = 2)

-- 13. Lista todos los productos del fabricante Asus que tienen un precio superior al precio medio de todos sus productos.
SELECT *
FROM producto 
WHERE codigo_fabricante = 1
	AND precio > (SELECT ROUND(AVG(precio),2)
				  FROM producto
				  WHERE codigo_fabricante = 1)

-- 14. Devuelve los nombres de los fabricantes que tienen productos asociados. 
SELECT nombre
FROM fabricante
WHERE codigo IN (SELECT codigo_fabricante
				 FROM producto)

-- 15. Devuelve los nombres de los fabricantes que no tienen productos asociados. (Utilizando IN o NOT IN).
SELECT nombre
FROM fabricante
WHERE codigo NOT IN (SELECT codigo_fabricante FROM producto)
