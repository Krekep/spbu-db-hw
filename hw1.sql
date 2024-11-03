CREATE TABLE courses (
  id SERIAL PRIMARY KEY,
  course_name VARCHAR(255) NOT NULL,
  is_exam BOOLEAN DEFAULT FALSE,
  min_grade DECIMAL(5,2) DEFAULT 0.00,
  max_grade DECIMAL(5,2) DEFAULT 100.00
);

CREATE TABLE groups (
  id SERIAL PRIMARY KEY,
  full_name VARCHAR(255) NOT NULL,
  short_name VARCHAR(50) NOT NULL,
  students_ids JSON
);

CREATE TABLE students (
  id SERIAL PRIMARY KEY,
  first_name VARCHAR(100) NOT NULL,
  last_name VARCHAR(100) NOT NULL,
  group_id INT,
  FOREIGN KEY (group_id) REFERENCES groups(id),
  courses_ids JSON
);

CREATE TABLE grades (
  course_id SERIAL,
  student_id SERIAL,
  grade DECIMAL(5,2),
  grade_str VARCHAR(20),
  FOREIGN KEY (student_id) REFERENCES students(id),
  FOREIGN KEY (course_id) REFERENCES courses(id),
  CHECK (grade IS NULL OR grade >= 0)
);

----------------------------------------------------------------------

INSERT INTO courses (course_name, is_exam, min_grade, max_grade) VALUES 
('Математика', TRUE, 60.00, 100.00),
('Информатика', FALSE, 40.00, 90.00);

INSERT INTO groups (full_name, short_name) VALUES 
('Группа А', 'A'),
('Группа Б', 'B');

INSERT INTO students (first_name, last_name, group_id) VALUES 
('Иван', 'Иванов', 1),
('Петр', 'Петров', 1),
('Сидор', 'Сидоров', 2);

INSERT INTO grades (course_id, student_id, grade, grade_str) VALUES 
(1, 1, 85.00, 'Отлично'),
(2, 1, 70.00, 'Удовлетворительно'),
(1, 2, 92.00, 'Отлично');

----------------------------------------------------------------------

SELECT 
  groups.full_name AS Группа,
  AVG(g.grade) AS Средняя оценка,
  COUNT(DISTINCT g.student_id) AS Количество студентов
FROM grades g
JOIN students s ON g.student_id = s.id
JOIN groups ON s.group_id = groups.id 
GROUP BY groups.full_name
HAVING AVG(g.grade) > 70;