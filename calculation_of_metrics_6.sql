-- На основе данных в таблицах user_actions, courier_actions и orders для каждого дня рассчитайте следующие показатели:

-- Число платящих пользователей на одного активного курьера.
-- Число заказов на одного активного курьера.
-- Колонки с показателями назовите соответственно users_per_courier и orders_per_courier. Колонку с датами назовите date. 
-- При расчёте показателей округляйте значения до двух знаков после запятой.

-- Результирующая таблица должна быть отсортирована по возрастанию даты.

-- Поля в результирующей таблице: date, users_per_courier, orders_per_courier

select
  date,
  round(users_count :: decimal / cours_count, 2) as users_per_courier,
  round(orders_count :: decimal / cours_count, 2) as orders_per_courier
from
  (
    (
      select
        creation_time :: date as date,
        count(order_id) as orders_count
      from
        orders
      where
        order_id not in (
          select
            order_id
          from
            user_actions
          where
            action = 'cancel_order'
        )
      group by
        creation_time :: date
    ) total_ord
    join (
      select
        time :: date as date,
        count(DISTINCT user_id) as users_count
      from
        user_actions
      where
        order_id not in (
          select
            order_id
          from
            user_actions
          where
            action = 'cancel_order'
        )
      group by
        time :: date
    ) pay_user using (date)
    join (
      select
        time :: date as date,
        count(DISTINCT courier_id) as cours_count
      from
        courier_actions
      where
        order_id not in (
          select
            order_id
          from
            user_actions
          where
            action = 'cancel_order'
        )
      group by
        time :: date
    ) active_cour using (date)
  ) as t