-- Для каждого дня, представленного в таблице user_actions, рассчитайте следующие показатели:

-- Долю пользователей, сделавших в этот день всего один заказ, в общем количестве платящих пользователей.
-- Долю пользователей, сделавших в этот день несколько заказов, в общем количестве платящих пользователей.
-- Колонки с показателями назовите соответственно single_order_users_share, several_orders_users_share. 
-- Колонку с датами назовите date. Все показатели с долями необходимо выразить в процентах. 
-- При расчёте долей округляйте значения до двух знаков после запятой.

-- Результат должен быть отсортирован по возрастанию даты.

-- Поля в результирующей таблице: date, single_order_users_share, several_orders_users_share

with total_payment_usr as (SELECT date,
                                  count(distinct user_id) as pay_usr
                           FROM   (SELECT time::date as date,
                                          user_id
                                   FROM   user_actions
                                   WHERE  order_id not in (SELECT order_id
                                                           FROM   user_actions
                                                           WHERE  action = 'cancel_order')) as t
                           GROUP BY date)
SELECT date,
       round(single_order::decimal / pay_usr * 100, 2) as single_order_users_share,
       round(several_order::decimal / pay_usr * 100, 2) as several_orders_users_share
FROM   (SELECT date,
               count(orders_count) filter(WHERE orders_count = 1) as single_order,
               count(orders_count) filter(WHERE orders_count != 1) as several_order
        FROM   (SELECT time::date as date,
                       user_id,
                       count(order_id) as orders_count
                FROM   user_actions
                WHERE  order_id not in (SELECT order_id
                                        FROM   user_actions
                                        WHERE  action = 'cancel_order')
                GROUP BY time::date, user_id) as t
        GROUP BY date) as payment join (SELECT *
                                FROM   total_payment_usr) total_usr using (date)