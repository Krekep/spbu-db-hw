create table student_courses (
	id serial primary key,
 	student_id int,
  	course_id int,
 	unique (student_id, course_id)
);

create table group_courses (
	id serial primary key,
	group_id int,
	course_id int,
	unique (group_id, course_id)
);


--------------------------------------------------

insert into student_courses (student_id, course_id) values
	(1, 1), 
	(1, 2),
	(2, 1),
	(3, 2);


--- по прошлому тз не было связей между группами и курсами
insert into group_courses (group_id, course_id) values
	(1, 1), 
	(1, 2), 
	(2, 2);

--------------------------------------------------

alter table students
drop column if exists courses_ids;

--- по тз нет таблицы groups_students, поэтому решил оставить массив студентов в группе
-- alter table groups  
-- drop column if exists student_ids;

-- добавление уникального ограничения на имя курса
alter table courses add constraint unique_course_name unique (course_name);

--------------------------------------------------

-- индексы предназначены для ускорения поиска по таблице
-- недостатки: требует доп. памяти, для маленьких таблиц не актуален, т.к. быстрее без индекса просмотреть, при добавлении данных надо перестраивать индекс
--------------
-- как работает индекс --- по указанным столбцам строится некоторая структура данных (по умолчанию b-tree вроде бы, ещё есть колоночные, хэш индексы и т.д.)
-- по умолчанию используется некластерный индекс, он хранится отдельно от таблицы и определяет только логический порядок данных (не влияет на физический порядок размещения)
-- ускорение достигается поиском ключа в индексе, т.е. в дереве поиска, что работает быстрее, чем линейный проход по всем данным
-- при использовании unique и primary key создаются неявные индексы
create index idx_students_group_id on students(group_id);

--------------------------------------------------------------------

-- запрос показывающий курсы и студентов на них
select sc.id, c.course_name, s.id, s.first_name, s.last_name, s.group_id from student_courses sc 
	join courses c on sc.course_id = c.id  -- инф-а о курсах
	join students s on sc.student_id = s.id  -- инф-а о студентах 

-- запрос возвращающий студентов, у average оценка по курсам выше, чем у остальных в их группе
with student_courses_avg as (  -- таблица со средней оценкой каждого студента
  select 
    sc.student_id as student_id,
    avg(gc.grade) as avg_grade
  from student_courses sc
  join grades gc on sc.course_id = gc.course_id and sc.student_id = gc.student_id 
  group by sc.student_id
), student_max_grade as (
	select 
		max(sca.avg_grade) as max_group_grade, 
		g.id as group_id
	from student_courses_avg sca -- возвращает маскимальную из средних оценок студентов для каждой группы
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


select 
    sc.course_id,
    c.course_name,
    avg(gc.grade) as avg_grade,
    count(sc.student_id)
  from student_courses sc
  join grades gc on sc.course_id = gc.course_id and sc.student_id = gc.student_id 
  join courses c on sc.course_id = c.id  -- инф-а о курсах
  group by sc.course_id, c.course_name 
