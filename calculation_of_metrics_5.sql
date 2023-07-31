-- Для каждого дня, представленного в таблице user_actions, рассчитайте следующие показатели:

-- 1) Общее число заказов.
-- 2) Число первых заказов (заказов, сделанных пользователями впервые).
-- 3) Число заказов новых пользователей (заказов, сделанных пользователями в тот же день, когда они впервые воспользовались сервисом).
-- 4) Долю первых заказов в общем числе заказов (долю п.2 в п.1).
-- 5) Долю заказов новых пользователей в общем числе заказов (долю п.3 в п.1).
-- Колонки с показателями назовите соответственно orders, first_orders, new_users_orders, first_orders_share, new_users_orders_share. 
-- Колонку с датами назовите date. 
-- Проследите за тем, чтобы во всех случаях количество заказов было выражено целым числом. 
-- Все показатели с долями необходимо выразить в процентах. При расчёте долей округляйте значения до двух знаков после запятой.

-- Результат должен быть отсортирован по возрастанию даты.

-- Поля в результирующей таблице: date, orders, first_orders, new_users_orders, first_orders_share, new_users_orders_share

SELECT * ,
       round(first_orders::decimal / orders * 100, 2) as first_orders_share ,
       round(new_users_orders::decimal / orders * 100, 2) as new_users_orders_share
FROM   (SELECT time::date as date,
               count(order_id) as orders
        FROM   user_actions
        WHERE  order_id not in (SELECT order_id
                                FROM   user_actions
                                WHERE  action = 'cancel_order')
        GROUP BY time::date
        ORDER BY date) as total_ord_by_date join (SELECT min as date,
                                                 count(user_id) as first_orders
                                          FROM   (SELECT user_id,
                                                         min(date)
                                                  FROM   (SELECT time::date as date,
                                                                 user_id
                                                          FROM   user_actions
                                                          WHERE  order_id not in (SELECT order_id
                                                                                  FROM   user_actions
                                                                                  WHERE  action = 'cancel_order')) t
                                                  GROUP BY user_id) as t
                                          GROUP BY min) as frst_ords using (date) join (SELECT l.date,
                                                     coalesce(sum(ord_cnt), 0)::int as new_users_orders
                                              FROM   (SELECT user_id,
                                                             min(time::date) as date
                                                      FROM   user_actions
                                                      GROUP BY user_id
                                                      ORDER BY date, user_id) l
                                                  LEFT JOIN (SELECT user_id,
                                                                    time::date as date,
                                                                    count(order_id) filter (WHERE order_id not in (SELECT order_id
                                                                                                            FROM   user_actions
                                                                                                            WHERE  action = 'cancel_order')) as ord_cnt
                                                             FROM   user_actions
                                                             GROUP BY user_id, time::date
                                                             ORDER BY date, user_id) r using (date, user_id)
                                              GROUP BY l.date) nw_usr_ord using (date)