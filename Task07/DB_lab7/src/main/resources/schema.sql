CREATE TABLE IF NOT EXISTS groups (
    id BIGSERIAL PRIMARY KEY,
    group_number VARCHAR(20) NOT NULL UNIQUE,
    program VARCHAR(255) NOT NULL,
    graduation_year INTEGER NOT NULL
);

CREATE TABLE IF NOT EXISTS students (
    id BIGSERIAL PRIMARY KEY,
    last_name VARCHAR(100) NOT NULL,
    first_name VARCHAR(100) NOT NULL,
    middle_name VARCHAR(100),
    gender VARCHAR(10) NOT NULL,
    birth_date DATE NOT NULL,
    student_card_number VARCHAR(20) NOT NULL UNIQUE,
    group_id BIGINT NOT NULL,
    FOREIGN KEY (group_id) REFERENCES groups(id)
);