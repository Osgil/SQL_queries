/*На основе информации в таблицах orders и products рассчитайте ежедневную выручку сервиса и отразите её в колонке daily_revenue. 
Затем посчитайте ежедневный прирост выручки. 
Прирост выручки отразите как в абсолютных значениях, так и в % относительно предыдущего дня. 
Колонку с абсолютным приростом назовите revenue_growth_abs, а колонку с относительным — revenue_growth_percentage.

Для самого первого дня укажите прирост равным 0 в обеих колонках. 
При проведении расчётов отменённые заказы не учитывайте. 
Результат отсортируйте по колонке с датами по возрастанию.

Метрики daily_revenue, revenue_growth_abs, revenue_growth_percentage округлите до одного знака поесле запятой.

Поля в результирующей таблице: date, daily_revenue, revenue_growth_abs, revenue_growth_percentage*/

SELECT date,
       round(daily_revenue, 1) as daily_revenue,
       round(coalesce(daily_revenue - lag(daily_revenue) OVER (ORDER BY date), 0),
             1) as revenue_growth_abs,
       round(coalesce(daily_revenue / lag(daily_revenue) OVER (ORDER BY date) * 100 -100, 0),
             1) as revenue_growth_percentage
             -- coalesce()
FROM   (SELECT date,
               sum(price) as daily_revenue
        FROM   (SELECT order_id,
                       creation_time,
                       creation_time::date as date,
                       unnest(product_ids) as product_id
                FROM   orders
                WHERE  order_id not in (SELECT order_id
                                        FROM   user_actions
                                        WHERE  action = 'cancel_order')) l
            LEFT JOIN (SELECT product_id,
                              price
                       FROM   products) r using (product_id)
        GROUP BY date
        ORDER BY date) as final_table