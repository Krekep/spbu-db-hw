---------------------------------------------------------------
-- Создание таблиц и PK 
---------------------------------------------------------------

CREATE TABLE Shop(
    Shop_ID				INTEGER	PRIMARY KEY NOT NULL,
    Shop_Name			VARCHAR(20)	NOT NULL
)
;

CREATE TABLE Ingredietns(
    Ingredient_type_ID				INTEGER	PRIMARY KEY	NOT NULL,
    Ingredient_Name					VARCHAR(20)	NOT NULL
)
;

CREATE TABLE Product_Type(
    Product_type_ID				INTEGER	PRIMARY KEY	NOT NULL,
    Product_Name				VARCHAR(20)	NOT NULL,
	Ingredient_type_ID			INTEGER NOT NULL,
	Time_per_volume				INTEGER NOT NULL,
	
	FOREIGN KEY (Ingredient_type_ID) 
			REFERENCES Ingredietns (Ingredient_type_ID) 
		ON DELETE CASCADE
)
;

CREATE TABLE Product(
    Product_ID					INTEGER	PRIMARY KEY	NOT NULL,
    Product_type_ID				INTEGER	NOT NULL,
	Best_before_date			DATE	DEFAULT CURRENT_DATE NOT NULL,
	Product_volume				INTEGER NOT NULL,
	
	FOREIGN KEY (Product_type_ID) 
			REFERENCES Product_Type (Product_type_ID) 
		ON DELETE CASCADE
)
;

-- providers
CREATE TABLE OOO(
    OOO_ID						INTEGER	PRIMARY KEY	NOT NULL,
	OOO_Name					VARCHAR(20)	NOT NULL,
	Ingredient_type_ID			INTEGER NOT NULL,
    Regularity					INTEGER	CHECK (Regularity > 0) NOT NULL,
	Cost_per_volume				INTEGER NOT NULL,
	Delivered_volume			INTEGER	CHECK (Delivered_volume > 0) NOT NULL,

	FOREIGN KEY (Ingredient_type_ID) 
			REFERENCES Ingredietns (Ingredient_type_ID) 
		ON DELETE CASCADE
)
;

CREATE TABLE Client_Order(
    Order_ID				INTEGER	PRIMARY KEY	NOT NULL,
	Shop_ID					INTEGER	NOT NULL,
    Product_type_ID			INTEGER	NOT NULL,
	Product_volume			INTEGER	CHECK (Product_volume > 0) NOT NULL,
	Cost					INTEGER NOT NULL,
	Order_complete_time		DATE	DEFAULT CURRENT_DATE NOT NULL,

	FOREIGN KEY (Shop_ID) 
			REFERENCES Shop (Shop_ID) 
		ON DELETE CASCADE,
	FOREIGN KEY (Product_type_ID) 
			REFERENCES Product_Type (Product_type_ID) 
		ON DELETE CASCADE
)
;

CREATE TABLE Order_to_factory(
	Order_ID					INTEGER	PRIMARY KEY	NOT NULL,
	OOO_ID						INTEGER	NOT NULL,
	Product_volume				INTEGER	CHECK (Product_volume > 0)	NOT NULL,
	Order_start_time			DATE	DEFAULT CURRENT_DATE	NOT NULL,

	FOREIGN KEY (OOO_ID) 
			REFERENCES OOO (OOO_ID) 
		ON DELETE CASCADE
)
;

---------------------------------------------------------------
-- Заполнение таблиц тестовыми данными
---------------------------------------------------------------

INSERT INTO Shop (Shop_ID, Shop_Name)
VALUES	(1, 'LENTA'),
		(2, 'OKEI'),
		(3, 'OBI'),
		(4, 'ASHAN'),
		(5, 'HOFF'),
		(6, 'DIKSI');

INSERT INTO Ingredietns (Ingredient_type_ID, Ingredient_Name)
VALUES	(1, 'Cheese'),
		(2, 'Milk'),
		(3, 'Butter'),
		(4, 'Curd'),
		(5, 'Sour cream');

INSERT INTO Product_Type (Product_type_ID, Product_Name, Ingredient_type_ID, Time_per_volume)
VALUES	(1, 'Russian cheese', 1, 3),
		(2, 'Holland cheese', 1, 5),
		(3, 'Lamber cheese', 1, 12),
		(4, 'Granular curd', 4, 3),
		(5, 'Curd', 4, 2),
		(6, 'Packaged sour cream', 5, 1),
		(7, 'Ice cream', 2, 4),
		(8, 'Yogurt', 2, 6);

INSERT INTO Product (Product_ID, Product_type_ID, Product_volume, Best_before_date)
VALUES	(1, 1, 10, '2023-09-04 00:00'),
		(2, 1, 5, '2022-12-12 00:00'),
		(3, 3, 100, '2023-01-01 00:00'),
		(4, 7, 2, '2023-09-04 00:00'),
		(5, 8, 10, '2022-03-12 00:00');

INSERT INTO OOO (OOO_ID, OOO_name, Ingredient_type_ID, Regularity, Delivered_volume, Cost_per_volume)
VALUES	(1, 'SirFerma', 1, 7, 1, 1000),
		(2, 'MolokoFerma', 2, 2, 100, 100),
		(3, 'MasloFerma', 3, 12, 50, 200),
		(4, 'TvorogFerma', 4, 4, 100, 300),
		(5, 'SmetanaFerma', 5, 4, 100, 400);

INSERT INTO Client_Order(Order_ID, Product_type_ID, Shop_ID, Cost, Product_volume, Order_complete_time)
VALUES	(1, 1, 1, 1500, 1, '2022-12-24T00:00:00'),
		(2, 2, 2, 500, 10, '2022-12-24T00:00:00'),
		(3, 3, 3, 500, 10, '2022-12-24T00:00:00');


INSERT INTO Order_to_factory(Order_ID, OOO_ID, Order_start_time, Product_volume)
VALUES	(1, 1, '2022-12-04 00:00', 10),
		(2, 2, '2022-12-05 00:00', 20),
		(3, 3, '2022-12-06 00:00', 30);


-------------------------------------------------------------------------------------------------------------------------------------------------------
-- Создание индексов
-------------------------------------------------------------------------------------------------------------------------------------------------------
CREATE INDEX OOO_ingredients_idx
ON OOO (Ingredient_type_ID);
CREATE UNIQUE INDEX shops_id_idx
on Shop (Shop_ID);

---------------------------------------------------------------
-- Удаление таблиц 
---------------------------------------------------------------

/*
DROP TABLE Order_to_factory;
DROP TABLE Client_Order;
DROP TABLE Shop;
DROP TABLE Product;
DROP TABLE OOO;
DROP TABLE Product_Type;
DROP TABLE Ingredietns;
*/