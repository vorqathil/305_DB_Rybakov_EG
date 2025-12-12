insert into users (name, email, gender, register_date, occupation)
values ('Пшеницына Полина Алексеевна', 'pshenitsyna@gmail.com', 'female', current_date, 'student');

insert into users (name, email, gender, register_date, occupation)
values ('Пяткин Игорь Алексеевич', 'pyatkin@gmail.com', 'male', current_date, 'student');

insert into users (name, email, gender, register_date, occupation)
values ('Рыбаков Евгений Геннадьевич', 'rybakov@gmail.com', 'male', current_date, 'student');

insert into users (name, email, gender, register_date, occupation)
values ('Рыжкин Владислав Дмитриевич', 'ryzhkin@gmail.com', 'male', current_date, 'student');

insert into users (name, email, gender, register_date, occupation)
values ('Рябченко Александра Станиславовна', 'ryabchenko@gmail.com', 'female', current_date, 'student');

insert into movies (title, year)
values ('Люди Икс', 2000);

insert into movie_genres (movie_id, genre_id)
select m.id, g.id 
from movies m, genres g 
where m.title = 'Люди Икс' and g.name = 'Action';

insert into movies (title, year)
values ('Мстители', 2012);

insert into movie_genres (movie_id, genre_id)
select m.id, g.id 
from movies m, genres g 
where m.title = 'Мстители' and g.name = 'Action';

insert into movies (title, year)
values ('Люди в черном', 1997);

insert into movie_genres (movie_id, genre_id)
select m.id, g.id 
from movies m, genres g 
where m.title = 'Люди в черном' and g.name = 'Sci-Fi';

insert into ratings (user_id, movie_id, rating, timestamp)
select 
    (select id from users where email = 'pshenitsyna@gmail.com'),
    (select id from movies where title = 'Люди Икс'),
    5.0,
    extract(epoch from current_timestamp);

insert into ratings (user_id, movie_id, rating, timestamp)
select 
    (select id from users where email = 'pshenitsyna@gmail.com'),
    (select id from movies where title = 'Мстители'),
    5.0,
    extract(epoch from current_timestamp);

insert into ratings (user_id, movie_id, rating, timestamp)
select 
    (select id from users where email = 'pshenitsyna@gmail.com'),
    (select id from movies where title = 'Люди в черном'),
    5.0,
    extract(epoch from current_timestamp);