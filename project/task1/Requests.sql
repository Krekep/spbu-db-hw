-- Самый срочный заказ магазина
SELECT * FROM Client_Order
	ORDER BY Client_Order.Order_complete_time ASC
LIMIT 1
;

-- Рассчитать сколько времени займёт производство 100 единиц сметаны
SELECT 100 * MAX(Time_per_volume) AS "Days" FROM Product_Type
	JOIN Ingredietns ON Product_Type.Ingredient_type_ID = Ingredietns.Ingredient_type_ID
	WHERE Ingredient_Name = 'Milk'
LIMIT 10
;

-- Названия предприятий и магазинов, с которыми налажен контакт
SELECT OOO_Name AS "Contacts" FROM OOO
UNION
SELECT Shop_Name FROM Shop
LIMIT 10
;

-- Количество продукции из ингредиентов
SELECT Ingredient_Name, Ingredietns.Ingredient_type_ID, COUNT(*) AS "Count" FROM Ingredietns
	JOIN Product_Type ON Product_Type.Ingredient_type_ID = Ingredietns.Ingredient_type_ID
	GROUP BY Ingredietns.Ingredient_type_ID, Ingredietns.Ingredient_Name
LIMIT 10
;

-- Заказы клиентов с добавленными именами товаров
SELECT *, (SELECT Product_Name FROM Product_Type WHERE Client_Order.Product_type_ID = Product_Type.Product_type_ID) AS "Product name" FROM Client_Order 
LIMIT 10
;

-- Товары которых нет на складе
SELECT * FROM Product_Type 
	WHERE Product_Type.Product_type_ID <> ALL(SELECT Product_type_ID FROM Product)
LIMIT 10
;