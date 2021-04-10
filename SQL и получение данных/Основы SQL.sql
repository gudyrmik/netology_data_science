Join'ы не имеют никакого отношения к первичным или внешним ключам.
join = inner join
cross join - декартово произведение
Записывается или через cross join или select * from tbl1, tbl2;

1. Выведите список названий всех фильмов и их языков (таблица languages).

select f.title, l."name" 
from film f
left join language l on l.language_id = f.language_id;

1.1 Выведите все фильмы и их категории.

select f.title, c."name"
from film f
left join film_category fc on fc.film_id = f.film_id
left join category c on c.category_id = fc.category_id;

on fc.film_id = f.film_id можно записать через using(film_id)

2. Выведите список всех актеров, снимавшихся в фильме Lambs Cancinatti (film_id = 508).

select f.title, a.first_name, a.last_name
from film f
left join film_actor fa on fa.film_id = f.film_id
left join actor a on a.actor_id = fa.actor_id
where f.film_id = 508;

2.1 Выведите все магазины из города Woodridge (city_id = 576).

select s.store_id, a.postal_code, c2.country, a.address
from store s
left join address a using(address_id)
left join city c using(city_id)
left join country c2 using(country_id)
where c.city_id = 576;

3. Подсчитайте количество актеров в фильме Grosse Wonderful (film_id = 384).

select count(fa.actor_id)
from film f
left join film_actor fa on fa.film_id = f.film_id
left join actor a on a.actor_id = fa.actor_id
where f.film_id = 384;

3.1 Подсчитайте среднюю стоимость аренды за день по всем фильмам.

select avg(rental_rate/rental_duration)
from film f;

4. Выведите список фильмов, в которых снималось более 10 актеров

select f.film_id, f.title, count(fa.actor_id)
from film f
left join film_actor fa using(film_id)
group by film_id
having count(fa.actor_id) > 10;

4.1 Выведите список категорий фильмов, средняя продолжительность аренды которых более 5 дней

select c."name", avg(f.rental_duration)
from film f
left join film_category fc using(film_id)
left join category c using(category_id)
group by c.category_id
having avg(f.rental_duration) > 5;

5. Выведите количество фильмов, со стоимостью аренды за день больше, чем среднее значение по всем фильмам

select count(f.film_id) 
from film f
where f.rental_rate/f.rental_duration > (select avg(rental_rate/rental_duration) from film f);

6. Выведите фильмы, с категорией начинающейся с буквы "С"

select f.title
from film f
left join film_category fc using(film_id)
left join category c using(category_id)
where c.category_id in (
  select c.category_id
  from category c
  where c."name" ilike 'c%'
); -- 0.9ms

6.1 Выведите фильмы, с категорией начинающейся с буквы "С", но используйте данные подзапроса в условии фильтрации

select f.title, c."name" 
from film f
inner join film_category fc using(film_id)
inner join category c on fc.category_id = c.category_id and c.category_id in (
  select c.category_id
  from category c
  where c."name" ilike 'c%'
); -- 0.8ms

или

select f.title, cat."name"
from (select c.category_id, c.name from category c where c."name" ilike 'c%') as cat
left join film_category fc using(category_id)
left join film f using(film_id); -- 0.5ms

7. Выведите таблицу с 3я полями: название фильма, имя актера и количество фильмов в которых он снимался

select f.title, a.first_name, a.last_name, count(fa.film_id) over (partition by fa.actor_id)
from film f
left join film_actor fa using(film_id)
left join actor a using(actor_id);

(partition by val1, val2, val3) - можно группировать по нескольким столбцам
