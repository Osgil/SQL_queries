-- Для каждого дня, представленного в таблицах user_actions и courier_actions, рассчитайте следующие показатели:

-- 1) Число платящих пользователей.
-- 2) Число активных курьеров.
-- 3) Долю платящих пользователей в общем числе пользователей на текущий день.
-- 4) Долю активных курьеров в общем числе курьеров на текущий день.
-- 5) Колонки с показателями назовите соответственно paying_users, active_couriers, paying_users_share, active_couriers_share. 
-- 6) Колонку с датами назовите date. Проследите за тем, чтобы абсолютные показатели были выражены целыми числами. 
-- 7) Все показатели долей необходимо выразить в процентах. При их расчёте округляйте значения до двух знаков после запятой.

-- Результат должен быть отсортирован по возрастанию даты. 

-- Поля в результирующей таблице: date, paying_users, active_couriers, paying_users_share, active_couriers_share

-- Пояснение: 

-- Платящими будем считать тех пользователей, которые в данный день оформили хотя бы один заказ, который в дальнейшем не был отменен.

-- Курьеров будем считать активными, если в данный день они приняли хотя бы один заказ, который был доставлен (возможно, уже на следующий день), 
-- или доставили любой заказ.

with total_usr_cour as (SELECT date,
                               sum(usr_count) OVER (ORDER BY date)::int as total_users,
                               sum(crs_count) OVER (ORDER BY date)::int as total_couriers
                        FROM   (SELECT date,
                                       count(courier_id) crs_count
                                FROM   (SELECT courier_id,
                                               min(time::date) as date
                                        FROM   courier_actions
                                        GROUP BY courier_id) as crs_by_date
                                GROUP BY date) as user_t join (SELECT date,
                                                              count(user_id) usr_count
                                                       FROM   (SELECT user_id,
                                                                      min(time::date) as date
                                                               FROM   user_actions
                                                               GROUP BY user_id) as usr_by_date
                                                       GROUP BY date) as crs_t using (date))
                        -- order by date)
SELECT date,
       paying_users,
       active_couriers,
       round(paying_users::decimal / total_users * 100, 2) as paying_users_share,
       round(active_couriers::decimal / total_couriers * 100, 2) as active_couriers_share
FROM   ((SELECT date,
                count(distinct user_id) as paying_users
         FROM   (SELECT time::date as date,
                        user_id
                 FROM   user_actions
                 WHERE  order_id not in (SELECT order_id
                                         FROM   user_actions
                                         WHERE  action = 'cancel_order')) as usr_by_date
         GROUP BY date
         ORDER BY date) as paying_users join (SELECT date,
                                            count(distinct courier_id) as active_couriers
                                     FROM   (SELECT time::date as date,
                                                    courier_id,
                                                    order_id
                                             FROM   courier_actions
                                             WHERE  (action = 'accept_order'
                                                and order_id in (SELECT order_id
                                                              FROM   courier_actions
                                                              WHERE  action = 'deliver_order'))
                                                 or action = 'deliver_order') as active_cour
                                     GROUP BY date) as active_couriers using (date)) as pay_active join (SELECT *
                                                                    FROM   total_usr_cour) as total using (date)

