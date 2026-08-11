select u.id,u.name,count(o.id) as order_count from users u left join orders o on o.user_id=u.id where u.active=true group by u.id,u.name order by order_count desc;
