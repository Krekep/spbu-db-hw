CREATE PROCEDURE add_new_shop
(
	Shop_name	VARCHAR (20)
)
LANGUAGE SQL
AS $$
	INSERT INTO Shop(Shop_ID, Shop_Name)
		VALUES ((SELECT MAX(Shop_ID) + 1 FROM Shop), Shop_name);
$$;

-- удаление
-- DROP PROCEDURE add_new_shop;

-- вызов
/*
SELECT * FROM Shop;
CALL add_new_shop('name');

SELECT * FROM Shop;
*/

------------------------------------

CREATE PROCEDURE delete_OOO
(
	input_OOO_name	VARCHAR (20)
)
LANGUAGE plpgsql 
AS $$
	DECLARE temp_OOO_ID INT;
BEGIN
	SELECT OOO.OOO_ID INTO temp_OOO_ID FROM OOO WHERE OOO.OOO_name = input_OOO_name;

	DELETE FROM OOO WHERE OOO.OOO_ID = temp_OOO_ID;
END;
$$;

-- удаление
-- DROP PROCEDURE delete_OOO;

-- вызов
/*
SELECT * FROM OOO;
SELECT * FROM Order_to_factory;
CALL delete_OOO('MolokoFerma');

SELECT * FROM OOO;
SELECT * FROM Order_to_factory;
*/