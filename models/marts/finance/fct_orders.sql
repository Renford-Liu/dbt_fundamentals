with orders as (
    select * from {{ ref('stg_jaffle_shop__orders') }}
),

payments as (
    select * from {{ ref('stg_stripe__payments') }}
),

order_payment as (
    select 
        order_id,
        sum(case when status ='success' then amount end) as amount
    from payments
    group by 1
),

final as (
    select 
        o.order_id,
        o.customer_id,
        o.order_date,
        op.amount 
    from orders o
    left join order_payment op on o.order_id = op.order_id

)

select * from final