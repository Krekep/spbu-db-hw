-- Самый срочный заказ магазина
SELECT * FROM client_order
	ORDER BY client_order.order_complete_time ASC
LIMIT 1
;

-- Рассчитать сколько времени займёт производство 100 единиц сметаны
SELECT 100 * MAX(time_per_volume) AS "Days" FROM product_type
	JOIN ingredietns ON product_type.ingredient_type_id = ingredietns.ingredient_type_id
	WHERE ingredient_name = 'Milk'
LIMIT 10
;

-- Названия предприятий и магазинов, с которыми налажен контакт
SELECT ooo_name AS "Contacts" FROM ooo
UNION
SELECT shop_name FROM shop
LIMIT 10
;

-- Количество продукции из ингредиентов
SELECT ingredient_name, ingredietns.ingredient_type_id, COUNT(*) AS "Count" FROM ingredietns
	JOIN product_type ON product_type.ingredient_type_id = ingredietns.ingredient_type_id
	GROUP BY ingredietns.ingredient_type_id, ingredietns.ingredient_name
LIMIT 10
;

-- Заказы клиентов с добавленными именами товаров
SELECT *, (SELECT product_name FROM product_type WHERE client_order.product_type_id = product_type.product_type_id) AS "product name" FROM client_order 
LIMIT 10
;

-- Товары которых нет на складе
SELECT * FROM product_type 
	WHERE product_type.product_type_id <> ALL(SELECT product_type_id FROM product)
LIMIT 10
;


-- Количество сыра, который скоро испортится
SELECT volume AS "Cheese count" FROM v_old_product
	JOIN product_type ON v_old_product.product_type_id = product_type.product_type_id
	JOIN ingredietns ON product_type.ingredient_type_id = ingredietns.ingredient_type_id
	WHERE ingredietns.ingredient_name = 'Cheese'
LIMIT 10
;
	
-- Наш лучший клиент
SELECT shop_name FROM v_orders_per_shop
	ORDER BY Order_count DESC
LIMIT 1
;
	
-- Самый быстроприготовляемый сыр
SELECT product_type.product_name FROM v_cheese_products AS v
	JOIN product_type ON v.product_type_id = product_type.product_type_id
	ORDER BY time_per_volume ASC
LIMIT 1
;
