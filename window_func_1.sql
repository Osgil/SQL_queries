/*На основе информации в таблицах orders и products рассчитайте стоимость каждого заказа, 
ежедневную выручку сервиса и долю стоимости каждого заказа в ежедневной выручке, выраженную в процентах. 
В результат включите следующие колонки: id заказа, время создания заказа, стоимость заказа, выручку за день, в который был совершён заказ, 
а также долю стоимости заказа в выручке за день, выраженную в процентах.

При расчёте долей округляйте их до трёх знаков после запятой.

Результат отсортируйте сначала по убыванию даты совершения заказа , потом по убыванию доли заказа в выручке за день, затем по возрастанию id заказа.

При проведении расчётов отменённые заказы не учитывайте.*/

SELECT order_id,
       creation_time,
       order_price,
       sum(order_price) OVER (PARTITION BY creation_date) as daily_revenue,
       round(order_price / sum(order_price) OVER (PARTITION BY creation_date) * 100,
             3) as percentage_of_daily_revenue
FROM   (SELECT DISTINCT order_id,
                        creation_time,
                        creation_date,
                        sum(price) OVER (PARTITION BY order_id) as order_price
        FROM   ((SELECT order_id,
                        creation_time,
                        creation_time::date as creation_date,
                        unnest(product_ids) as product_id
                 FROM   orders
                 WHERE  order_id not in (SELECT order_id
                                         FROM   user_actions
                                         WHERE  action = 'cancel_order')) l
            LEFT JOIN (SELECT product_id,
                              price
                       FROM   products) r using (product_id)) as t) as final_table
ORDER BY creation_date desc, percentage_of_daily_revenue desc, order_id asc