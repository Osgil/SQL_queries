# SQL_queries
## __Расчеты продуктовых метрик с помощью запросов на SQL, СУБД PostgreSQL.__

## __BD schema:__
### __courier_actions:__
* __action: CHARACTER VARYING__
* __courier_id: INTEGER__
* __order_id: INTEGER__
* __time: TIMESTAMP WITHOUT TIME ZONE__
### __couriers:__
* __birth_date: DATE__
* __courier_id: INTEGER__
* __sex: CHARACTER VARYING__
### __orders:__
* __creation_time: TIMESTAMP WITHOUT TIME ZONE__
* __order_id: INTEGER__
* __product_ids: ARRAY__
### __products:__
* __name: CHARACTER VARYING__
* __price: NUMERIC__
* __product_id: INTEGER__
### __user_actions:__
* __action: CHARACTER VARYING__
* __order_id: INTEGER__
* __time: TIMESTAMP WITHOUT TIME ZONE__
* __user_id: INTEGER__
### __users:__
* __birth_date: DATE__
* __sex: CHARACTER VARYING__
* __user_id: INTEGER__

## __Содержание__:
* __calculation_of_metrics_1__ — Расчет числа новых пользователей и курьеров в разрезе дней, подсчет их общего количества накопительным итогом
* __calculation_of_metrics_2__ — То же самое, чир в calculation_of_metrics_1 + расчет прироста для всех метрик
* __calculation_of_metrics_3__ — Расчет количества платящих пользователей и актвивных курьеров в разрезе дней и их доля в общем количестве
* __calculation_of_metrics_4__ — Подсчет пользователей сделавших один или несколько заказов в разрезе дней
* __calculation_of_metrics_5__ — Расчет общего числа заказов, заказов, сделанных пользователями впервые, заказов, сделанных пользователями в тот же день, когда они впервые воспользовались сервисом и их доли в общем количестве по дням
* __window_func_1__ — Рассчет стоимости каждого заказа, ежедневной выручки сервиса и доли стоимости каждого заказа в ежедневной выручке
* __window_func_2__ — Рассчет ежедневной выручки и ее прироста к прошлому дню
* __window_func_3__ — Рассчет медианной выручки без использования quantile
 
