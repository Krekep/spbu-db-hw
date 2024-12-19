---------------------------------------------------------------
-- Количество товаров на складе по типам с истекающим сроком годности
---------------------------------------------------------------
CREATE VIEW v_old_product(product_type_id, volume)
AS
    SELECT product.product_type_id, SUM(product_volume)  FROM product
		WHERE (DATE_PART('month', CURRENT_DATE) - DATE_PART('month', product.best_before_date)) <= 2
		GROUP BY product.product_type_id
		HAVING SUM(product_volume) > 20;

-- DROP VIEW v_old_product;

---------------------------------------------------------------
-- Продукты из сыра
---------------------------------------------------------------
CREATE VIEW v_cheese_products(product_type_id, product_name)
AS
    SELECT product_type_id, product_name  FROM product_type, ingredietns
		WHERE product_type.ingredient_type_id = ingredietns.ingredient_type_id
				AND ingredient_name = 'Cheese';
	
-- DROP VIEW v_cheese_products;

---------------------------------------------------------------
-- Количество заказов для магазинов
---------------------------------------------------------------
CREATE VIEW v_orders_per_shop(shop_name, order_count)
AS
    SELECT shop_name, COUNT(order_id) AS "Count" FROM shop
		LEFT JOIN client_order ON client_order.shop_id = shop.shop_id
		GROUP BY shop_name;

-- DROP VIEW v_orders_per_shop;