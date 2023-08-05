-- На основе данных в таблице orders для каждого часа в сутках рассчитайте следующие показатели:

-- Число успешных (доставленных) заказов.
-- Число отменённых заказов.
-- Долю отменённых заказов в общем числе заказов (cancel rate).
-- Колонки с показателями назовите соответственно successful_orders, canceled_orders, cancel_rate. 
-- Колонку с часом оформления заказа назовите hour. При расчёте доли отменённых заказов округляйте значения до трёх знаков после запятой.

-- Результирующая таблица должна быть отсортирована по возрастанию колонки с часом оформления заказа.

-- Поля в результирующей таблице: hour, successful_orders, canceled_orders, cancel_rate


select
    hour,
    successful_orders,
    canceled_orders,
    round(canceled_orders::decimal / total_orders, 3) as cancel_rate
from
(select
    DATE_PART('hour', creation_time)::int as hour,
    count(order_id) as total_orders,
    count(order_id) filter (where order_id not in (select order_id from user_actions where action = 'cancel_order')) as successful_orders,
    count(order_id) filter (where order_id in (select order_id from user_actions where action = 'cancel_order')) as canceled_orders
from orders
group by DATE_PART('hour', creation_time)::int) t