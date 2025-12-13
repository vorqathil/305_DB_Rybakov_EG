CREATE TABLE IF NOT EXISTS groups (
    id SERIAL PRIMARY KEY,
    group_number VARCHAR(20) UNIQUE NOT NULL
);

CREATE TABLE IF NOT EXISTS specializations (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL
);

CREATE TABLE IF NOT EXISTS subjects (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    specialization_id INTEGER REFERENCES specializations(id),
    year_of_study INTEGER NOT NULL
);

CREATE TABLE IF NOT EXISTS students (
    id SERIAL PRIMARY KEY,
    last_name VARCHAR(50) NOT NULL,
    first_name VARCHAR(50) NOT NULL,
    middle_name VARCHAR(50),
    group_id INTEGER REFERENCES groups(id),
    gender VARCHAR(10) NOT NULL,
    specialization_id INTEGER REFERENCES specializations(id),
    enrollment_year INTEGER NOT NULL
);

CREATE TABLE IF NOT EXISTS exam_results (
    id SERIAL PRIMARY KEY,
    student_id INTEGER REFERENCES students(id) ON DELETE CASCADE,
    subject_id INTEGER REFERENCES subjects(id),
    exam_date DATE NOT NULL,
    grade INTEGER NOT NULL CHECK (grade >= 2 AND grade <= 5)
);