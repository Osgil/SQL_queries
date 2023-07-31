-- Дополните запрос из предыдущего задания и теперь для каждого дня, представленного в таблицах user_actions и courier_actions, 
-- дополнительно рассчитайте следующие показатели:

-- 1) Прирост числа новых пользователей.
-- 2) Прирост числа новых курьеров.
-- 3) Прирост общего числа пользователей.
-- 4) Прирост общего числа курьеров.
-- Показатели, рассчитанные на предыдущем шаге, также включите в результирующую таблицу.

-- Колонки с новыми показателями назовите соответственно new_users_change, new_couriers_change, total_users_growth, 
-- total_couriers_growth. Колонку с датами назовите date.

-- Все показатели прироста считайте в процентах относительно значений в предыдущий день. 
-- При расчёте показателей округляйте значения до двух знаков после запятой.

-- Результирующая таблица должна быть отсортирована по возрастанию даты.

-- Поля в результирующей таблице: 

-- date, new_users, new_couriers, total_users, total_couriers, 

-- new_users_change, new_couriers_change, total_users_growth, total_couriers_growth

SELECT date,
       new_users,
       new_couriers,
       total_users,
       total_couriers,
       round(new_users::decimal / lag(new_users) OVER (ORDER BY date) * 100 - 100,
             2) as new_users_change,
       round(new_couriers::decimal / lag(new_couriers) OVER (ORDER BY date) * 100 - 100,
             2) as new_couriers_change,
       round(total_users::decimal / lag(total_users) OVER (ORDER BY date) * 100 - 100,
             2) as total_users_growth,
       round(total_couriers::decimal / lag(total_couriers) OVER (ORDER BY date) * 100 - 100,
             2) as total_couriers_growth
FROM   (SELECT min_time as date,
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
                                      GROUP BY min_time) as r using (min_time)) as t) as final_table