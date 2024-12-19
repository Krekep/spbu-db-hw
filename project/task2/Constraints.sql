---------------------------------------------------------------
-- Добавление ограничения на уникальность имени поставщика
---------------------------------------------------------------
ALTER TABLE ooo ADD CONSTRAINT unique_ooo_name UNIQUE (ooo_name);


---------------------------------------------------------------
-- Валидация запроса с помощью IF
---------------------------------------------------------------
DO $$
DECLARE p_id INT;
BEGIN
	p_id := 2;
    IF NOT EXISTS (
        SELECT 1
        	FROM product
        	WHERE product_id = p_id AND product_volume > 0
    ) THEN
        RAISE EXCEPTION 'There is no product_id % in stock', p_id;
    END IF;
END $$;

