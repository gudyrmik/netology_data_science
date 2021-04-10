select *, row_number() over (partition by customer_id order by rental_date) as number from rental;

create materialized view unique_users as
select distinct customer_id from rental
inner join inventory using(inventory_id)
inner join film using(film_id)
where array_position(film.special_features, 'Behind the Scenes') > 0
with data;

refresh materialized view unique_users;

select * from unique_users;


три варианта условия для поиска Behind the Scenes:
 - where array_position(film.special_features, 'Behind the Scenes') > 0
 - where film.special_features[1] like 'Behind the Scenes' or film.special_features[2] like 'Behind the Scenes' (понимаю что вариант плохой, но в нашем кейсе ж рабочий:))
 - where film.special_features && '{Behind the Scenes}'::text[];