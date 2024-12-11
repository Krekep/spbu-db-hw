---------------------------------------------------------------
-- Количество товаров на складе по типам с истекающим сроком годности
---------------------------------------------------------------
CREATE VIEW V_old_Product(Product_type_ID, Volume)
AS
    SELECT Product.Product_type_ID, SUM(Product_volume)  FROM Product
		WHERE (DATE_PART('month', CURRENT_DATE) - DATE_PART('month', Product.Best_before_date)) <= 2
		GROUP BY Product.Product_type_ID
		HAVING SUM(Product_volume) > 20;

-- DROP VIEW V_old_Product;

---------------------------------------------------------------
-- Продукты из сыра
---------------------------------------------------------------
CREATE VIEW V_cheese_products(Product_type_ID, Product_name)
AS
    SELECT Product_type_ID, Product_Name  FROM Product_Type, Ingredietns
		WHERE Product_Type.Ingredient_type_ID = Ingredietns.Ingredient_type_ID
				AND Ingredient_Name = 'Cheese';
	
-- DROP VIEW V_cheese_products;

---------------------------------------------------------------
-- Количество заказов для магазинов
---------------------------------------------------------------
CREATE VIEW V_orders_per_shop(Shop_Name, Order_count)
AS
    SELECT Shop_name, COUNT(Order_ID) AS "Count" FROM Shop
		LEFT JOIN Client_Order ON Client_Order.Shop_ID = Shop.Shop_ID
		GROUP BY Shop_Name;

-- DROP VIEW V_orders_per_shop;