-- На основе данных в таблице courier_actions для каждого дня рассчитайте, за сколько минут в среднем курьеры доставляли свои заказы.

-- Колонку с показателем назовите minutes_to_deliver. Колонку с датами назовите date. 
-- При расчёте среднего времени доставки округляйте количество минут до целых значений. 
-- Учитывайте только доставленные заказы, отменённые заказы не учитывайте.

-- Результирующая таблица должна быть отсортирована по возрастанию даты.

-- Поля в результирующей таблице: date, minutes_to_deliver

SELECT date,
       avg(time_deliver)::int as minutes_to_deliver
FROM   (SELECT order_id,
               time::date as date,
               action,
               extract(epoch
        FROM   time - lag(time)
        OVER (
        PARTITION BY order_id
        ORDER BY time)) / 60 as time_deliver
        FROM   courier_actions
        WHERE  order_id not in (SELECT order_id
                                FROM   user_actions
                                WHERE  action = 'cancel_order')) t
WHERE  time_deliver is not null
GROUP BY date
ORDER BY date