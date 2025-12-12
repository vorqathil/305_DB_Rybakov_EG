-- Таблица работников (кадровый учет)
create table employees (
    id serial primary key,
    full_name varchar(255) not null,
    phone varchar(20),
    hire_date date not null,
    fire_date date, -- NULL если работает
    salary_percent numeric(5,2) not null check(salary_percent > 0 and salary_percent <= 100)
);

-- Таблица услуг (справочник)
create table services (
    id serial primary key,
    name varchar(255) not null,
    duration_minutes integer not null check(duration_minutes > 0),
    price numeric(10,2) not null check(price >= 0)
);

-- Таблица записей к мастеру
create table appointments (
    id serial primary key,
    employee_id integer not null,
    client_name varchar(255) not null,
    client_phone varchar(20) not null,
    appointment_datetime timestamp not null,
    status varchar(20) not null default 'scheduled' check(status in ('scheduled', 'completed', 'cancelled')),
    foreign key (employee_id) references employees(id)
);

-- Таблица услуг в записи (связь многие-ко-многим)
create table appointment_services (
    id serial primary key,
    appointment_id integer not null,
    service_id integer not null,
    foreign key (appointment_id) references appointments(id) on delete cascade,
    foreign key (service_id) references services(id)
);

-- Таблица выполненных работ
create table completed_works (
    id serial primary key,
    employee_id integer not null,
    service_id integer not null,
    completion_datetime timestamp not null,
    price numeric(10,2) not null check(price >= 0), -- цена на момент выполнения
    foreign key (employee_id) references employees(id),
    foreign key (service_id) references services(id)
);

-- Индексы для оптимизации запросов
create index idx_appointments_employee on appointments(employee_id);
create index idx_appointments_datetime on appointments(appointment_datetime);
create index idx_completed_works_employee on completed_works(employee_id);
create index idx_completed_works_datetime on completed_works(completion_datetime);

-- Тестовые данные

-- Работники (2 работающих, 1 уволенный)
insert into employees (full_name, phone, hire_date, fire_date, salary_percent) values
('Иванов Иван Иванович', '+79001234567', '2023-01-15', null, 25. 0),
('Петров Петр Петрович', '+79009876543', '2023-03-20', null, 30.0),
('Сидоров Сидор Сидорович', '+79005555555', '2022-06-10', '2024-11-30', 20.0);

-- Услуги
insert into services (name, duration_minutes, price) values
('Замена масла', 30, 1500.00),
('Диагностика двигателя', 60, 2000.00),
('Замена тормозных колодок', 90, 3500.00),
('Шиномонтаж (4 колеса)', 45, 2500.00),
('Развал-схождение', 60, 2800.00),
('Замена воздушного фильтра', 15, 800.00);

-- Записи к мастерам
insert into appointments (employee_id, client_name, client_phone, appointment_datetime, status) values
(1, 'Алексеев Алексей', '+79111111111', '2025-12-15 10:00:00', 'scheduled'),
(1, 'Борисов Борис', '+79222222222', '2025-12-15 14:00:00', 'scheduled'),
(2, 'Васильев Василий', '+79333333333', '2025-12-16 09:00:00', 'scheduled'),
(1, 'Григорьев Григорий', '+79444444444', '2025-12-10 11:00:00', 'completed'),
(2, 'Дмитриев Дмитрий', '+79555555555', '2025-12-11 15:00:00', 'completed'),
(3, 'Егоров Егор', '+79666666666', '2024-10-05 10:00:00', 'completed');

-- Услуги в записях
insert into appointment_services (appointment_id, service_id) values
(1, 1), -- Алексеев:  замена масла
(1, 6), -- Алексеев: замена фильтра
(2, 4), -- Борисов: шиномонтаж
(3, 2), -- Васильев: диагностика
(3, 3), -- Васильев: тормозные колодки
(4, 1), -- Григорьев: замена масла
(5, 5), -- Дмитриев: развал-схождение
(6, 3), -- Егоров: тормозные колодки (уволенный мастер)
(6, 4); -- Егоров: шиномонтаж

-- Выполненные работы
insert into completed_works (employee_id, service_id, completion_datetime, price) values
-- Работы текущих сотрудников
(1, 1, '2025-12-10 11:30:00', 1500.00),
(1, 6, '2025-12-10 11:45:00', 800.00),
(2, 5, '2025-12-11 16:00:00', 2800.00),
(1, 1, '2025-12-12 10:30:00', 1500.00),
(1, 2, '2025-12-12 14:00:00', 2000.00),
(2, 4, '2025-12-13 11:00:00', 2500.00),
-- Работы уволенного сотрудника (данные сохранены)
(3, 3, '2024-10-05 11:30:00', 3500.00),
(3, 4, '2024-10-05 13:15:00', 2500.00),
(3, 1, '2024-11-15 09:30:00', 1500.00);