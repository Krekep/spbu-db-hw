---------------------------------------------------------------
-- Добавление ограничения на уникальность имени поставщика
---------------------------------------------------------------
ALTER TABLE OOO ADD CONSTRAINT unique_ooo_name UNIQUE (OOO_Name);


---------------------------------------------------------------
-- Валидация запроса с помощью IF
---------------------------------------------------------------
DO $$
DECLARE p_id INT;
BEGIN
	p_id := 2;
    IF NOT EXISTS (
        SELECT 1
        	FROM Product
        	WHERE Product_ID = p_id AND Product_volume > 0
    ) THEN
        RAISE EXCEPTION 'There is no product_id % in stock', p_id;
    END IF;
END $$;

