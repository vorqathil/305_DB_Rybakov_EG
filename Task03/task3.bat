#!/bin/bash

echo "Инициализация базы данных..."
/opt/homebrew/opt/postgresql@18/bin/psql -U postgres -d movies_rating -f db_init.sql -q

echo ""
echo "1. Составить список фильмов, имеющих хотя бы одну оценку. Список фильмов отсортировать по году выпуска и по названиям. В списке оставить первые 10 фильмов."
echo "--------------------------------------------------"
/opt/homebrew/opt/postgresql@18/bin/psql -U postgres -d movies_rating -c "
select distinct m.title, m.year from movies as m
	inner join ratings as r on m.id = r.movie_id
order by m.year, m.title
limit 10;
"
echo ""

echo "2. Вывести список всех пользователей, фамилии (не имена!) которых начинаются на букву 'A'. Полученный список отсортировать по дате регистрации. В списке оставить первых 5 пользователей."
echo "--------------------------------------------------"
/opt/homebrew/opt/postgresql@18/bin/psql -U postgres -d movies_rating -c "
select name, register_date from users
where name like '% A%'
order by register_date
limit 5;
"
echo ""

echo "3. Написать запрос, возвращающий информацию о рейтингах в более читаемом формате: имя и фамилия эксперта, название фильма, год выпуска, оценка и дата оценки в формате ГГГГ-ММ-ДД. Отсортировать данные по имени эксперта, затем названию фильма и оценке. В списке оставить первые 50 записей."
echo "--------------------------------------------------"
/opt/homebrew/opt/postgresql@18/bin/psql -U postgres -d movies_rating -c "
select u.name, m.title, m.year, r.rating, to_char(to_timestamp(r.timestamp), 'yyyy-mm-dd') from ratings as r
	join users as u on u.id = r.user_id
	join movies as m on m.id = r.movie_id
order by u.name, m.title, r.rating
limit 50;
"
echo ""

echo "4. Вывести список фильмов с указанием тегов, которые были им присвоены пользователями. Сортировать по году выпуска, затем по названию фильма, затем по тегу. В списке оставить первые 40 записей."
echo "--------------------------------------------------"
/opt/homebrew/opt/postgresql@18/bin/psql -U postgres -d movies_rating -c "
select m.title, t.tag from movies as m
	join tags as t on m.id = t.movie_id
order by m.year, m.title, t.tag
limit 40;
"
echo ""

echo "5. Вывести список самых свежих фильмов. В список должны войти все фильмы последнего года выпуска, имеющиеся в базе данных. Запрос должен быть универсальным, не зависящим от исходных данных (нужный год выпуска должен определяться в запросе, а не жестко задаваться)."
echo "--------------------------------------------------"
/opt/homebrew/opt/postgresql@18/bin/psql -U postgres -d movies_rating -c "
select title, year from movies
where year = (select year from movies where year > 0 order by year desc limit 1);
"
echo ""

echo "6. Найти все драмы, выпущенные после 2005 года, которые понравились женщинам (оценка не ниже 4.5). Для каждого фильма в этом списке вывести название, год выпуска и количество таких оценок. Результат отсортировать по году выпуска и названию фильма."
echo "--------------------------------------------------"
/opt/homebrew/opt/postgresql@18/bin/psql -U postgres -d movies_rating -c "
select m.title, m.year, count(r.rating) from ratings as r
	join movies as m on r.movie_id = m.id
	join users as u on r.user_id = u.id
group by m.title, m.year, u.gender, r.rating
having u.gender = 'female' and r.rating >= 4.5;
"
echo ""

echo "7. Провести анализ востребованности ресурса - вывести количество пользователей, регистрировавшихся на сайте в каждом году. Найти, в каких годах регистрировалось больше всего и меньше всего пользователей."
echo "--------------------------------------------------"
/opt/homebrew/opt/postgresql@18/bin/psql -U postgres -d movies_rating -c "
select substring(register_date,1,4) as year, count(*) as cnt from users
group by year
having count(*) = (select count(*) from users group by substring(register_date,1,4) order by count limit 1)
or count(*) = (select count(*) from users group by substring(register_date,1,4) order by count desc limit 1);
"
echo ""