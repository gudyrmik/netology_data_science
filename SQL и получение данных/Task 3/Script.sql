create table language(
  id serial primary key,
  lang varchar(20) unique not null,
  created_on timestamp
)

create table nationality(
  id serial primary key,
  nation varchar(20) unique not null,
)

create table country(
  id serial primary key
  name title varchar(20) unique not null
);

create table lang_nation(
  lang_id integer foreign key references language(id)
  nation_id integer foreign key references nationality(id)
  primary key(lang_id, nation_id)
);

create table country_nation(
  country_id integer foreign key references country(id)
  nation_id integer foreign key references nationality(id)
  primary key(country_id, nation_id)
);

insert into country(title) values 'Russia';
insert into country(title) values 'USA'
insert into country(title) values 'France';
insert into country(title) values 'Germany'
insert into country(title) values 'Xen';

insert into nationality values 'Russian'
insert into nationality values 'American'
insert into nationality values 'France'
insert into nationality values 'Germany'
insert into nationality values 'Alien'

insert into language values 'Russian'
insert into language values 'English'
insert into language values 'French'
insert into language values 'Deutsch'
insert into language values 'Bul-bul-lang'

insert into lang_nation(lang_id, nation_id) values
  (select id from language where lang = 'Russian'),
  (select id from nationality where nation = 'Russia');
insert into lang_nation(lang_id, nation_id) values
  (select id from language where lang = 'English'),
  (select id from nationality where nation = 'American');
insert into lang_nation(lang_id, nation_id) values
  (select id from language where lang = 'French'),
  (select id from nationality where nation = 'France');
insert into lang_nation(lang_id, nation_id) values
  (select id from language where lang = 'Deutsch'),
  (select id from nationality where nation = 'Germany');
insert into lang_nation(lang_id, nation_id) values
  (select id from language where lang = 'Bul-bul-lang'),
  (select id from nationality where nation = 'Alien');

insert into country_nation(country_id, nation_id) values
  (select id from country where name = 'Russia'),
  (select id from nationality where nation = 'Russian');
insert into country_nation(country_id, nation_id) values
  (select id from country where name = 'USA'),
  (select id from nationality where nation = 'American');
insert into country_nation(country_id, nation_id) values
  (select id from country where name = 'France'),
  (select id from nationality where nation = 'France');
insert into country_nation(country_id, nation_id) values
  (select id from country where name = 'Germany'),
  (select id from nationality where nation = 'Germany');
insert into country_nation(country_id, nation_id) values
  (select id from country where name = 'Xen'),
  (select id from nationality where nation = 'Alien');