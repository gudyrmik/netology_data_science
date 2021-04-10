1. Выведите таблицу с 3мя полями: название фильма, имя актера и количество фильмов, в которых он снимался.

select f.title, a.first_name, count(fa.film_id) over (partition by fa.actor_id) 
from film f
left join film_actor fa using(film_id)
left join actor a using (actor_id);

1.1. Выведите таблицу, содержащую имена покупателей, арендованные ими фильмы и средний платеж каждого покупателя.

select c.last_name, f.title, avg(p.amount) over (partition by c.customer_id),
sum(p.amount) over (partition by c.customer_id),
max(p.amount) over (partition by c.customer_id),
min(p.amount) over (partition by c.customer_id),
p.payment_date, p.amount,
sum(p.amount) over (partition by c.customer_id order by p.payment_date) -- накопительный итог
from customer c
left join payment p using(customer_id)
left join rental r using(customer_id)
left join inventory i using(inventory_id)
left join film f using(film_id)

Если нужно условие для оконной функции, нужно использовать CTE

select c.customer_id, p.payment_id , p.amount,
lag(p.amount) over (partition by c.customer_id),  -- предыдущее значение
lead(p.amount) over (partition by c.customer_id), -- следующее значение
lead(p.amount) over (partition by c.customer_id) - lag(p.amount) over (partition by c.customer_id)
from customer c 
left join payment p using(customer_id);

2. При помощи CTE выведите таблицу со следующим содержанием:
Фамилия и имя сотрудника (staff) и количество прокатов двд (rental), которые он продал.

with staff_rental as(
select s.last_name, r.rental_id, s.staff_id
from staff s 
left join rental r using(staff_id))
select sr.last_name, count(sr.rental_id)
from staff_rental sr
group by sr.staff_id, sr.last_name;

2.1 Вывести фильмы, с категорией начинающейся с буквы 'с'.

with cat as(
  select c.category_id, c."name" 
  from category c 
  where c."name" ilike 'c%')
select f.title, c."name" 
from cat c
left join film_category fc using(category_id)
left join film f using(film_id)

with cat as(
  select c.category_id, c.name
  from category c
  where c."name" ilike 'c%'),
fil_cat as(
  select f.title, fc.category_id
  from film_category fc
  left join film f using(film_id))
select fc.title, c."name" 
from cat c
left join fil_cat fc using(category_id)

1) создаем CTE
2) делаем выборку из CTE

3. Вычислите факториал

with recursive r as (
  -- стартовая часть, anchor
  select
    1 as i,
    1 as factorial
  union
    -- рекурсивная часть
  select 
    i + 1 as i,
    factorial  * (i + 1) as factorial
  from r
  where i < 10
)
select *
from r;

3.1. Вычислите числа Фибоначчи

with recursive r(a, b) as (
  values(0, 1)
  union all
  select greatest(a, b), a + b as a
  from r
  where b < 15
)
select a
from r;


with recursive r as (
  select count(*) as total, 1 as i
  from film_actor fa
  where fa.film_id < 10
  union
  select total - (select count(*) from film_actor fa where fa.film_id = i), i + 1 as i
  from r
  where i < 10
)
select *
from r;

4. Создайте view с колонками клиент(ФИО, емейл и title фильма, который он брал в прокат последним

create view rent as
  with task_1 as (
    select *, row_number() over (partition by customer_id order by rental_date desc)
    from rental r
  )
  select c.last_name, f.title
  from task_1 t
  left join customer c using(customer_id)
  left join inventory i using(inventory_id)
  left join film f using(film_id)
  where t.row_number = 1 -- последний прокат

select * from rent;

4.1 Создайте представление с 3я полями: название фильма, имя актера и количество фильмов, в которых он снимался.

create view act as 
  select f.title, a.first_name, count(fa.film_id) over (partition by fa.actor_id) 
  from film f
  left join film_actor fa using(film_id)
  left join actor a using (actor_id);

select * from act;

5. Создайте материализованное представление с колонками клиент (ФИО, емейл) и title фильма, который он брал в прокат последним.

create materialized view rent_1 as
  with task_1 as (
    select *, row_number() over (partition by customer_id order by rental_date desc)
    from rental r
  )
  select c.last_name, f.title
  from task_1 t
  left join customer c using(customer_id)
  left join inventory i using(inventory_id)
  left join film f using(film_id)
  where t.row_number = 1 -- последний прокат
with no data;

refresh materialized view rent_1;
  
select * from rent_1;

5.1. Создайте наполненное метариализованное представление, содержащее:
список категорий фильмов, средняя продолжительность аренды которых более 5 дней

create materialized view rent_2 as
  select c."name"   
  from film f
  left join film_category fc using(film_id)
  left join category c using(category_id)
  group by c.category_id 
  having avg(f.rental_duration) > 5
with data;

select * from rent_2;