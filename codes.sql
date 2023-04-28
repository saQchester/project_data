Расчет количества продуктов
CREATE OR REPLACE FUNCTION record_count
RETURN NUMBER
IS
  v_count NUMBER;
BEGIN
  SELECT COUNT(*) INTO v_count FROM Product;
  RETURN v_count;
END;

Выводим количество продуктов которые дороже 1000 если нет то они не активны
CREATE OR REPLACE PROCEDURE update_status
IS
BEGIN
  UPDATE Product
  SET prod_status = 'ACTIVE'
  WHERE prod_price > 1000;
  
  DBMS_OUTPUT.PUT_LINE('Number of rows affected: ' || SQL%ROWCOUNT);
END;

Триггер для исправления количества символов
CREATE OR REPLACE TRIGGER check_title_length
BEFORE INSERT ON Product
FOR EACH ROW
DECLARE
  title_length NUMBER;
  invalid_title EXCEPTION;
BEGIN
  title_length := LENGTH(:NEW.prod_name);
  IF title_length < 5 THEN
    RAISE invalid_title;
  END IF;
EXCEPTION
  WHEN invalid_title THEN
    RAISE_APPLICATION_ERROR(-20001, 'Title must be at least 5 characters.');
END;

тот же расчёт количества но в триггере при вводе нового продукта
CREATE OR REPLACE TRIGGER show_row_count
BEFORE INSERT ON Product
DECLARE
  v_count NUMBER;
BEGIN
  SELECT COUNT(*) INTO v_count FROM Product;
  DBMS_OUTPUT.PUT_LINE('Current number of rows: ' || v_count);
END;

Тот же расчёт продуктов в функции
CREATE OR REPLACE FUNCTION get_count_of_records
RETURN NUMBER IS
  v_count NUMBER;
BEGIN
  SELECT COUNT(*) INTO v_count
  FROM Product;
  RETURN v_count;
END

Группировка продуктов по категориям и подчёт количества
CREATE OR REPLACE PROCEDURE group_products_by_category AS
BEGIN
  FOR rec IN (
    SELECT cat_name, COUNT(prod_id) AS product_count
    FROM Product 
    JOIN Product_category  ON cat_id = cat_id
    GROUP BY cat_name
    ORDER BY cat_name
  ) LOOP
    DBMS_OUTPUT.PUT_LINE(rec.cat_name || ': ' || rec.product_count);
  END LOOP;
END;
