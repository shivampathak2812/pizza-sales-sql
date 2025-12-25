-- Basic SQL
use pizza_sales;
select * from orders;
select * from orders where year(order_date)=2015;
select name, category from pizza_types;
select order_id, order_time, order_date from orders;
select count(order_id) from orders;
select order_id, order_date from orders; 

-- Where , And, Or
select price from pizzas where size>10;
select pizza_id, size from pizzas where size="L";
select name, category from pizza_types where category="Chicken";
select order_id, order_date from orders where year(order_date)=2015;
select price, pizza_id from pizzas where price between 8 and 15;

-- Join 
select order_id, pizza_id, quantity from order_details;
select o.order_id, o.order_date, pt.name, od.quantity from 
orders o join order_details od  on o.order_id=od.order_id
join pizzas p on od.pizza_id=p.pizza_id 
join pizza_types pt on p.pizza_type_id=pt.pizza_type_id; 

select pt.name, p.size, p.price from pizza_types pt
join pizzas p on pt.pizza_type_id=p.pizza_type_id;

select od.order_details_id, pt.name , pt.category from order_details od
join orders o using(order_id) 
join pizzas p using(pizza_id)
join pizza_types pt using(pizza_type_id); 

select o.*, od.order_details_id from orders o 
left join order_details od using(order_id);

select p.*, pt.name, pt.category from pizza_types pt
left join pizzas p using(pizza_type_id); 

select od.order_id, od.quantity, pt.name as pizza_name from order_details od
join pizzas p using(pizza_id)
join pizza_types pt using(pizza_type_id);

	select od.*, o.*, pt.*, p.* from order_details od
	join orders o on od.order_id=o.order_id
	join pizzas p on od.pizza_id=p.pizza_id
	join pizza_types pt on pt.pizza_type_id=p.pizza_type_id;

-- aggregate function
select count(order_id) as number_of_order from  order_details;
select count(quantity) as quantity_of_orderedpizza from order_details;
select avg(price) as average_price from pizzas;
select max(price) as maximum_price from pizzas;
select min(price) as minimum_price from pizzas;

-- group by & having
select pizza_id , sum(quantity) as total_quantity from order_details group by pizza_id;
select sum(price) as total_sales, pizza_id from pizzas group by pizza_id;
select count(size) as size_of_pizzas , pizza_id from pizzas group by pizza_id, size; 
select count(pizza_type_id) , category from pizza_types group by category having count(pizza_type_id) > 5;

-- order and limit
select price , size from pizzas order by price desc;
select price, pizza_id from pizzas order by price desc limit 5;
select o.* from orders o order by o.order_date desc limit 10;
select name, pizza_type_id from pizza_types order by name;
select size, price from pizzas order by price , size;

-- subqueries
select pizza_id, price from pizzas where price > 
(select avg(price) from pizzas);
SELECT 
    pizza_type_id,
    name AS pizza_name
FROM pizza_types
WHERE pizza_type_id NOT IN (
    SELECT pizza_type_id
    FROM pizzas
    WHERE pizza_id IN (
        SELECT pizza_id
        FROM order_details
    )
);

select * from order_Details where quantity >
(select avg(quantity) from order_details);

select p.pizza_id, pt.name as pizza_name , sum(od.quantity) from order_details od
join pizzas p on p.pizza_id= od.pizza_id 
join pizza_types pt on pt.pizza_type_id = p.pizza_type_id
group by p.pizza_id, pt.name 
having sum(od.quantity) = (
select max(total_quan) from (
select sum(quantity) as total_quan
from order_details 
group by pizza_id) as qty_table);