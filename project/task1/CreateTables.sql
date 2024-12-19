---------------------------------------------------------------
-- Создание таблиц и PK 
---------------------------------------------------------------

CREATE TABLE shop(
    shop_id				INTEGER	PRIMARY KEY NOT NULL,
    shop_name			VARCHAR(20)	NOT NULL
)
;

CREATE TABLE ingredietns(
    ingredient_type_id				INTEGER	PRIMARY KEY	NOT NULL,
    ingredient_name					VARCHAR(20)	NOT NULL
)
;

CREATE TABLE product_type(
    product_type_id				INTEGER	PRIMARY KEY	NOT NULL,
    product_name				VARCHAR(20)	NOT NULL,
	ingredient_type_id			INTEGER NOT NULL,
	time_per_volume				INTEGER NOT NULL,
	
	FOREIGN KEY (ingredient_type_id) 
			REFERENCES ingredietns (ingredient_type_id) 
		ON DELETE CASCADE
)
;

CREATE TABLE product(
    product_id					INTEGER	PRIMARY KEY	NOT NULL,
    product_type_id				INTEGER	NOT NULL,
	best_before_date			DATE	DEFAULT CURRENT_DATE NOT NULL,
	product_volume				INTEGER NOT NULL,
	
	FOREIGN KEY (product_type_id) 
			REFERENCES product_type (product_type_id) 
		ON DELETE CASCADE
)
;

-- providers
CREATE TABLE ooo(
    ooo_id						INTEGER	PRIMARY KEY	NOT NULL,
	ooo_name					VARCHAR(20)	NOT NULL,
	ingredient_type_id			INTEGER NOT NULL,
    regularity					INTEGER	CHECK (regularity > 0) NOT NULL,
	cost_per_volume				INTEGER NOT NULL,
	delivered_volume			INTEGER	CHECK (delivered_volume > 0) NOT NULL,

	FOREIGN KEY (ingredient_type_id) 
			REFERENCES ingredietns (ingredient_type_id) 
		ON DELETE CASCADE
)
;

CREATE TABLE client_order(
    order_id				INTEGER	PRIMARY KEY	NOT NULL,
	shop_id					INTEGER	NOT NULL,
    product_type_id			INTEGER	NOT NULL,
	product_volume			INTEGER	CHECK (product_volume > 0) NOT NULL,
	cost					INTEGER NOT NULL,
	order_complete_time		DATE	DEFAULT CURRENT_DATE NOT NULL,

	FOREIGN KEY (shop_id) 
			REFERENCES shop (shop_id) 
		ON DELETE CASCADE,
	FOREIGN KEY (product_type_id) 
			REFERENCES product_type (product_type_id) 
		ON DELETE CASCADE
)
;

CREATE TABLE order_to_factory(
	order_id					INTEGER	PRIMARY KEY	NOT NULL,
	ooo_id						INTEGER	NOT NULL,
	product_volume				INTEGER	CHECK (product_volume > 0)	NOT NULL,
	order_start_time			DATE	DEFAULT CURRENT_DATE	NOT NULL,

	FOREIGN KEY (ooo_id) 
			REFERENCES ooo (ooo_id) 
		ON DELETE CASCADE
)
;

---------------------------------------------------------------
-- Заполнение таблиц тестовыми данными
---------------------------------------------------------------

INSERT INTO shop (shop_id, shop_name)
VALUES	(1, 'LENTA'),
		(2, 'OKEI'),
		(3, 'OBI'),
		(4, 'ASHAN'),
		(5, 'HOFF'),
		(6, 'DIKSI');

INSERT INTO ingredietns (ingredient_type_id, ingredient_name)
VALUES	(1, 'Cheese'),
		(2, 'Milk'),
		(3, 'Butter'),
		(4, 'Curd'),
		(5, 'Sour cream');

INSERT INTO product_type (product_type_id, product_name, ingredient_type_id, time_per_volume)
VALUES	(1, 'Russian cheese', 1, 3),
		(2, 'Holland cheese', 1, 5),
		(3, 'Lamber cheese', 1, 12),
		(4, 'Granular curd', 4, 3),
		(5, 'Curd', 4, 2),
		(6, 'Packaged sour cream', 5, 1),
		(7, 'Ice cream', 2, 4),
		(8, 'Yogurt', 2, 6);

INSERT INTO product (product_id, product_type_id, product_volume, best_before_date)
VALUES	(1, 1, 10, '2024-09-04 00:00'),
		(2, 1, 5, '2022-12-12 00:00'),
		(3, 3, 100, '2024-01-01 00:00'),
		(4, 7, 2, '2024-12-04 00:00'),
		(5, 8, 10, '2022-03-12 00:00');

INSERT INTO ooo (ooo_id, OOO_name, ingredient_type_id, regularity, delivered_volume, cost_per_volume)
VALUES	(1, 'SirFerma', 1, 7, 1, 1000),
		(2, 'MolokoFerma', 2, 2, 100, 100),
		(3, 'MasloFerma', 3, 12, 50, 200),
		(4, 'TvorogFerma', 4, 4, 100, 300),
		(5, 'SmetanaFerma', 5, 4, 100, 400);

INSERT INTO client_order(order_id, product_type_id, shop_id, cost, product_volume, order_complete_time)
VALUES	(1, 1, 1, 1500, 1, '2022-12-24T00:00:00'),
		(2, 2, 2, 500, 10, '2022-12-24T00:00:00'),
		(3, 3, 3, 500, 10, '2022-12-24T00:00:00');


INSERT INTO order_to_factory(order_id, ooo_id, order_start_time, product_volume)
VALUES	(1, 1, '2022-12-04 00:00', 10),
		(2, 2, '2022-12-05 00:00', 20),
		(3, 3, '2024-12-06 00:00', 30);


-------------------------------------------------------------------------------------------------------------------------------------------------------
-- Создание индексов
-------------------------------------------------------------------------------------------------------------------------------------------------------
CREATE INDEX OOO_ingredients_idx
ON ooo (ingredient_type_id);
CREATE UNIQUE INDEX shops_id_idx
on shop (shop_id);

---------------------------------------------------------------
-- Удаление таблиц 
---------------------------------------------------------------

/*
DROP TABLE order_to_factory;
DROP TABLE client_order;
DROP TABLE shop;
DROP TABLE product;
DROP TABLE ooo;
DROP TABLE product_type;
DROP TABLE ingredietns;
*/