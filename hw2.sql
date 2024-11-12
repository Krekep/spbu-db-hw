CREATE TABLE student_courses (
	id SERIAL PRIMARY KEY, 
	student_id INT, 
	course_id INT, 
	UNIQUE (student_id, course_id)
);

CREATE TABLE group_courses (
	id SERIAL PRIMARY KEY, 
	group_id INT, 
	course_id INT, 
	UNIQUE (group_id, course_id)
);

--------------------------------------------------

INSERT INTO
	student_courses (student_id, course_id)
VALUES
	(1, 1),
	(1, 2),
	(2, 1),
	(3, 2);

--- по прошлому тз не было связей между группами и курсами
INSERT INTO
	group_courses (group_id, course_id)
VALUES
	(1, 1),
	(1, 2),
	(2, 2);

--------------------------------------------------

ALTER TABLE students
DROP COLUMN IF EXISTS courses_ids;

--- по тз нет таблицы groups_students, поэтому решил оставить массив студентов в группе
-- alter table groups  
-- drop column if exists student_ids;
-- добавление уникального ограничения на имя курса
ALTER TABLE courses ADD CONSTRAINT unique_course_name UNIQUE (course_name);

--------------------------------------------------

-- индексы предназначены для ускорения поиска по таблице
-- недостатки: требует доп. памяти, для маленьких таблиц не актуален, т.к. быстрее без индекса просмотреть, при добавлении данных надо перестраивать индекс
--------------
-- как работает индекс --- по указанным столбцам строится некоторая структура данных (по умолчанию b-tree вроде бы, ещё есть колоночные, хэш индексы и т.д.)
-- по умолчанию используется некластерный индекс, он хранится отдельно от таблицы и определяет только логический порядок данных (не влияет на физический порядок размещения)
-- ускорение достигается поиском ключа в индексе, т.е. в дереве поиска, что работает быстрее, чем линейный проход по всем данным
-- при использовании unique и primary key создаются неявные индексы
CREATE INDEX idx_students_group_id ON
students(group_id);

--------------------------------------------------------------------

-- запрос показывающий курсы и студентов на них
SELECT sc.id, c.course_name, s.id, s.first_name, s.last_name, s.group_id
	FROM student_courses sc
	JOIN courses c ON
		sc.course_id = c.id -- инф-а о курсах
	JOIN students s ON
		sc.student_id = s.id -- инф-а о студентах
LIMIT 20;

-- запрос возвращающий студентов, у average оценка по курсам выше, чем у остальных в их группе
WITH student_courses_avg AS (  -- таблица со средней оценкой каждого студента
	SELECT 
		sc.student_id AS student_id, 
		AVG(gc.grade) AS avg_grade
	FROM student_courses sc
	JOIN grades gc ON sc.course_id = gc.course_id
	AND sc.student_id = gc.student_id
	GROUP BY sc.student_id
), student_max_grade AS ( -- возвращает маскимальную из средних оценок студентов для каждой группы
	SELECT 
		MAX(sca.avg_grade) AS max_group_grade, 
		g.id AS group_id
	FROM student_courses_avg sca
	CROSS JOIN "groups" g
	JOIN students s ON sca.student_id = s.id AND s.group_id = g.id
	GROUP BY g.id
)
SELECT 
	sc.student_id, 
	c.course_name, 
	sca.avg_grade, 
	smg.max_group_grade, 
	s.first_name, 
	s.last_name,
	s.group_id, 
	g.full_name
FROM student_courses sc
JOIN courses c ON sc.course_id = c.id -- инф-а о курсах
JOIN students s ON sc.student_id = s.id -- инф-а о студентах
JOIN group_courses gc ON gc.course_id = sc.course_id -- id групп записанных на курс
JOIN "groups" g ON g.id = gc.group_id AND s.group_id = g.id	-- инф-а о группах
JOIN student_courses_avg sca ON sca.student_id = s.id -- средняя оценка для каждого студента
JOIN student_max_grade smg ON smg.group_id = g.id -- максимальная средняя оценка для каждой группы
WHERE sca.avg_grade >= smg.max_group_grade -- студенты у которых средняя оценка по курсам не ниже максимальной в их группе (т.е. выше чем у других студентов)
LIMIT 20;

-------------------------------------------------------------------

SELECT 
	sc.course_id, 
	c.course_name, 
	AVG(gc.grade) AS avg_grade, 
	COUNT(sc.student_id)
FROM student_courses sc
JOIN grades gc ON sc.course_id = gc.course_id AND sc.student_id = gc.student_id
JOIN courses c ON sc.course_id = c.id -- инф-а о курсах
GROUP BY sc.course_id, c.course_name
LIMIT 20;
