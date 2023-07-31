-- С помощью оконной функции рассчитайте медианную стоимость всех заказов из таблицы orders, оформленных в нашем сервисе. 
-- В качестве результата выведите одно число. 
-- Колонку с ним назовите median_price. Отменённые заказы не учитывайте. 
-- Не использовать функции, вычисляющие квантили.

-- Поле в результирующей таблице: median_price

WITH main_table AS (
  SELECT
    order_price,
    ROW_NUMBER() OVER (
      ORDER BY
        order_price
    ) AS row_number,
    COUNT(*) OVER() AS total_rows
  FROM
    (
      SELECT
        SUM(price) AS order_price
      FROM
        (
          SELECT
            order_id,
            product_ids,
            UNNEST(product_ids) AS product_id
          FROM
            orders
          WHERE
            order_id NOT IN (
              SELECT
                order_id
              FROM
                user_actions
              WHERE
                action = 'cancel_order'
            )
        ) t3
        LEFT JOIN products USING(product_id)
      GROUP BY
        order_id
    ) t1
)
SELECT
  AVG(order_price) AS median_price
FROM
  main_table
WHERE
  row_number BETWEEN total_rows / 2.0
  AND total_rows / 2.0 + 1