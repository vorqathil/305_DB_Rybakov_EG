#!/bin/bash

echo "Инициализация базы данных..."
PGPASSWORD="postgres" /opt/homebrew/opt/postgresql@18/bin/psql -U postgres -d movies_rating -f db_init.sql -q

echo ""
echo "1. Найти все пары пользователей, оценивших один и тот же фильм. Устранить дубликаты, проверить отсутствие пар с самим собой. Для каждой пары должны быть указаны имена пользователей и название фильма, который они ценили. В списке оставить первые 100 записей"
echo "--------------------------------------------------"
PGPASSWORD="postgres" /opt/homebrew/opt/postgresql@18/bin/psql -U postgres -d movies_rating -c "select 
    u1.name as user1_name,
    u2.name as user2_name,
    m.title as movie_title
from ratings r1
join ratings r2 on r1.movie_id = r2.movie_id and r1.user_id < r2.user_id
join users u1 on r1.user_id = u1.id
join users u2 on r2.user_id = u2.id
join movies m on r1.movie_id = m.id
limit 100;"
echo ""

echo "2. Найти 10 самых старых оценок от разных пользователей, вывести названия фильмов, имена пользователей, оценку, дату отзыва в формате ГГГГ-ММ-ДД"
echo "--------------------------------------------------"
PGPASSWORD="postgres" /opt/homebrew/opt/postgresql@18/bin/psql -U postgres -d movies_rating -c "select distinct on (r.user_id)
    m.title as movie_title,
    u.name as user_name,
    r.rating,
    to_char(to_timestamp(r.timestamp), 'YYYY-MM-DD') as review_date
from ratings r
join users u on r.user_id = u.id
join movies m on r.movie_id = m.id
order by r.user_id, r.timestamp
limit 10;"
echo ""

echo "3. Вывести в одном списке все фильмы с максимальным средним рейтингом и все фильмы с минимальным средним рейтингом. Общий список отсортировать по году выпуска и названию фильма. В зависимости от рейтинга в колонке 'Рекомендуем' для фильмов должно быть написано 'Да' или 'Нет'"
echo "--------------------------------------------------"
PGPASSWORD="postgres" /opt/homebrew/opt/postgresql@18/bin/psql -U postgres -d movies_rating -c "with avg_ratings as (
    select 
        movie_id,
        avg(rating) as avg_rating
    from ratings
    group by movie_id
),
max_min_ratings as (
    select 
        max(avg_rating) as max_rating,
        min(avg_rating) as min_rating
    from avg_ratings
)
select 
    m.title,
    m.year,
    ar.avg_rating,
    case 
        when ar.avg_rating = mmr.max_rating then 'Да'
        when ar.avg_rating = mmr.min_rating then 'Нет'
    end as \"Рекомендуем\"
from avg_ratings ar
join movies m on ar.movie_id = m.id
cross join max_min_ratings mmr
where ar.avg_rating = mmr.max_rating or ar.avg_rating = mmr.min_rating
order by m.year, m.title;"
echo ""

echo "4. Вычислить количество оценок и среднюю оценку, которую дали фильмам пользователи-мужчины в период с 2011 по 2014 год"
echo "--------------------------------------------------"
PGPASSWORD="postgres" /opt/homebrew/opt/postgresql@18/bin/psql -U postgres -d movies_rating -c "select 
    count(r.rating) as count_ratings,
    avg(r.rating) as avg_rating
from ratings r
join users u on r.user_id = u.id
where u.gender = 'male'
    and extract(year from to_timestamp(r.timestamp)) between 2011 and 2014;"
echo ""

echo "5. Составить список фильмов с указанием средней оценки и количества пользователей, которые их оценили. Полученный список отсортировать по году выпуска и названиям фильмов. В списке оставить первые 20 записей"
echo "--------------------------------------------------"
PGPASSWORD="postgres" /opt/homebrew/opt/postgresql@18/bin/psql -U postgres -d movies_rating -c "select 
    m.title,
    m.year,
    avg(r.rating) as avg_rating,
    count(distinct r.user_id) as user_count
from movies m
join ratings r on m.id = r.movie_id
group by m.id, m.title, m.year
order by m.year, m.title
limit 20;"
echo ""

echo "6. Определить самый распространенный жанр фильма и количество фильмов в этом жанре. Отдельную таблицу для жанров не использовать, жанры нужно извлекать из таблицы movies"
echo "--------------------------------------------------"
PGPASSWORD="postgres" /opt/homebrew/opt/postgresql@18/bin/psql -U postgres -d movies_rating -c "with genres_split as (
    select 
        trim(regexp_split_to_table(genres, '\|')) as genre
    from movies
    where genres is not null
)
select 
    genre,
    count(*) as movie_count
from genres_split
group by genre
order by movie_count desc
limit 1;"
echo ""

echo "7. Вывести список из 10 последних зарегистрированных пользователей в формате 'Фамилия Имя|Дата регистрации' (сначала фамилия, потом имя)"
echo "--------------------------------------------------"
PGPASSWORD="postgres" /opt/homebrew/opt/postgresql@18/bin/psql -U postgres -d movies_rating -c "select 
    name || '|' || register_date as user_info
from users
order by register_date desc
limit 10;"
echo ""

echo "8. С помощью рекурсивного CTE определить, на какие дни недели приходился ваш день рождения в каждом году"
echo "--------------------------------------------------"
PGPASSWORD="postgres" /opt/homebrew/opt/postgresql@18/bin/psql -U postgres -d movies_rating -c "with recursive birthday_years as (
    select 
        2004 as year,
        to_date('2004-11-04', 'YYYY-MM-DD') as birthday_date
    union all
    select 
        year + 1,
        to_date((year + 1)::text || '-11-04', 'YYYY-MM-DD')
    from birthday_years
    where year < 2025
)
select 
    year,
    to_char(birthday_date, 'Day') as day_of_week,
    to_char(birthday_date, 'YYYY-MM-DD') as date
from birthday_years
order by year;"
echo ""

echo "Все задания выполнены!"