---------------------------------------------------------------
-- Автоматическая очистка склада от старых продуктов
---------------------------------------------------------------

CREATE OR REPLACE FUNCTION del_old_products() RETURNS TRIGGER 
AS $$
BEGIN
	DELETE FROM product 
		WHERE best_before_date < CURRENT_DATE;
	RETURN NEW;
END;
$$ LANGUAGE plpgsql;


CREATE TRIGGER tr_del_old_products AFTER INSERT ON client_order
FOR EACH ROW 
EXECUTE FUNCTION del_old_products();

-- удаление
-- DROP TRIGGER tr_del_old_products ON client_order;

-- проверка транзации 
/*
INSERT INTO product VALUES (42, 1, CURRENT_DATE + INTERVAL '1 year', 42);

SELECT * FROM product;
INSERT INTO client_order VALUES (42, 1, 1, 1500, 42, CURRENT_DATE);
SELECT * FROM product;
*/
---------------------------------------------------------------
-- Запрет удаления невыполненных заказов поставщику
---------------------------------------------------------------

CREATE OR REPLACE FUNCTION ooo_del_prohib_uncompl() RETURNS TRIGGER 
AS $$
	DECLARE result_date DATE;
BEGIN
	SELECT MAX(order_start_time) + MAKE_INTERVAL(DAYS => MAX(product_volume) / MAX(delivered_volume) * MAX(regularity)) INTO result_date
	FROM order_to_factory AS ord
		JOIN ooo ON ord.ooo_id = ooo.ooo_id;
	IF CURRENT_DATE - result_date > 0 THEN
		RAISE EXCEPTION 'Prevent the removal of uncompleted orders from the supplier';
	END IF;
	RETURN NEW;
END;
$$ LANGUAGE plpgsql;


CREATE TRIGGER tr_ooo_del_prohib_uncompl BEFORE DELETE ON order_to_factory
FOR EACH ROW 
EXECUTE FUNCTION ooo_del_prohib_uncompl();


-- удаление
-- DROP TRIGGER tr_ooo_del_prohib_uncompl ON order_to_factory;

-- проверка не выполнения транзации
/*
SELECT * FROM order_to_factory;

INSERT INTO order_to_factory VALUES (42, 3, 1, CURRENT_DATE + INTERVAL '100 year');
SELECT * FROM order_to_factory;

DELETE FROM order_to_factory WHERE order_id = 42;
SELECT * FROM order_to_factory;
*/


