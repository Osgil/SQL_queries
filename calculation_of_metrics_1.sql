-- Для каждого дня, представленного в таблицах user_actions и courier_actions, рассчитайте следующие показатели:

-- Число новых пользователей.
-- Число новых курьеров.
-- Общее число пользователей на текущий день.
-- Общее число курьеров на текущий день.
-- Колонки с показателями назовите соответственно new_users, new_couriers, total_users, total_couriers. Колонку с датами назовите date. 
-- Проследите за тем, чтобы показатели были выражены целыми числами. Результат должен быть отсортирован по возрастанию даты.

-- Поля в результирующей таблице: date, new_users, new_couriers, total_users, total_couriers

SELECT min_time as date,
       usr_count as new_users,
       couriers_count as new_couriers,
       sum(usr_count) OVER (ORDER BY min_time)::int as total_users,
       sum(couriers_count) OVER (ORDER BY min_time)::int as total_couriers
FROM   ((SELECT min_time,
                count(user_id) as usr_count
         FROM   (SELECT user_id,
                        min(time::date) min_time
                 FROM   user_actions
                 GROUP BY user_id) as usr_table
         GROUP BY min_time) as l join (SELECT min_time,
                                     count(courier_id) as couriers_count
                              FROM   (SELECT courier_id,
                                             min(time::date) as min_time
                                      FROM   courier_actions
                                      GROUP BY courier_id
                                      ORDER BY min_time) as cour_tbl
                              GROUP BY min_time) as r using (min_time)) as t