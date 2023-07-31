# SQL_queries
## __Расчеты продуктовых метрик с помощью запросов на SQL, СУБД POSTGRESQL.__

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
 
