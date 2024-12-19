CREATE PROCEDURE add_new_shop
(
	shop_name	VARCHAR (20)
)
LANGUAGE SQL
AS $$
	INSERT INTO shop(shop_id, shop_name)
		VALUES ((SELECT MAX(shop_id) + 1 FROM shop), shop_name);
$$;

-- удаление
-- DROP PROCEDURE add_new_shop;

-- вызов
/*
SELECT * FROM shop;
CALL add_new_shop('name');

SELECT * FROM shop;
*/

------------------------------------

CREATE PROCEDURE delete_ooo
(
	input_ooo_name	VARCHAR (20)
)
LANGUAGE plpgsql 
AS $$
	DECLARE temp_ooo_id INT;
BEGIN
	SELECT ooo.ooo_id INTO temp_ooo_id FROM ooo WHERE ooo.ooo_name = input_ooo_name;

	DELETE FROM ooo WHERE ooo.ooo_id = temp_ooo_id;
END;
$$;

-- удаление
-- DROP PROCEDURE delete_ooo;

-- вызов
/*
SELECT * FROM ooo;
SELECT * FROM order_to_factory;
CALL delete_ooo('MolokoFerma');

SELECT * FROM ooo;
SELECT * FROM order_to_factory;
*/