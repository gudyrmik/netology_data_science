1. Создайте таблицу "автор" с полями:
- id
- имя
- псевдоним (может и не быть)

create table author (
  id serial primary key,
  author_name varchar(50) not null,
  nick_name varchar(50),
  birth_date date not null
);

varchar по дефолту имеет длинну 255

1* Создайте таблицу "Произведения" с полями:
- id произведения
- год
- название
- id автора

create table books (
  id serial primary key,
  book_name varchar(100) not null,
  book_year int2 not null check(book_year > 0 and book_year < 2100),
  author_id int
);

smallint = int2: -32768 до 32767
int = int4: -2147483648 до +2147483647
bigint = int8: -9223372036854775808 до +9223372036854775807

2. Вставьте данные по 3м любым писателям в таблицу авторов:
- Жюль Габриэль Верн, 08.02.1828
- Михаил Юрьевич Лермонтов, 03.10.1814
- Харуки Мураками, 12.01.1949

insert into author (author_name, nick_name, birth_date)
values
('Жюль Габриэль Верн', null, '08.02.1828'),
('Михаил Юрьевич Лермонтов', 'Гр. Диарбекир', '03.10.1814'),
('Харуки Мураками', null, '12.01.1949');

2.1 Вставьте данные по 5 любым произведениям, id автора заполните null

insert into books (book_name, book_year, author_id)
values
('Двадцать тысяч льё под водой', 1916, null),
('Бородино', 1837, null),
('Герой нашего времени', 1840, null),
('Норвежский лес', 1980, null),
('Хроники заводной птицы', 1994, null);

3. Добавьте поле "место рождения" в таблицу авторов

alter table author add column birth_place varchar(50);

3* В таблице произведений измените колонку id автора - внешний ключ - ссылка на таблица авторов

alter table books add constraint books_author_fkey foreign key (author_id) references author(id);

4. Обновите данные, проставив корректное место рождения писателю:
- Жюль Габриэль Верн - Франция
- Михаил Юрьевич Лермонтов - Российская Империя
- Харуки Мураками - Япония

update author
set birth_place = 'Франция'
where id = 1;

update author
set birth_place = 'Российская Империя'
where id = 2;

update author
set birth_place = 'Япония'
where id = 3;

update books 
set author_id = (select id from author where extract(year from birth_date) = 1814)
where id in (select id from books where book_year < 1900);

4* В таблице произведений поставьте id авторов:
- Жюль Габриэль Верн:
  Двадцать тысяч льё под водой
- Михаил Юрьевич Лермонтов:
  Бородино
  Герой нашего времени
- Харуки Мураками:
  Норвежский лес
  Хроники заводной птицы

update books
set author_id = 1
where id = 1;

update books
set author_id = 3
where id in (4, 5);

5. Удалите произведение "Двадцать тысяч льё под водой"

delete from books
where id = 1;

select * from books; -- посмотреть

5* Попробуйте удалить писателя Харуки Мурками, удалите писателя Жюль Габриэль Верн

delete from author 
where id = 3;

select * from author;

drop table books;
drop table author;


============json===============
Создайте таблицу orders

create table orders (
  id serial not null primary key,
  info json not null
);

insert into orders (info)
values
('{ "customer": "John Doe", "items": {"product": "Beer","qty": 6}}'),
('{ "customer": "Lilly Bush", "items": {"product": "Diaper","qty": 24}}'),
('{ "customer": "John Williams", "items": {"product": "Toy Car","qty": 1}}'),
('{ "customer": "Mark Clark", "items": {"product": "Toy Train","qty": 2}}');
select * from orders;

6. Выведите общее количество заказов:
# -> возвращает json
# ->> возвращает текст

select info -> 'customer'
from orders;

select info -> 'items' -> 'product'
from orders;

select sum((info -> 'items' ->> 'qty')::int)
from orders;

6* Выведите среднее количество заказов, продуктов начинающихся на "Toy".

select avg((info -> 'items' ->> 'qty')::int)
from orders
where (info -> 'items' ->> 'product') like 'Toy%';

7. Выведите сколько раз встречается атрибут (special_feature) у фильма

* array_length(array, level) - возвразает длину указанной размерности массива

select pg_typeof(special_features) from film;
select array_length(special_features, 1) from film;

7* Выведите все фильмы содержащие специальные атрибуты: 'Trailers', 'Commentaries':
* используйте операторы:
@> - содержит
<@ - содержится в

select title, special_features
from film
where special_features @> array ['Trailers', 'Commentaries'];

или

select title, special_features
from film
where 'Trailers' = any(special_features);