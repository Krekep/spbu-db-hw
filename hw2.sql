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

INSERT INTO student_courses (student_id, course_id) VALUES
	(1, 1), 
	(1, 2),
	(2, 1),
	(3, 2);


--- По прошлому ТЗ не было связей между группами и курсами
INSERT INTO group_courses (group_id, course_id) VALUES
	(1, 1), 
	(1, 2), 
	(2, 2);

--------------------------------------------------

ALTER TABLE students
DROP COLUMN IF EXISTS courses_ids;

--- По ТЗ нет таблицы groups_students, поэтому решил оставить массив студентов в группе
-- ALTER TABLE groups  
-- DROP COLUMN IF EXISTS student_ids;

-- Добавление уникального ограничения на имя курса
ALTER TABLE courses ADD CONSTRAINT unique_course_name UNIQUE (course_name);

--------------------------------------------------

-- Индексы предназначены для ускорения поиска по таблице
-- Недостатки: требует доп. памяти, для маленьких таблиц не актуален, т.к. быстрее без индекса просмотреть, при добавлении данных надо перестраивать индекс
--------------
-- Как работает индекс --- по указанным столбцам строится некоторая структура данных (по умолчанию B-Tree вроде бы, ещё есть колоночные, хэш индексы и т.д.)
-- По умолчанию используется некластерный индекс, он хранится отдельно от таблицы и определяет только логический порядок данных (не влияет на физический порядок размещения)
-- Ускорение достигается поиском ключа в индексе, т.е. в дереве поиска, что работает быстрее, чем линейный проход по всем данным
-- При использовании UNIQUE и PRIMARY KEY создаются неявные индексы
CREATE INDEX idx_students_group_id ON students(group_id);

--------------------------------------------------------------------

-- Запрос показывающий курсы и студентов на них
select sc.id, c.course_name, s.id, s.first_name, s.last_name, s.group_id from student_courses sc 
	join courses c on sc.course_id = c.id  -- инф-а о курсах
	join students s on sc.student_id = s.id  -- инф-а о студентах 

-- Запрос возвращающий студентов, у average оценка по курсам выше, чем у остальных в их группе
WITH student_courses_avg AS (  -- таблица со средней оценкой каждого студента
  SELECT 
    sc.student_id AS student_id,
    AVG(gc.grade) AS avg_grade
  FROM student_courses sc
  JOIN grades gc ON sc.course_id = gc.course_id AND sc.student_id = gc.student_id 
  GROUP BY sc.student_id
), student_max_grade as (
	select 
		max(sca.avg_grade) as max_group_grade, 
		g.id as group_id
	FROM student_courses_avg sca -- возвращает маскимальную из средних оценок студентов для каждой группы
		cross join "groups" g
		join students s on sca.student_id = s.id and s.group_id = g.id 
	group by g.id
)
select 
		sc.student_id, 
		c.course_name, 
		sca.avg_grade,
		smg.max_group_grade,
		s.first_name, 
		s.last_name, 
		s.group_id, 
		g.full_name
	from student_courses sc 
	join courses c on sc.course_id = c.id  -- инф-а о курсах
	join students s on sc.student_id = s.id  -- инф-а о студентах
	join group_courses gc on gc.course_id = sc.course_id  -- id групп записанных на курс
	join "groups" g on g.id  = gc.group_id and s.group_id = g.id -- инф-а о группах
	join student_courses_avg sca on sca.student_id = s.id  -- средняя оценка для каждого студента
	join student_max_grade smg on smg.group_id = g.id -- максимальная средняя оценка для каждой группы
where sca.avg_grade >= smg.max_group_grade -- студенты у которых средняя оценка по курсам не ниже максимальной в их группе (т.е. выше чем у других студентов)
;


-------------------------------------------------------------------


SELECT 
    sc.course_id,
    c.course_name,
    AVG(gc.grade) AS avg_grade,
    count(sc.student_id)
  FROM student_courses sc
  JOIN grades gc ON sc.course_id = gc.course_id AND sc.student_id = gc.student_id 
  join courses c on sc.course_id = c.id  -- инф-а о курсах
  GROUP BY sc.course_id, c.course_name 
