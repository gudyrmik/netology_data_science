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

alter table books add constraint books_author_fkey foreign key (author_id) references author(id)

4. Обновите данные, проставив корректное место рождения писателю:
- Жюль Габриэль Верн - Франция
- Михаил Юрьевич Лермонтов - Российская Империя
- Харуки Мураками - Япония