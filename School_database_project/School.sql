/*
Сапронов Ярослав РИ- 430207

Предварительно соствалено задание к КП
+ ER- диаграмма, проектирование бд
************************
2016-10-28
Сапронов Ярослав РИ- 430207
Скрипт создания базы данных "Школа".
В скрипте выполнены следующие действия:
2016-11-01
1) Создана база данных School2
2) Созданы 13 таблиц в базе данных и первичные ключи (затем были созданы еще некоторые таблицы)
  Таблицы:
    1.employees
	2.teachers
	3.service_staff
	4.subjects
	5.marks
	6.quarter_data
	7.learners
	8.classes
	9.schedule
	10.lesson_time
	11.menu
	12.dishes
	13.category_dish
2016-11-03
3) Созданы связи между таблицами, а также внешние и ограничения уникальности
2016-11-04
4) Созданы ограничения на номер телефона сотрудников,
					   Номер телефона сотрудников,
                       Опыт работы учителей >5
					   Возраст учителей от 30 до 55
					   Значение оценки от 1 до 5
2016-11-05
5) Таблицы заполнены данными (insert)
 Наличие как таблиц- справочников. так и таблиц с текущими изменяющимися данными;

6) Написан блок удаления (drop) и delete

2016-11-12
7) Заполнение таблиц данными миллионами записей

2016-11-14
8)Написание отчетов

2016-11-15 
8)Создание процедур

2016-11-19
9) Блок очищения БД

2016-11-25
10)Создание индексов
Заполнение скриптами schedule и dishes большим количеством записей (миллионы) 
 и тестирование на них индексов: сколько времени различные запросы выполняются без индексов, сколько с индексами;
 
2016-12-02
11) Создание триггеров. В частности – «триггеров историй»

2016-12-07
11) Создание истема безопасности – пользователи, роли, разрешения на выполнение хранимых процедур, на доступ к таблицам 

2016-12-23
Создание пояснительной записки

2016-12-24
Установлен sql server enterprise. Перенос всей базы данных из ограниченной версии.
Создание джобов

2016-12-24 : 2016-12-27
Редактирование всех пунктов, исправление ошибок 

select emp.name_emp, d.name_dep, max(emp.salary) as [max_salary] 
  from department as d
    left join employee as emp on d.department_id = emp.department_id
  where (emp.chief_id <> 0)
  group by d.name_dep --emp.name_emp

GO 
*/

--1. Создаем базу данных School2
create database db316
use db316


--2.Создаем в базе данных таблицы
--birthay null для обслуж персонала, а для учителей потом сделаем ограничение в запросе от 30 до 55 возраст обязателен
-- также можно создать соотв триггер для возраста учителей

create table dbo.employees(
  employee_id int not null identity primary key,
  name varchar(60) not null,
  pol varchar(1) not null,
  birthday date null,
  addresss varchar(50) not null,
  functionn varchar(40) not null,
  employee_phone varchar(25) null,
  laid_offf_employee bit not null default 0,

)
GO 

alter table dbo.employees
  add 
  UNIQUE(name)
GO

/*
SELECT year( GETDATE())) -30
declare @a date
@a = GETDATE()
*/
--Ограничение на номер телефона
alter table dbo.employees
  add
  constraint employee_phone_check CHECK ( employee_phone like (replicate('[0-9*#+()-]', len(employee_phone))))
GO 

create table dbo.teachers(
  teacher_id int not null identity primary key,
  employee_id int not null,
  teacher_experience int not null

)
GO 

-- учитель должен иметь уникальный идентификатор работника
alter table dbo.teachers
  add 
  UNIQUE(employee_id)
GO

--Ограничение на опыт работы учителей
alter table dbo.teachers
  add
  constraint teacher_experience_check CHECK (teacher_experience > 5)
GO
/*
ограниение теперь проверяется в триггере
alter table dbo.teachers
  add
  constraint teacher_birthday_check CHECK ( year(teacher_birthday) between year(GETDATE())- 55 and year(GETDATE())- 30)
GO
*/

create table dbo.service_staff(
  staff_id int not null identity primary key,
  employee_id  int not null,
  responsibility varchar(40) null

)
GO

alter table dbo.service_staff
  add 
  UNIQUE(employee_id)
GO

create table dbo.subjects(
  subject_id int not null identity primary key,
  name_sub varchar(50) not null,

)
GO

create table dbo.marks(
  mark_id int not null identity primary key,
  mark_value tinyint not null,
  data date not null,
  learner_id int not null,
  subject_id int not null,
  
)
GO

select * from quarter_data

create table dbo.quarter_data(
  data date not null primary key,
  quarterr tinyint not null,

)
GO

alter table dbo.marks
  add
  constraint mark_value_check CHECK (mark_value between 1 and 5)
GO

create table dbo.learners(
  learner_id int not null identity primary key,
  name varchar(60) not null,
  pol varchar(1) not null,
  birthday date not null,
  addresss varchar(50) not null,
  class_id int not null,
  parent_id int null,

)
GO


alter table dbo.learners
  add 
  UNIQUE(name)
GO


create table dbo.classes(
  class_id int not null identity primary key,
  year_of_education tinyint not null,
  letter varchar(1) not null,
  year_graduation int not null,
  description_class varchar(60) null,

)
GO

create table dbo.schedule(
  schedule_discipline_id int not null identity primary key,
  data date not null,
  day_of_week tinyint not null,
  number_lesson tinyint not null,
  class_id int not null,
  subject_id int not null,
  teacher_id int not null,
  auditorium tinyint not null,
  canceled_lesson bit not null default 0,

)
GO

alter table dbo.schedule
  add
  constraint auditorium_check CHECK (auditorium < 31)
GO

create table dbo.lesson_time(
  number_lesson tinyint not null identity primary key,
  start_lesson time(0) not null,
  end_lesson time(0) not null,

)
GO

create table dbo.menu(
  menu_id int not null identity primary key,
  menu_data date not null,
  responsible_cooker_id int not null, -- берется из таблицы обслуживающего персонала по id
  holiday_menu bit not null default 0

)
GO

alter table dbo.menu
  add 
  UNIQUE(menu_data)
GO

create table dbo.dishes(
  dish_id int not null identity primary key,
  dish_name varchar(50) not null,
  category_dish_id tinyint not null,
  dish_count smallint not null,
  dish_price smallmoney not null,
  menu_id int not null,

)
GO

create table dbo.category_dish(
  category_dish_id tinyint not null identity primary key,
  category_name varchar(30) not null

)
GO

create table dbo.parents(
  parent_id int not null identity primary key,
  name varchar(60) not null,
  pol varchar(1) not null,
  birthday date null,
  parent_phone varchar(25) null,

)
GO

alter table dbo.parents
  add 
  UNIQUE(name)
GO

--3. Создание связей между таблицами

alter table dbo.teachers
  add
  constraint FK_teachers_employee_id foreign key(employee_id)
    references dbo.employees(employee_id)
ON DELETE CASCADE
GO

--ON DELETE CASCADE для сохранения ссылочной целостности при удалении предмета оценки по нему также удалятся
--нужен составной первичный ключ

alter table dbo.service_staff
  add
  constraint FK_service_staff_employee_id foreign key(employee_id)
    references dbo.employees(employee_id)
ON DELETE CASCADE
GO 

alter table dbo.marks
  add
  constraint FK_marks_subject_id foreign key(subject_id)
    references dbo.subjects(subject_id)
GO 

alter table dbo.marks
  add
  constraint FK_marks_learner_id foreign key(learner_id)
    references dbo.learners(learner_id)
GO 

alter table dbo.marks
  add
  constraint FK_marks_mark_data foreign key(data)
    references dbo.quarter_data(data)
GO

alter table dbo.learners
  add
  constraint FK_learners_class_id foreign key(class_id)
    references dbo.classes(class_id)
GO 

alter table dbo.schedule
  add
  constraint FK_schedule_class_id foreign key(class_id)
    references dbo.classes(class_id)
GO 

alter table dbo.schedule
  add
  constraint FK_schedule_subject_id foreign key(subject_id)
    references dbo.subjects(subject_id)
GO 

alter table dbo.schedule
  add
  constraint FK_schedule_teacher_id foreign key(teacher_id)
    references dbo.teachers(teacher_id)
GO 

alter table dbo.schedule
  add
  constraint FK_schedule_number_lesson foreign key(number_lesson)
    references dbo.lesson_time(number_lesson)
GO 

alter table dbo.schedule
  add
  constraint FK_schedule_data foreign key(data)
    references dbo.quarter_data(data)
GO 

alter table dbo.menu
  add
  constraint FK_menu_responsible_cooker_id foreign key(responsible_cooker_id)
    references dbo.service_staff(staff_id)
GO 

alter table dbo.dishes
  add
  constraint FK_dishes_responsible_menu_id foreign key(menu_id)
    references dbo.menu(menu_id)
GO 

alter table dbo.dishes
  add
  constraint FK_dishes_category_dish_id foreign key(category_dish_id)
    references dbo.category_dish(category_dish_id)
GO 

alter table dbo.learners
  add
  constraint FK_learners_parent_id foreign key(parent_id)
    references dbo.parents(parent_id)
GO 

--5.Заполнение таблиц данными


SELECT * FROM teachers
SELECT * FROM classes
SELECT * FROM subjects
SELECT * FROM learners
SELECT * FROM parents
SELECT * FROM schedule
  where teacher_id =31
SELECT * FROM marks
SELECT * FROM employees
SELECT * FROM service_staff
SELECT * FROM dishes
SELECT * FROM menu
GO

SELECT * FROM employees

insert into dbo.employees
(name, pol, birthday, addresss, functionn,employee_phone)
values
  ('Иванова Тамара Ивановна', 'ж', '1972-08-22', 'Попова 27а', 'Учитель начальных классов', '8-922-77-21-448' )

GO

insert into dbo.employees
(name, pol, birthday, addresss, functionn,employee_phone)
values
  ('Павлюк Светлана Юрьевна', 'ж', '1971-09-24', 'Попова 25', 'Директор', '8-912-57-81-972' ),
  ('Соболева Ирина Владимировна', 'ж', '1976-07-04', 'Ленина 8', 'Завуч', '8-906-51-00-912' ),
  ('Захарова Людмила Борисовна', 'ж', '1973-05-16', 'Менделеева 25', 'Завуч', '8-905-15-82-700' )
  
GO

insert into dbo.teachers
(employee_id, teacher_experience ) 
values
	('5',12)

GO


if exists (select * from dbo.sysobjects 
                  where id = object_id(N'dbo.new_teacher_employees')  and objectproperty(id, N'IsProcedure') = 1
               )
   drop procedure dbo.new_teacher_employees
GO
--Условие необходимо для того, чтобы выполнить ограничения учителей по возрасту и не добавлять неподходящие записи,
-- но далее будет создан триггер

create proc dbo.new_teacher_employees
 
  @name varchar(60), 
  @pol varchar(1), 
  @addresss varchar(50),
  @functionn  varchar(40),
  @employee_phone varchar(25),
  @teacher_experience int,
  @teacher_birthday date,
  @help int 
 
AS
 
--if (@teacher_experience > 5) and ( year(@teacher_birthday) between year(GETDATE())- 55 and year(GETDATE())- 30) 
begin
insert into dbo.employees
(name, pol, birthday, addresss, functionn,employee_phone)
values(@name,@pol,@teacher_birthday, @addresss,@functionn,@employee_phone)
 
select @help = SCOPE_IDENTITY()

insert into teachers(employee_id, teacher_experience) 
values
	(@help, @teacher_experience) 
end
--else begin
--print'false'
end
	   
GO

declare @help int   
exec dbo.new_teacher_employees 'Иванова Тамара Ивановна', 'ж', 'Попова 27а', 'Учитель начальных классов', '8-922-77-21-448', 20, '1972-08-22', @help
exec dbo.new_teacher_employees 'Фирсенков Сергей Евгеньевич', 'м', 'Газовиков 6', 'Учитель математики',  '8-912-06-71-428', 12, '1972-08-22', @help
exec dbo.new_teacher_employees 'Луценко Галина Илларионовна', 'ж', 'Азина 12', 'Учитель русского языка и литературы', '8-905-76-71-136', 17, '1963-11-05', @help
exec dbo.new_teacher_employees 'Головина Инна Андреевна', 'ж', 'Азина 47', 'Учитель физики', '8-922-44-71-636', 22, '1965-05-17', @help
exec dbo.new_teacher_employees 'Ганжа Наталья Константиновна', 'ж', 'Гагарина 45', 'Учитель русского языка и литературы', '7-25-59', 15, '1962-07-18', @help
exec dbo.new_teacher_employees 'Семенова Ольга Полиэктовна', 'ж', 'Железгодорожная 77', 'Учитель начальных классов', '8-955-46-72-036', 18, '1964-09-28', @help 
exec dbo.new_teacher_employees 'Ушакова Лидия Петровна', 'ж', 'Гагарина 12', 'Учитель химии', '8-92-77-21-448', 25, '1970-10-28', @help
exec dbo.new_teacher_employees 'Таран Юрий Иванович', 'м', 'Ленина 22', 'Учитель физкультуры', '+7-906-72-31-548', 28, '1963-05-09', @help 
exec dbo.new_teacher_employees 'Гардер Илона Анатольевна', 'ж', 'Лесная 17', 'Учитель изобразительных искусств', '8-912-70-01-008', 8, '1974-01-06', @help 
exec dbo.new_teacher_employees 'Степанова Лидия Петровна', 'ж', 'Железногодорожная 30', 'Учитель начальных классов', '8-855-00-11-03', 12, '1968-03-15', @help 
exec dbo.new_teacher_employees 'Васильева Мария Игоревна', 'ж', 'Коммунистов 20', 'Учитель начальных классов', '8-700-05-11-43', 7, '1975-06-15', @help 
exec dbo.new_teacher_employees 'Маркова Раиса Александровна', 'ж', 'Гагарина 76', 'Учитель начальных классов', '8-895-04-61-87', 19, '1971-06-17', @help 
exec dbo.new_teacher_employees 'Степаненко Юлия Алексеевна', 'ж', 'Коминтерна 11', 'Учитель начальных классов', '8-870-45-81-37', 7, '1978-02-27', @help 
exec dbo.new_teacher_employees 'Морозова Ксения Эдуардовна', 'ж', 'Перевозчиков 2', 'Учитель музыки', '8-895-04-61-88', 12, '1975-06-17', @help 
exec dbo.new_teacher_employees 'Кислицкая Валерия Дмитриевна', 'ж', 'Жукова 8', 'Учитель ИЗО', '8-895-04-62-89', 13, '1977-11-19', @help 
exec dbo.new_teacher_employees 'Платонова Светлана Юрьевна', 'ж', 'Декабристов 15', 'Завуч и учитель руссого языка и литературы', '8-912-05-63-90', 16, '1972-10-14', @help
exec dbo.new_teacher_employees 'Наконечный Анатолий Петрович', 'м', 'Магистерская 14', 'Учитель физкультуры', '8-912-06-64-91', 20, '1966-06-21', @help
exec dbo.new_teacher_employees 'Романова Любовь Владимировна', 'ж', 'Малышева 121', 'Учитель истории и религиозных культур', '8-912-07-65-92', 18, '1968-03-18', @help 
exec dbo.new_teacher_employees 'Николаева Татьяна Александровна', 'ж', 'Комсомольская 72', 'Учитель английского языка', '8-922-08-66-93', 16, '1969-06-01', @help 
exec dbo.new_teacher_employees 'Николаев Владимир Юрьевич', 'м', 'Комсомольская 72', 'Учитель английского языка', '8-922-09-67-94', 16, '1967-05-06', @help
exec dbo.new_teacher_employees 'Шепилов Руслан Михайлович', 'м', 'Первомайская 18', 'Учитель обществознания', '8-922-10-68-95', 15, '1975-06-06', @help 
exec dbo.new_teacher_employees 'Павленко Павел Анатольевич', 'м', 'Луначарского 18', 'Учитель истории', '8-922-11-69-96', 16, '1977-04-12', @help
exec dbo.new_teacher_employees 'Алексеева Мария Викторовна', 'ж', 'Первомайская 5', 'Учитель истории', '8-905-12-69-97', 6, '1980-07-14', @help 
exec dbo.new_teacher_employees 'Иванов Виктор Иванович', 'м', 'Ленина 15', 'Учитель ОБЖ и труда', '8-965-13-70-98', 18, '1966-01-14', @help 
exec dbo.new_teacher_employees 'Иванова Валентина Валентиновна', 'ж', 'Ленина 15', 'Учитель географии', '8-965-13-70-98', 18, '1966-01-14', @help 
exec dbo.new_teacher_employees 'Зайцева Людмила Викторовна', 'ж', 'Ленина 77', 'Учитель биологии', '8-966-14-71-99', 10, '1977-06-11', @help 
exec dbo.new_teacher_employees 'Сотниченко Марина Анатольевна', 'ж', 'Маркова 77', 'Учитель информатики', '8-967-15-72-00', 15, '1973-12-11', @help 
exec dbo.new_teacher_employees 'Комарова Светлана Валерьевна', 'ж', 'Попова 15', 'Учитель информатики', '8-968-16-73-04', 13, '1975-05-11', @help 
exec dbo.new_teacher_employees 'Быков Александр Петрович', 'м', 'Попова 19', 'Учитель математики', '8-969-18-76-06', 17, '1968-01-05', @help 
exec dbo.new_teacher_employees 'Смирнов Виталий Евгеньевич', 'м', 'Космонавтов 7', 'Учитель физики', '8-964-18-76-08', 12, '1970-01-08', @help 
exec dbo.new_teacher_employees 'Габитова Яна Романовна', 'м', 'Мира 18', 'Учитель химии', '8-964-18-77-09', 6, '1981-05-23', @help 



select * from service_staff

if exists (select * from dbo.sysobjects 
                  where id = object_id(N'dbo.new_staff_employees')  and objectproperty(id, N'IsProcedure') = 1
               )
   drop procedure dbo.new_staff_employees
GO

create proc dbo.new_staff_employees
 
  @name varchar(60), 
  @pol varchar(1), 
  @addresss varchar(50),
  @functionn  varchar(40),
  @employee_phone varchar(25),
  @staff_responsibility varchar(40),
  @staff_birthday date,
  @help int
 
AS
 
insert into dbo.employees
(name, pol, birthday, addresss, functionn,employee_phone)
values(@name,@pol, @staff_birthday, @addresss,@functionn,@employee_phone)
 
select @help = SCOPE_IDENTITY()

insert into service_staff(employee_id, responsibility) 
values
	(@help, @staff_responsibility) 
		   
GO

declare @help int
exec dbo.new_staff_employees  'Федоров Валерий Петрович', 'м', 'Новой эры 18', 'Охранник','8-964-18-77-010', null, null, @help
exec dbo.new_staff_employees  'Васильев Игорь Николаевич', 'м', 'Свиридова 12', 'Охранник','8-964-18-77-111', null, null, @help
exec dbo.new_staff_employees  'Бухаров Данил Валерьевич', 'м', 'Чапаева 10', 'Охранник','8-964-18-77-112', null, '1990-12-05', @help
exec dbo.new_staff_employees  'Никифорова Елена Ивановна', 'ж', 'Московская 61', 'Ключница','8-964-18-77-113', 'Записывать преподавателей, берущих и отдающих ключи, а также включать звонки', null, @help
exec dbo.new_staff_employees  'Курнева Наталья Михайловна', 'ж', 'Мичурина 14', 'Медперсонал','8-964-18-77-114', null, null, @help
exec dbo.new_staff_employees  'Горинова Юлия Юрьевна', 'ж', 'Кузнечная 2', 'Уборщица','8-964-18-77-111', null, null, @help
exec dbo.new_staff_employees  'Клинова Татьяна Викторовна', 'ж', 'Тургенева 6', 'Уборщица','8-964-18-77-115', null, null, @help
exec dbo.new_staff_employees  'Шинкарева Людмила Дмитриевна', 'ж', 'Достоевского 4', 'Уборщица','8-964-18-77-116', null, null, @help
exec dbo.new_staff_employees  'Днепровская Татьяна Ивановна', 'ж', 'Летчиков 17', 'Повар','8-964-18-77-117', null, null, @help
exec dbo.new_staff_employees  'Забелина Татьяна Игоревна', 'ж', 'Бебеля 24', 'Повар','8-964-18-77-118', null, null, @help
exec dbo.new_staff_employees  'Калинина Оксана Ильинична', 'ж', 'Халтурина 18', 'Повар','8-964-18-77-119', null, null, @help
exec dbo.new_staff_employees  'Смирнова Марина Юрьевна', 'ж', 'Хохрякова 53', 'Повар','8-964-18-77-120', null, null, @help
--exec dbo.new_staff_employees  'Нурланова Фариза Куанышхановна', 'ж', 'Ленина 63', 'Повар','8-964-18-77-120', null, null, @help
exec dbo.new_staff_employees  'Андреев Александр Александрович', 'м', 'Малышева 150', 'Повар','8-964-18-77-122', null, null, @help

insert subjects
(name_sub)
VALUES
  ('Чистописание'),
  ('Чтение'),
  ('Труд'),
  ('Природоведение'),
  ('Математика'),
  ('Музыка'),
  ('Изобразительное искусство '),
  ('Русский язык'),
  ('Физкультура'),
  ('Основы религиозных культур'),
  ('Иностранный язык'),
  ('Обществознание'),
  ('История'),
  ('Литература'),
  ('Основы безопасности жизнедеятельности (ОБЖ)'),
  ('География'),
  ('Биология'),
  ('Информатика'),
  ('Черчение'),
  ('Геометрия'),
  ('Физика'),
  ('Химия'),
  ('Алгебра'),
  ('Мировая художественная культура');

GO

SET IDENTITY_INSERT dbo.employees off
INSERT INTO [dbo].[employees] (employee_id, name, pol, addresss, functionn,employee_phone) VALUES
  (48, 'Андреев Александр Александрович', 'м', 'Малышева 150', 'Повар','8-964-18-77-122')
GO


SET IDENTITY_INSERT dbo.service_staff off
INSERT INTO dbo.service_staff(staff_id, employee_id, responsibility, staff_birthday) VALUES
  (13,48,null,null)
GO


insert classes
(year_of_education,letter,year_graduation)
VALUES
  (1,'А', 2027),
  (1,'Б', 2027),
  (1,'В', 2027),
  (1,'Г', 2027),
  (2,'А', 2026),
  (2,'Б', 2026),
  (2,'В', 2026),
  (2,'Г', 2026),
  (3,'А', 2025),
  (3,'Б', 2025),
  (3,'В', 2025),
  (3,'Г', 2025),
  (4,'А', 2024),
  (4,'Б', 2024),
  (4,'В', 2024),
  (4,'Г', 2024),
  (5,'А', 2023),
  (5,'Б', 2023),
  (5,'В', 2023),
  (5,'Г', 2023),
  (6,'А', 2022),
  (6,'Б', 2022),
  (6,'В', 2022),
  (6,'Г', 2022),
  (7,'А', 2021),
  (7,'Б', 2021),
  (7,'В', 2021),
  (8,'Б', 2020),
  (8,'В', 2020),
  (9,'Б', 2019),
  (9,'В', 2019),
  (10,'В', 2018),
  (11,'В', 2017)

GO

insert classes
(year_of_education,letter,year_graduation, description_class)
VALUES
   (8,'А', 2020,'Класс с углубленным изучением математики'),
   (9,'А', 2019,'Класс с углубленным изучением физики и математики'),
   (10,'А', 2018,'Класс с углубленным изучением математики'),
   (10,'Б', 2018,'Класс с углубленным изучением химии'),
   (11,'А', 2017,'Класс с углубленным изучением математики'),
   (11,'Б', 2017,'Класс с углубленным изучением английского языка')

GO

select * FROM learners

insert learners
(name, pol, birthday, addresss, class_id, parent_id)
VALUES
  ('Александров Сергей Геннадьевич', 'м', '2009-01-12', 'Мира, 15', 2, 1),
  ('Алексеева Софья Алексеевна', 'ж', '2009-05-12', 'Комсомольская, 12', 2, 2),
  ('Борисов Олег Дмитриевич', 'м', '2009-12-12', 'Тверетина, 14', 2, 3),
  ('Быстрова Софья Александровна', 'ж', '2009-01-22', 'Блюхера, 20', 2, 4),
  ('Васильева Ангелина Геннадьевна', 'ж', '2009-12-15', '8 Марта, 8', 2, 5),
  ('Григорьева Яна Алексеевна', 'ж', '2009-12-12', 'Маяковского, 18', 2, 6),
  ('Дмитриева Анастасия Сергеевна', 'ж', '2009-04-07', 'Пушкина, 12', 2, 7),
  ('Ершова Татьяна Евгеньевна', 'ж', '2009-05-04', 'Гагарина, 10', 2, 8),
  ('Иванов Никита Евгеньевич', 'м', '2009-06-22', 'Первомайская, 1', 2, 9),
  ('Иванов Павел Вячеславович', 'м', '2009-08-17', 'Королева, 12', 2, 10),
  ('Крылова Екатерина Владимировна', 'ж', '2009-08-14', 'Магистральная, 24', 2, 11),
  ('Купцов Николай Андреевич', 'м', '2009-12-13', 'Менделеева 17', 2, 12),
  ('Махминов Никита Вячеславович', 'м', '2009-03-24', 'Студенческая, 11', 2, 13),
  ('Михайлова Виктория Михайловна', 'ж', '2009-01-22', 'Космонавтов, 8', 2, 14),
  ('Мишина Анастасия Николаевна', 'ж', '2009-11-11', 'Степана Разина, 10', 2, 15),
  ('Мишин Кирилл Николаевич', 'м', '2009-04-12', 'Луначарского, 7', 2, 15),
  ('Мокеев Александр Игоревич', 'м', '2009-07-13', 'Вайнера, 13', 2, 16),
  ('Абрамов Ростислав Олегович', 'м', '1998-12-23', ' Серафимы Дерябин0ой,24', 3, 17),
  ('Александров Дмитрий Владимирович', 'м', '1998-11-03', ' Айвазовского, 53', 38, 18),
  ('Астаков Сергей Анатольевич', 'м', '1998-12-15', ' Фронтовых Бригад, 27', 38, 19),
  ('Богданов Александр Евгеньевич', 'м', '1998-11-16', 'Космонавтов, 104', 38, 20),
  ('Бурцев Андрей Васильевич', 'м', '1998-02-13', ' Красноармейская, 82', 38, 21),
  ('Григорьева Юлия Николаевна', 'ж', '1998-08-14', 'Трактовая, 21', 38,22),
  ('Ганин Иван Сергеевич', 'м', '1998-12-25', 'Октябрьская, 6Б', 38, 23),
  ('Гаврилов Максим Юрьевич', 'м', '1998-03-11', 'проспект Победы, 33а ', 38, 24),
  ('Данилова Мария Александровна', 'ж', '1998-03-03', 'Суворова, 24 ', 38, 25),
  ('Дмитриева Елена Валерьевна', 'ж', '1998-04-06', 'Высоцкого,12', 38, 26),
  ('Ерина Екатерина Юрьевна', 'ж', '1998-01-17', 'Таватуйская, 14', 38, 27),
  ('Илеменева Диана Владимировна', 'ж', '1998-02-12', 'Восточная, 35', 38, 28),
  ('Иванова Алена Ивановна', 'ж', '1998-12-03', 'пр. Шварца, 1', 38, 29),
  ('Кудрявцев Никита Игоревич', 'м', '1998-01-06', 'Советская, 6а', 38, 30),
  ('Маклаков Дмитрий Александрович', 'м', '1998-07-12', 'Луначарского, 205', 38, 31),
  ('Моторова Карина Игоревна', 'ж', '1998-11-11', 'Краснолесья, 133', 38, 32),
  ('Наумова Татьяна Александровна', 'ж', '1998-11-15', 'Кривоусова, 18 Б', 38, 33),
  ('Степанова Татьяна Андреевна', 'м', '1998-08-16', 'Осипенко,79', 38, 34),
  ('Поливаев Артем Александрович', 'м', '2009-10-11', 'Пионерская, 32', 21, 35)

GO

insert learners
(name, pol, birthday, addresss, class_id)
VALUES
  ('Семенов Сергей Сергеевич', 'м', '2009-02-11', 'Пушкина, 8', 21),
  ('Паукова Мария Алексеевна', 'ж', '2009-04-10', 'Комсомольская, 80', 21),
  ('Ильсахов Кайс Кудымович', 'м', '2009-01-17', 'Людвига, 11', 21),
  ('Потураева Кристина Игоревна', 'ж', '2009-05-24', 'Мамина-Сибиряка, 2', 21),
  ('Коноплянкина Злата Константиновна', 'ж', '2009-10-19', 'Студенческая, 5', 21),
  ('Елькина Александра Олеговна', 'ж', '2009-01-12', 'Тверетина, 14', 21),
  ('Виноградова Ирина Сергеевна', 'ж', '2009-06-09', 'Дикообразова, 2', 21),
  ('Куприянов Андрей Семенович', 'м', '2009-05-16', 'Гагарина, 10', 21),
  ('Иванов Никита Евгеньевич', 'м', '2009-04-14', 'Первомайская, 15', 21),
  ('Трофимова Ектерина Леонидовна', 'ж', '2009-02-04', 'Сахарова, 4', 21),
  ('Герасимов Леонид Максимович', 'м', '2009-12-10', 'Менделеева 37', 21),
  ('Кригер Артем Александрович', 'м', '2009-02-14', 'Студенческая, 51', 21),
  ('Бурлякова Екатерина Васильевна', 'ж', '2009-05-27', 'Энтузиастов, 18', 21),
  ('Медведюк Алена Сергеевна', 'ж', '2009-03-30', 'Космонавтов, 12', 21),
  ('Роллис Александр Юрьевич', 'м', '2009-01-22', 'Союза Наций, 15', 21),
  ('Соловьев Павел Андреевич', 'м', '2009-04-16', 'Московская, 38', 21)

GO

insert parents
(name, pol)
VALUES
	('Александров Геннадий Валерьевич', 'м'),
	('Алексеев Алексей Федосеевич', 'м'),
	('Борисова Маргарита Сергеевна', 'ж'),
	('Быстров Александр Станиславович', 'м'),
	('Васильева Александра Игоревна', 'ж'),
	('Григорьева Алексей Пантелеймонович', 'м'),
	('Дмитриева Лора Григорьевна', 'ж'),
	('Шубин Виктор Артёмович', 'м'),
	('Мухина Полина Мэлсовна', 'ж'),
	('Медведьев Егор Евгеньевич', 'м'),
	('Смирнова Алевтина Борисовна', 'ж'),
	('Дроздов Ярослав Тихонович', 'м'),
	('Соболева Валерия Аркадьевна', 'ж'),
	('Белоусова Любовь Богдановна', 'ж'),
	('Савельев Евгений Владиславович', 'м'),
	('Белова Ирина Михаиловна', 'ж'),
	('Медведьева Ксения Станиславовна', 'ж'),
	('Воронцов Даниил Мэлорович', 'м'),
	('Владимиров Игорь Авдеевич', 'м'),
	('Гущина Клавдия Данииловна', 'ж'),
	('Орлов Денис Андреевич', 'м'),
	('Одинцов Никита Гордеевич', 'м'),
	('Орехова Лукия Святославовна', 'ж'),
	('Алексеев Вадим Эдуардович', 'м'),
	('Баранов Владислав Дмитрьевич', 'м'),
	('Зайцев Анатолий Георгиевич', 'м'),
	('Воронова Юлия Григорьевна', 'ж'),
	('Потапов Константин Владимирович', 'м'),
	('Архипова Евгения Эдуардовна', 'ж'),
	('Кудрявцев Евгений Станиславович', 'м'),
	('Кириллов Александр Русланович', 'м'),
	('Гордеева Тамара Валентиновна', 'м'),
	('Терентьева Наина Антониновна', 'ж'),
	('Цветков Дмитрий Владимирович', 'м'),
	('Поливаев Александр Александрович', 'м')

GO


declare @i int, @const date, @quarterr int, @data date
set @const = '2013-01-15'
set @i = 1
set @quarterr = null
set @data = @const

--рассчитываем на 4 года
WHILE @i <= 1460
BEGIN
   if ((month(@data) = 01) or (month(@data) = 02)) 
   begin
     set @quarterr = 1 
	end
	  if ((month(@data) = 03) or (month(@data) = 04)) 
   begin
     set @quarterr = 2 
	end
	  if ((month(@data) = 09) or (month(@data) = 10)) 
   begin
     set @quarterr = 3
	end
	 if ((month(@data) = 11) or (month(@data) = 12))
   begin
     set @quarterr = 4
	end

  insert into dbo.quarter_data (data, quarterr)
    values (@data, @quarterr)
  set @i = @i + 1 
  set @quarterr = null
  set @data= DATEADD(day, @i,  @const)
END

--delete  @i int, @const date, @quarterr int, @mark_data date
-- Теперь удалим вс записи null и даты новогодних каникул
--Хотя записи null и так ене добавились в эту таблицу

delete quarter_data
   from quarter_data 
   where (data = null) or ((month(data) = 01) and day(data) between 00 and 14)-- or (month(mark_data) between 05 and 09)

--select * from quarter_data
--select * from marks
delete marks
   from marks


select * from marks
declare @i int, @mark_value tinyint, @data date, @const date, @learner_id int, @subject_id int
set @const = '2013-01-15'
set @data = @const
set @i = 1
set @mark_value = 1
set @learner_id = 1
set @subject_id = 1
--рассчитываем на 4 года
WHILE @i <= 1460
BEGIN
   BEGIN
   BEGIN TRY  
    insert into dbo.marks(mark_value, data, learner_id, subject_id) 
    values (@mark_value, @data, @learner_id, @subject_id ) 
	set @i = @i + 1 
END TRY  
BEGIN CATCH  
    print 'error'
END CATCH

  set @mark_value= 1+(RAND(CHECKSUM(NEWID()))*5)
  set @i = @i + 1 
  set @data = DATEADD(day, @i,  @const)
  set @learner_id =1 + (RAND(CHECKSUM(NEWID()))*(select max(learner_id) from dbo.learners))
  set @subject_id = 1 + (RAND(CHECKSUM(NEWID()))*(select max(subject_id) from dbo.subjects))

END
END

delete marks
   from dbo.marks
   where ((month(data) = 01) and day(data) between 00 and 14) or (month(data) between 05 and 09)

SELECT * FROM learners as lear
   join classes as cl on cl.class_id = lear.class_id

/*
insert marks
(mark_id,mark_value, mark_data, learner_id, subject_id)
VALUES
  (3, 3,'2016-04-20', 12, 2),
  (4, 2,'2016-04-20', 11, 2);

GO
*/

insert dbo.lesson_time
   (start_lesson,end_lesson)
VALUES
   ('08:30:00', '09:10:00'),
   ('09:20:00', '10:00:00'),
   ('10:10:00', '10:50:00'),
   ('11:00:00', '11:40:00'),
   ('12:00:00', '12:40:00'),
   ('12:50:00', '13:30:00'),
   ('13:35:00', '14:10:00')

select * from dbo.schedule

/*Заполнение таблицы расписания миллионом записей. Находим максимальный ID в соответствующих таблицах, по нему делаем Rand для всех 
атрибутов от 1 до max, далее в блоке TRY добавляем запись и увеличиваем i + 1, если какой то из ID не верен, то @iне увеличивается
и происходит новая генерация чисел
Примечание: сделано для того чтобы добавлять ровно 100000 записей */

declare @i int, @data date, @day_of_week tinyint, @number_lesson tinyint, @class_id int, @subject_id int, @teacher_id int,  @auditorium tinyint, @const date
set @i = 1
set @const = '2013-01-15'
set @day_of_week = 1
set @number_lesson = 1
set @class_id =1 
set @subject_id = 1
set @teacher_id = 1
set @auditorium = 1

WHILE @i <= 1000000
BEGIN
   BEGIN TRY  
    
   insert into dbo.schedule(data, day_of_week, number_lesson,class_id, subject_id, teacher_id, auditorium) 
	 values (@data, @day_of_week, @number_lesson,@class_id, @subject_id, @teacher_id, @auditorium)
    
END TRY  
BEGIN CATCH  
    print 'error'
END CATCH
--остаток от деления на 1460, так как рассчитываем на 4 года 365*4 = 1460
set @i = @i + 1 
set @data = DATEADD(day, @i % 1460,  @const)
set @day_of_week = 1 + (RAND(CHECKSUM(NEWID()))*7)
set @number_lesson = 1 + (RAND(CHECKSUM(NEWID()))*(select max(number_lesson) from dbo.lesson_time))
set @class_id =1 + (RAND(CHECKSUM(NEWID()))*(select max(class_id) from dbo.classes))
set @subject_id = 1 + (RAND(CHECKSUM(NEWID()))*(select max(subject_id) from dbo.subjects))
-- учителя будут выведены не совсем корректно, например любой учитель может вести любой урок
set @teacher_id = 1 + (RAND(CHECKSUM(NEWID()))*(select max(teacher_id) from dbo.teachers))
set @auditorium = 1 + (RAND(CHECKSUM(NEWID()))*31) -- по условию аудиторий меньше 31

END

delete schedule
   from dbo.schedule
   where ((month(data) = 01) and day(data) between 00 and 14) or (month(data) between 05 and 09)
 
 /*    
delete menu
   from schedule as sh -- удалить все данные стркои
      right join teachers as teac  on teac.teacher_id = sh.teacher_id 
   where teac.employee_id = null 
*/		

--SELECT * FROM service_staff
--SELECT * FROM menu
--SELECT * FROM teachers
--SELECT * FROM schedule
--SELECT count(*) FROM dishes
--SELECT * FROM lesson_time


declare @i int, @responsible_cooker_id int, @menu_data date, @const date
set @const = '2013-01-15'
set @menu_data = @const
set @i = 1
set @responsible_cooker_id = 9

update menu 
  set responsible_cooker_id = 11
    where menu_id = 1439

delete menu
   from menu 
    where menu_id = 1447

--рассчитываем на 3.5 года
WHILE @i <= select DATEDIFF(day, @const, GETDATE())
BEGIN
  insert into dbo.menu(menu_data, responsible_cooker_id) 
    values (@menu_data, @responsible_cooker_id )
  set @responsible_cooker_id= 9+(RAND(CHECKSUM(NEWID()))*5) --всего 5 поваров
  -- можно также усложнить как и с расписанием, находить диапазон поваров, rand, а затем удалять лишние записи
  set @i = @i + 1 
  set @menu_data = DATEADD(day, @i,  @const)
END
Go

insert dbo.category_dish
   (category_name)
VALUES
   ('Салаты и холодные закуски'),
   ('Супы'),
   ('Горячие блюда'),
   ('Гарниры'),
   ('Напитки'),
   ('Порционные товары'),
   ('Хлебобулочные изделия')

GO

select * from dishes
declare @i int, @name varchar(50), @category tinyint,  @stroka varchar(50), @dish_count smallint, @dish_price smallmoney, @menu_id int
set @name = 'dish'
set @stroka = 'dish'
set @category = 1
set @i = 1
set @dish_count = 15
set @dish_price = 10.00
set @menu_id =1

WHILE @i <= 500000
BEGIN
   
   BEGIN TRY  
      insert into dbo.dishes(dish_name, category_dish_id, dish_count, dish_price, menu_id) 
    values (@name, @category, @dish_count, @dish_price, @menu_id )
  
	set @i = @i + 1 
END TRY  
BEGIN CATCH  
    print 'error'
END CATCH

  set @name = @stroka + CAST(round(1+(RAND(CHECKSUM(NEWID()))*500),0) as varchar)
  set @dish_count = 1+(RAND(CHECKSUM(NEWID()))*150)
  set @category = 1+(RAND(CHECKSUM(NEWID()))*7)
  set @dish_price = round(15.00 +(RAND(CHECKSUM(NEWID()))*80.00),0)
  set @menu_id = 1+(RAND(CHECKSUM(NEWID()))*1442)--(select max(menu_id) from dbo.menu))
END

select * from dishes


--Действия над данными
--1)	Добавление нового учителя (и соответственно сотрудника);
--Выполнено выше, при заполнении таблиц

--2)	Добавление нового ученика;

if exists (select * from dbo.sysobjects 
                  where id = object_id(N'dbo.new_learner')  and objectproperty(id, N'IsProcedure') = 1
               )
   drop procedure dbo.new_learner
GO

create proc dbo.new_learner
 
  @name varchar(60), 
  @pol varchar(1), 
  @birthday date,
  @addresss varchar(50),
  @class_id int
 
AS
 
insert into dbo.learners
(name, pol, birthday, addresss,class_id)
values(@name,@pol,@birthday,@addresss,@class_id)
 		   
GO

select * from learners
select * from classes
select * from dishes

exec dbo.new_learner 'Дмитриев Олег Сергеевич', 'м', '1999-01-06', 'Комсомольская, 4 ', 37

--3)	Изменение статуса сотрудника «уволившийся сотрудник» по его идентификатору;

if exists (select * from dbo.sysobjects 
                  where id = object_id(N'dbo.change_status_laid_offf_employee')  and objectproperty(id, N'IsProcedure') = 1
               )
   drop procedure dbo.change_status_laid_offf_employee
GO

create proc dbo.change_status_laid_offf_employee
 
  @employee_id int

AS

update dbo.employees
    set laid_offf_employee = 1
	    from employees 
	    where  employee_id =  @employee_id

GO

exec dbo.change_status_laid_offf_employee 4

select * from employees

--4)	Изменение записи в расписании (изменение информации об учебном классе, учителе, предмете, номере аудитории)
--Для создания процедуры будут использоваться 5 переменные, причем, если в записи нужно изменить не все, то для неизменяемых 
--ставится @ = 0 

if exists (select * from dbo.sysobjects 
                  where id = object_id(N'dbo.change_discipline_scsedule')  and objectproperty(id, N'IsProcedure') = 1
               )
   drop procedure dbo.change_discipline_scsedule
GO

create proc dbo.change_discipline_scsedule

  @schedule_discipline_id int,
  @class_id int, 
  @subject_id int, 
  @teacher_id int,  
  @auditorium tinyint

AS

if (@class_id <> 0)
  begin
   update dbo.schedule
       set class_id = @class_id
	     from schedule 
	     where schedule_discipline_id =  @schedule_discipline_id
   end

if (@subject_id <> 0)
  begin
   update dbo.schedule
       set subject_id = @subject_id
	     from schedule 
	     where schedule_discipline_id =  @schedule_discipline_id
   end

if (@teacher_id <> 0)
  begin
   update dbo.schedule
       set teacher_id = @teacher_id
	     from schedule 
	     where schedule_discipline_id =  @schedule_discipline_id
   end

if (@auditorium <> 0)
  begin
   update dbo.schedule
       set auditorium = @auditorium
	     from schedule 
	     where schedule_discipline_id =  @schedule_discipline_id
   end

   select * from schedule 
     where schedule_discipline_id = @schedule_discipline_id

GO

exec dbo.change_discipline_scsedule 105,0,0,0,20

select * from Audit_auditorium

/*5)	Установка года выпуска указанному классу.
 Уже вручную заполнил информацию о годе выпуска. Если бы не заполнял, то можно обновить год выпуска
текущий год 2016
year_of_education - 1 так как ученики, обучающиеся на n году, закончили n-1 класс
*/
select * from classes


if exists (select * from dbo.sysobjects 
                  where id = object_id(N'dbo.year_graduation_class_5')  and objectproperty(id, N'IsProcedure') = 1
               )
   drop procedure dbo.year_graduation_class_5
GO

create proc dbo.year_graduation_class_5

  @year_of_education tinyint,
  @letter varchar(1),
  @year_graduation int output
  
AS

   update dbo.classes
       set year_graduation = year(GETDATE()) - (year_of_education - 1) + 11
	     from classes 
	     where (year_of_education =  @year_of_education) and (letter = @letter) and (year_graduation = null)

   select * from classes  
     where (year_of_education =  @year_of_education) and (letter = @letter)

	 set @year_graduation = (select year_graduation from classes  
     where (year_of_education =  @year_of_education) and (letter = @letter))
GO

declare @year_graduation int
exec year_graduation_class_5 11,'А', @year_graduation output
select @year_graduation as [year_graduation]

--8. Создание процедур
/*
1)	Выбор самого «трудолюбивого» учителя по количеству проведенных уроков за определенную четверть в выбранном году;
Входные данные: четверть, год, предмет (может быть не указан, тогда по всем предметам);
Результат выполнения должен содержать: ФИО учителя, год, четверть, предмет, количество проведенных уроков.
*/


if exists (select * from dbo.sysobjects 
                  where id = object_id(N'dbo.the_most_hardworking_teacher_1')  and objectproperty(id, N'IsProcedure') = 1
               )
   drop procedure dbo.the_most_hardworking_teacher_1
GO

create proc dbo.the_most_hardworking_teacher_1

  @discipline_quarter tinyint,
  @discipline_year int, 
  @name_sub varchar(50) = null


AS

   IF @name_sub is not null  
   BEGIN  
       select top(1) emp.name, year(q.data) as [discipline_year], q.quarterr, sub.name_sub, count(*) as [summa]
      from schedule as sch
	    join subjects as sub on sub.subject_id = sch.subject_id
		join teachers as teac on teac.teacher_id = sch.teacher_id
		join quarter_data as q on q.data = sch.data
		join employees as emp on teac.employee_id = emp.employee_id
       where (q.quarterr = @discipline_quarter) and (year(sch.data) = @discipline_year) and (sub.name_sub = @name_sub)
      group by emp.name, q.data, q.quarterr, sub.name_sub
	  order by summa DESC
   END  
ELSE  
   BEGIN 
       select top(1) emp.name, year(q.data) as [discipline_year], q.quarterr,  count(*) as [summa]
      from schedule as sch
	    join subjects as sub on sub.subject_id = sch.subject_id
		join teachers as teac on teac.teacher_id = sch.teacher_id
		join quarter_data as q on q.data = sch.data
		join employees as emp on teac.employee_id = emp.employee_id
      where (q.quarterr = @discipline_quarter) and (year(sch.data) = @discipline_year) 
      group by emp.name, q.data, q.quarterr
	  order by summa DESC
   END  

GO

exec the_most_hardworking_teacher_1 1,2013,'физика'


exec the_most_hardworking_teacher_1 1,2013

/*2)	Подсчет самого выгодного по стоимости набора блюд из выбранных 3 категорий за какой-либо день 
(туда включается по одному блюду из каждой категории).
Входные данные: 1 категория, 2 категория, 3 категория, дата;
Результат выполнения должен содержать: названия блюд с их минимальной ценой, а также их категория;
Выходной параметр: общая стоимость 
*/
--В процедуру будет добавлен category_dish_id, чтобы было понятнее соответствие входных и выходных данных


if exists (select * from dbo.sysobjects 
                  where id = object_id(N'dbo.the_most_payable_dish_2')  and objectproperty(id, N'IsProcedure') = 1
               )
   drop procedure dbo.the_most_payable_dish_2
GO

create proc dbo.the_most_payable_dish_2

  @category_1 tinyint,
  @category_2 tinyint,
  @category_3 tinyint,
  @menu_data date,
  @summa_price smallmoney output

AS
  
   BEGIN  

 if object_id(N'tempdb..#temp',N'U') is not null 
drop table temp

create table #temp(
  dish_price smallmoney not null,
  category_name varchar(30) not null,
 -- dish_count smallint not null

) 

--заполним временную таблицу min ценой блюд и их категорией. ( в соответствии с заданными категориями и датой)
insert #temp(dish_price, cat.category_name) 
(
  select min(d.dish_price) as [min_dish_price], cat.category_name
        from dishes as d
	      join menu as m on m.menu_id = d.menu_id
		  join category_dish as cat on cat.category_dish_id = d.category_dish_id
        --where ((cat.category_dish_id = @category_1) or (cat.category_dish_id = @category_2) or (cat.category_dish_id = @category_3)) and (m.menu_data = @menu_data)
      where ((cat.category_dish_id = 1) or (cat.category_dish_id = 2) or (cat.category_dish_id = 3)) and (m.menu_data = '2015-12-19')
	    group by cat.category_dish_id, cat.category_name
)

--Может быть несколько блюд с одной и той же минимальной ценой, выбираем их все
select d.dish_name, temp.dish_price, cat.category_dish_id, temp.category_name
     from #temp as temp 
	   join category_dish as cat on cat.category_name = temp.category_name
	   join dishes as d on d.dish_price = temp.dish_price
	   where ((d.category_dish_id = @category_1) or (d.category_dish_id = @category_2) or (d.category_dish_id = @category_3))
	 order by temp.dish_price, cat.category_dish_id 


set @summa_price = (select sum(temp.dish_price)
                        from (select DISTINCT category_name, dish_price FROM #temp) as temp
					   
					)

drop table #temp

   END  

declare @summa_price smallmoney
exec dbo.the_most_payable_dish_2 1,2,3,'2015-12-19',  @summa_price output
select @summa_price as [summa_price]


select * from dishes as d 
join menu as m on m.menu_id = d.menu_id
 where m.menu_data = '2015-12-19'
/*3.Подсчет общего количества учеников, обучающихся за указанный год.
Входные данные: год;
Результат выполнения должен содержать: год обучения учащихся, их количество на указанный год.

Добавим еще выходной параметр, показывающий общее количество учеников за год. А для каждого года обучения будем считать количество отдельно
*/

--year_of_education = year(GETDATE()) - @year -- находим по году обучения на сегодняшний момент
-- так как ученики пришли в школу year(GETDATE()) - @year лет назад и обучаются на соотв году обучения

if exists (select * from dbo.sysobjects 
                  where id = object_id(N'dbo.count_learners_year_3')  and objectproperty(id, N'IsProcedure') = 1
               )
   drop procedure dbo.count_learners_year_3
GO

create proc dbo.count_learners_year_3

  @year int,
  @year_output int output,
  @summa_learners int output

AS
  
   BEGIN  
  
   select  (cl.year_of_education - (year(GETDATE()) - @year)) as [old_year_class], cl.year_of_education as [current_year_class], count(*) as [number_learners]
     from learners as lear
	   join classes as cl on cl.class_id = lear.class_id
	where (CAST(cl.year_of_education as int) > year(GETDATE())  - @year)  or ( cl.year_graduation - @year <= year(GETDATE()) - @year)
	--второе условие позволяет посчитать еще и учеников, которые выпустились за прошедшие годы 
	group by cl.year_of_education

	select @year_output = @year

	select @summa_learners = (select  count(*) 
						from learners as lear
						  join classes as cl on cl.class_id = lear.class_id
						where CAST(cl.year_of_education as int) > year(GETDATE())  - @year
	)

    END 

declare @year_output int, @summa_learners int
exec dbo.count_learners_year_3 2015,  @year_output output, @summa_learners output
select @year_output as [year]
select @summa_learners as [summa_learners]

select cl.year_of_education, count(*) as [summa]
  from classes as cl
    join learners as lear on lear.class_id = cl.class_id
  group by year_of_education


/*4.	Выбор самых «трудных» предметов  за определенный период (по минимальной средней оценке);
Входные данные: количество предметов, начало периода, конец периода;
Результат выполнения должен содержать соответствующие трудные предметы (указанное количество), среднюю оценку;
Данные отсортированы по возрастанию оценок.
*/


if exists (select * from dbo.sysobjects 
                  where id = object_id(N'dbo.the_most_difficult_subject_4')  and objectproperty(id, N'IsProcedure') = 1
               )
   drop procedure dbo.the_most_difficult_subject_4
GO

create proc dbo.the_most_difficult_subject_4

  @count_subjects int,
  @start_data date,
  @end_data date

AS
  
   BEGIN  

   select top(@count_subjects) sub.name_sub, CAST(avg(CAST(m.mark_value as decimal(4,3))) as decimal(4,3)) as [avg_mark]--, count(m.mark_id)
     from subjects as sub
	   join marks as m on m.subject_id = sub.subject_id
	 where m.data between @start_data and @end_data 
     group by sub.name_sub
	 order by avg(m.mark_value)


   END

exec dbo.the_most_difficult_subject_4 5,'2015-01-15','2015-05-30'

/*
5)	Подсчет оценок за четверть учеников определенного года обучения по определенному предмету;
Входные данные: год обучения класса, учебная четверть, год оценки, предмет.
Результат выполнения должен содержать: ФИО ученика, год обучения его учебного класса, буква, предмет, итоговая оценка.

*/

if exists (select * from dbo.sysobjects 
                  where id = object_id(N'dbo.marks_for_quater_5')  and objectproperty(id, N'IsProcedure') = 1
               )
   drop procedure dbo.marks_for_quater_5
GO

create proc dbo.marks_for_quater_5

  @year_of_education tinyint,
  @quarterr tinyint,
  @year_of_marks int,
  @name_sub varchar(50)

AS
  
   BEGIN  

   select lear.name, cl.year_of_education, cl.letter, sub.name_sub, avg(m.mark_value) as [mark for quater]
     from learners as lear
	   join marks as m on m.learner_id = lear.learner_id
	   join classes as cl on lear.class_id = cl.class_id
	   join subjects as sub on sub.subject_id = m.subject_id
	   join quarter_data as q on m.data = q.data
	  where (@year_of_education = cl.year_of_education) and (@quarterr = q.quarterr) and (@year_of_marks = year(m.data)) 
	           and (@name_sub = sub.name_sub)
	 group by lear.name, cl.year_of_education, cl.letter, sub.name_sub

   END

exec dbo.marks_for_quater_5 11,4,2014,'Физика'

select * from learners
  where name = 'Богданов Александр Евгеньевич'

/* -- здесь можно посмотреть все оценки, полученные за определенный период
select lear.name, cl.year_of_education, cl.letter, sub.name_sub, m.mark_value
    from learners as lear
	   join marks as m on m.learner_id = lear.learner_id
	   join classes as cl on lear.class_id = cl.class_id
	   join subjects as sub on sub.subject_id = m.subject_id
	   join quarter_data as q on m.data = q.data
    where (cl.year_of_education = 11) and (q.quarterr = 4) and (year(m.data) = 2014)  and ('Физика' = sub.name_sub)
	group by lear.name, cl.year_of_education, cl.letter, sub.name_sub, m.mark_value
*/

/*
6)	Информация об определенной аудитории по факту «занятости» в определенный день недели;
Входные данные: номер аудитории, день недели;
Результат выполнения должен содержать: все соответствующие занятия
 (день недели, номер аудитории, номер проводимого занятия, ФИО учителя, предмет, учебный класс), отсортированные по номеру урока.

*/
if exists (select * from dbo.sysobjects 
                  where id = object_id(N'dbo.busy_auditorium_6')  and objectproperty(id, N'IsProcedure') = 1
               )
   drop procedure dbo.busy_auditorium_6
GO

create proc dbo.busy_auditorium_6

  @auditorium tinyint,
  @day_of_week tinyint

AS
  
BEGIN

  select sh.day_of_week, sh.auditorium, sh.number_lesson, emp.name, sub.name_sub, cl.year_of_education, cl.letter
    from schedule as sh
	  join teachers as teac on teac.teacher_id = sh.teacher_id
	  join subjects as sub on sub.subject_id = sh.subject_id
	  join classes as cl on cl.class_id = sh.class_id
	  join employees as emp on emp.employee_id = teac.employee_id
    where (@auditorium = sh.auditorium) and (@day_of_week = sh.day_of_week)
	group by sh.day_of_week, sh.auditorium, sh.number_lesson, emp.name, sub.name_sub, cl.year_of_education, cl.letter
	order by sh.number_lesson


END

exec dbo.busy_auditorium_6 15,3


--Индексы

--В таблице уже есть первичный ключ, а значит, и кластерный индекс, поэтому создание ключей ниже, в случае отсоед таблицы
/*
--A) Создание первичных ключей (кластерных) 
use db316
select * from menu


IF EXISTS (SELECT name FROM sys.key_constraints  
              WHERE name = N'PK_dishes_dish_id')  
    alter table dbo.dishes
      drop constraint PK_dishes_dish_id

alter table dbo.dishes
    add constraint PK_dishes_dish_id primary key clustered (dish_id);
go

------------------------------------------------

IF EXISTS (SELECT name FROM sys.key_constraints  
              WHERE name = N'PK_dishes_dish_name')  
    alter table dbo.dishes
      drop constraint PK_dishes_dish_name

alter table dbo.dishes
    add constraint PK_dishes_dish_name primary key clustered (dish_name);
go
---------------------------------------------

IF EXISTS (SELECT name FROM sys.key_constraints  
              WHERE name = N'PK_dishes_dish_count')  
    alter table dbo.dishes
      drop constraint PK_dishes_dish_count

alter table dbo.dishes
    add constraint PK_dishes_dish_count primary key clustered (dish_count);
go

----------------------------------------------
IF EXISTS (SELECT name FROM sys.key_constraints  
              WHERE name = N'PK_dishes_ dish_price')  
    alter table dbo.dishes
      drop constraint PK_dishes_dish_price

alter table dbo.dishes
    add constraint PK_dishes_dish_price primary key clustered (dish_price)
go
*/
---------------------------------------------
------------------------------------------------:::::::::::::::::::::::::::::::::::::
--Создание некластерных индексов 
sp_spaceused
select * from dishes

IF EXISTS (SELECT name FROM sys.indexes  
            WHERE name = N'ix_dishes_dish_name')  
    drop index ix_dishes_dish_name ON dbo.dishes 
create index ix_dishes_dish_name
  on dbo.dishes(dish_name) 
go 

IF EXISTS (SELECT name FROM sys.indexes  
            WHERE name = N'ix_dishes_category_dish_id')  
    drop index ix_dishes_category_dish_id ON dbo.dishes 
create index ix_dishes_category_dish_id
  on dbo.dishes(category_dish_id) 
go 


IF EXISTS (SELECT name FROM sys.indexes  
            WHERE name = N'ix_dishes_dish_count')  
    drop index ix_dishes_dish_count ON dbo.dishes 
create index ix_dishes_dish_count
  on dbo.dishes(dish_count) 
go 


IF EXISTS (SELECT name FROM sys.indexes  
            WHERE name = N'ix_dishes_dish_price')  
    drop index ix_dishes_dish_price ON dbo.dishes 
create index ix_dishes_dish_price
  on dbo.dishes(dish_price) 
go 

IF EXISTS (SELECT name FROM sys.indexes  
            WHERE name = N'ix_dishes_menu_id')  
    drop index ix_dishes_menu_id ON dbo.dishes 
create index ix_dishes_menu_id
  on dbo.dishes(menu_id) 
go 

--------------------
--Использование индексов для таблицы dishes
--A0) Написать запрос, который выбирает 100 записей из таблицы dishes, 
--соответствующие какому либо диапазону из 100 значений поля dishes_id

declare @start datetime
set @start = getdate()

select *
  from dbo.dishes
  where dishes.dish_id between 45 and 144
select datediff(ms, @start,getdate()) as [time1]
go

--A) Написать запрос, который выбирает около 200000 записей из таблицы dishes, 
--соответствующие какому либо диапазону из этих 200000 значений поля dishes_name

--в данном случае 208888 записей

declare @start datetime
set @start = getdate()
select *
  from dbo.dishes
  where dishes.dish_name between 'dish100' and 'dish107'
select datediff(ms, @start,getdate()) as [time1]
go

--B) Написать запрос, который выбирает записи из таблицы dishes, 
--соответствующие какому либо диапазону из этих значений поля category_dish_id

declare @start datetime
set @start = getdate()
select *
  from dbo.dishes
  where (dishes.category_dish_id = 1) or (dishes.category_dish_id = 2)
select datediff(ms, @start,getdate()) as [time1]
go

--C)Написать запрос, который выбирает записи из таблицы dishes, 
--соответствующие какому либо диапазону из этих значений поля dishes_count

declare @start datetime
set @start = getdate()
select *
  from dbo.dishes
  where dishes.dish_count between 20 and 22
select datediff(ms, @start,getdate()) as [time1]
go

--D)Написать запрос, который выбирает записи из таблицы dishes, 
--соответствующие какому либо диапазону из этих значений поля dishes_price
--2147483647

declare @start datetime
set @start = getdate()
select *
  from dbo.dishes
  where dishes.dish_price between 20.00 and 25.00
select datediff(ms, @start,getdate()) as [time1]
go

--E) Написать запрос, который выбирает записи из таблицы dishes, 
--соответствующие какому либо диапазону из этих значений поля menu_id

declare @start datetime
set @start = getdate()
select *
  from dbo.dishes
  where dishes.menu_id between 20 and 25
select datediff(ms, @start,getdate()) as [time1]
go

------------------------------------------------:::::::::::::::::::::::::::::::::::::
--Создание некластерных индексов для таблицы dbo.schedule
sp_spaceused
select * from dbo.schedule

IF EXISTS (SELECT name FROM sys.indexes  
            WHERE name = N'ix_schedule_data')  
    drop index ix_schedule_data ON dbo.schedule 
create index ix_schedule_data
  on dbo.schedule(data) 
go 

IF EXISTS (SELECT name FROM sys.indexes  
            WHERE name = N'ix_schedule_day_of_week')  
    drop index ix_schedule_day_of_week ON dbo.schedule 
create index ix_schedule_day_of_week
  on dbo.schedule(day_of_week) 
go

IF EXISTS (SELECT name FROM sys.indexes  
            WHERE name = N'ix_schedule_number_lesson')  
    drop index ix_schedule_number_lesson ON dbo.schedule 
create index ix_schedule_number_lesson
  on dbo.schedule(number_lesson) 
go

IF EXISTS (SELECT name FROM sys.indexes  
            WHERE name = N'ix_schedule_class_id')  
    drop index ix_schedule_class_id ON dbo.schedule 
create index ix_schedule_class_id
  on dbo.schedule(class_id) 
go

IF EXISTS (SELECT name FROM sys.indexes  
            WHERE name = N'ix_schedule_subject_id')  
    drop index ix_schedule_subject_id ON dbo.schedule 
create index ix_schedule_subject_id
  on dbo.schedule(subject_id) 
go

IF EXISTS (SELECT name FROM sys.indexes  
            WHERE name = N'ix_schedule_teacher_id')  
    drop index ix_schedule_teacher_id ON dbo.schedule 
create index ix_schedule_teacher_id
  on dbo.schedule(teacher_id) 
go

IF EXISTS (SELECT name FROM sys.indexes  
            WHERE name = N'ix_schedule_auditorium')  
    drop index ix_schedule_auditorium ON dbo.schedule 
create index ix_schedule_auditorium
  on dbo.schedule(auditorium) 
go

--Использование индексов для таблицы schedule
--A)

declare @start datetime
set @start = getdate()

select *
  from dbo.schedule
  where (schedule.data = '2013-02-22') or (schedule.data = '2013-02-23')
select datediff(ms, @start,getdate()) as [time1]
go

--B)

declare @start datetime
set @start = getdate()

select *
  from dbo.schedule
  where schedule.day_of_week = 1
select datediff(ms, @start,getdate()) as [time1]
go

--C)
declare @start datetime
set @start = getdate()

select *
  from dbo.schedule
  where schedule.number_lesson = 2
select datediff(ms, @start,getdate()) as [time1]
go

--D)
declare @start datetime
set @start = getdate()

select *
  from dbo.schedule
  where schedule.class_id = 5
select datediff(ms, @start,getdate()) as [time1]
go

--E)
declare @start datetime
set @start = getdate()

select *
  from dbo.schedule
  where schedule.subject_id between 13 and 15
select datediff(ms, @start,getdate()) as [time1]
go

--F)
declare @start datetime
set @start = getdate()

select *
  from dbo.schedule
  where schedule.teacher_id = 8
select datediff(ms, @start,getdate()) as [time1]
go

--G)
declare @start datetime
set @start = getdate()

select *
  from dbo.schedule
  where schedule.auditorium between 5 and 9
select datediff(ms, @start,getdate()) as [time1]
go
-------------------------

-- Создание триггеров

/*1) Создадим триггер, который выполняется всегда, когда в таблицу marks вставляется строка или выполняется ее модификация. 
Если дата выставления оценки относится к весенним или осенним каникулам, то строка в таблицу не вводится.
Цель создания: чтобы учителя не ошиблись при вводе оценки
*/
-- DROP TRIGGER Trig_data_marks 
use db316
create trigger Trig_data_marks 
on marks 
for insert, update
AS
/* Объявить необходимые локальные переменные */
declare @mark_data date
/* Найти информацию о добавленной записи */
select @mark_data = i.data
  from marks as m, Inserted as i
  where m.mark_id = i.mark_id
/* Проверить критерий отказа и в случае необходимости
послать сообщение об ошибке */
IF ((DAY(@mark_data) between 23 and 31) and (month(@mark_data) = 03))
     or ((DAY(@mark_data) between 01 and 10) and (month(@mark_data) = 11))
BEGIN
/* Примечание: всегда сначала производите откат. Вы можете не знать,
какого рода ошибка обработки произошла, что может вызвать
неоправданно продолжительное время блокировки */
ROLLBACK TRAN
RAISERROR('В каникулы выставлять оценки нельзя', 16, 10 )
END

GO

--Проверка

insert into dbo.marks(mark_value, data, learner_id, subject_id) 
    values (4, '2016-03-26', 5, 6 ) 

GO
/*
2)
Таблица service_staff связана отношением 1:M c таблицей menu, поэтому невозможно удалить работника, а точнее повара, 
если он назначен ответственным за меню будущий дни.
 Создадим триггер, который при удалении работника будет проверять, назначено ли на него меню или нет.
  Если назначены, то работник не будет удаляться. В связи с тем, что имеется ограничение целостности, 
  то работа AFTER-триггера совместно с ним невозможна. 
*/

-----------------------------
--2) ссылочная целостность для оценок и предметов

create trigger subject_marks
    ON marks AFTER INSERT, UPDATE
    AS 
	IF UPDATE(subject_id)
    BEGIN
        IF (SELECT sub.subject_id
                FROM subjects as sub, inserted as i
                WHERE sub.subject_id = i.subject_id) IS NULL
        BEGIN
            ROLLBACK TRANSACTION
            PRINT 'Строка не была вставлена/модифицирована'
        END
        ELSE 
            PRINT 'Строка была вставлена/модифицирована'
    END

select * from marks

insert into dbo.marks(mark_value, data, learner_id, subject_id) 
   values (5, '2017-02-02', 24, 40 ) 
  go
--2a)
/*Создадим триггер, который выполняется всегда, когда в таблицу emloyees вставляется строка или выполняется ее модификация. 
Если возраст учителя не удовлетворяет ограничению от 30 до 55, то срока не вставляется
Цель создания: разделить столбец birthday в табл employees для учителей и обслуж персонала
*/
-- DROP TRIGGER Trig_data_marks 

create trigger Trig_teacher_age
   on employees
for insert, update
AS

declare @birthday date
declare @functionn varchar(40)

select @birthday = i.birthday
  from employees as em, Inserted as i
  where em.employee_id = i.employee_id

select @functionn = i.functionn
  from employees as em, Inserted as i
  where em.employee_id = i.employee_id
/* Проверить критерий отказа и в случае необходимости
послать сообщение об ошибке */
IF ((year(@birthday) < year(GETDATE())- 55) or (year(@birthday) > year(GETDATE())- 30)) and CHARINDEX('Учитель', @functionn) <> 0--(CONTAINS(@functionn, 'Учитель'))

BEGIN
/* Примечание: всегда сначала производите откат. Вы можете не знать,
какого рода ошибка обработки произошла, что может вызвать
неоправданно продолжительное время блокировки */
ROLLBACK TRAN
RAISERROR('Предупреждение: возраст учителя должен быть от 30 до 55 лет', 16, 10 )
END

GO

select * from employees

--Проверка

declare @help int
exec dbo.new_teacher_employees 'Комарова Светлана Валерьевна', 'ж', 'Попова 15', 'Учитель информатики', '8-968-16-73-04', 13, '1950-05-11', @help 

GO


--3)

/* 
Cоздается таблица Audit_auditorium, в которой сохраняются все изменения столбца auditorium
 таблицы Schedule. Изменения этого столбца будут записываться в эту таблицу посредством триггера
 */

if exists (select * from dbo.sysobjects 
                 where id = object_id(N'dbo.Audit_auditorium') and objectproperty(id, N'IsUserTable') = 1)

  drop table dbo.Audit_auditorium

GO

create table Audit_auditorium (
    schedule_discipline_id int NULL,
    UserName varchar(60) NULL,
    Date datetime NULL,
    auditorium_Old int NULL,
    auditorium_New int NULL
);

GO

create trigger trigger_Modify_auditorium
    ON Schedule AFTER UPDATE
    AS IF UPDATE(auditorium)
BEGIN
    declare @auditorium_Old int
    declare @auditorium_New int
    declare @schedule_discipline_id int

    select @auditorium_Old = (select auditorium FROM deleted)
    select @auditorium_New = (select auditorium FROM inserted)
    select @schedule_discipline_id = (select schedule_discipline_id FROM deleted)

    INSERT INTO Audit_auditorium VALUES
        (@schedule_discipline_id, USER_NAME(), GETDATE(), @auditorium_Old, @auditorium_New)
END

select * from Audit_auditorium

exec dbo.change_discipline_scsedule 105,0,0,0,20


--4)

/* 
Cоздается таблица Audit_auditorium_2, в которой сохраняются все изменения
 таблицы Schedule. Изменения этого столбца будут записываться в эту таблицу посредством триггера
 */
 if exists (select * from dbo.sysobjects 
                 where id = object_id(N'dbo.Audit_auditorium_2') and objectproperty(id, N'IsUserTable') = 1)

  drop table dbo.Audit_auditorium_2

GO

create table Audit_auditorium_2 (
    schedule_discipline_id int NULL,
	deleted bit null default 0,
    UserName varchar(60) NULL,
    Date datetime NULL,
	data date null,
    day_of_week tinyint null,
    number_lesson tinyint null,
    class_id int null,
    subject_id int null,
    teacher_id int null,
    auditorium tinyint null,
    canceled_lesson bit null default 0
);

GO

create trigger trigger_Modify_auditorium_2
    ON Schedule AFTER UPDATE, INSERT
	AS
BEGIN

    declare @schedule_discipline_id int
	declare @data date
    declare @day_of_week tinyint
    declare @number_lesson tinyint
    declare @class_id int 
    declare @subject_id int 
    declare @teacher_id int 
    declare @auditorium tinyint
    declare @canceled_lesson bit
    declare @inserted bit

    select @schedule_discipline_id = (select schedule_discipline_id FROM inserted)
    select @data = (select data FROM inserted)
	select @day_of_week = (select day_of_week FROM inserted)
	select @number_lesson = (select number_lesson FROM inserted)
	select @class_id = (select class_id FROM inserted)
	select @subject_id = (select subject_id FROM inserted)
	select @teacher_id = (select teacher_id FROM inserted)
	select @auditorium = (select auditorium FROM inserted)
	select @canceled_lesson = (select canceled_lesson FROM inserted)
    
	set @inserted = 0

    INSERT INTO Audit_auditorium_2 VALUES
        (@schedule_discipline_id, @inserted, SUSER_NAME(), GETDATE(), @data, @day_of_week, @number_lesson, @class_id, @subject_id, @teacher_id, @auditorium, @canceled_lesson )
END

Go

create trigger trigger_Delete_auditorium_2
    ON Schedule AFTER Delete
	AS
BEGIN

    declare @schedule_discipline_id int
	declare @data date
    declare @day_of_week tinyint
    declare @number_lesson tinyint
    declare @class_id int 
    declare @subject_id int 
    declare @teacher_id int 
    declare @auditorium tinyint
    declare @canceled_lesson bit
    declare @deleted bit

    select @schedule_discipline_id = (select schedule_discipline_id FROM deleted)
    select @data = (select data FROM deleted)
	select @day_of_week = (select day_of_week FROM deleted)
	select @number_lesson = (select number_lesson FROM deleted)
	select @class_id = (select class_id FROM deleted)
	select @subject_id = (select subject_id FROM deleted)
	select @teacher_id = (select teacher_id FROM deleted)
	select @auditorium = (select auditorium FROM deleted)
	select @canceled_lesson = (select canceled_lesson FROM deleted)
    
	set @deleted = 1

    INSERT INTO Audit_auditorium_2 VALUES
        (@schedule_discipline_id, @deleted, SUSER_NAME(), GETDATE(), @data, @day_of_week, @number_lesson, @class_id, @subject_id, @teacher_id, @auditorium, @canceled_lesson )
END

go

select * from Audit_auditorium_2

exec dbo.change_discipline_scsedule 91,0,0,7,0

delete 
   from schedule
      where schedule_discipline_id = 91
go
--Триггер праздничное меню

create trigger holiday_menu
    ON menu AFTER UPDATE
	AS
BEGIN

    declare @menu_id int
	
    select @menu_id = (select menu_id FROM inserted)
   
   update dishes
       set dish_price = dish_price*0.8
		 where menu_id = @menu_id 

END

Go

update menu
       set holiday_menu = 1
		 where menu_id = 15
select * from dishes
  where  menu_id = 15
go

create trigger holiday_menu_2
    ON dishes AFTER INSERT
	AS
BEGIN

    declare @menu_id int
	declare @holiday_menu bit
	declare @dish_id int

	select @dish_id = (select dish_id 
	                     from inserted)

    select @menu_id = (select menu_id 
	                     from inserted)
   
    select @holiday_menu = ( select holiday_menu 
	                             from menu
								 where menu_id = @menu_id)

   if @holiday_menu = 1
   BEGIN
    update dishes
       set dish_price = dish_price*0.8
		 where dish_id = @dish_id
	END
END

Go

select * from dishes
  where dish_name = '11'

insert into dbo.dishes(dish_name, category_dish_id, dish_count, dish_price, menu_id) 
   values ('11', 2, 30, 100.00, 15 )


--Создание ролей

--1)Ученики
--Добавляем пользователя базы данных
--ученик 6ого класса
-- создаем имя входа Поливаев Артем Александрович и сопоставленного с ним пользователя в базе данных:

CREATE LOGIN "Поливаев Артем Александрович" WITH PASSWORD='1111';
GO

--Добавляем пользователя базы данных learner, который сопоставлен имени входа learner в БД Schools.
CREATE USER "Поливаев Артем Александрович" FOR LOGIN "Поливаев Артем Александрович";

--Проверить, имеет ли текущее имя входа доступ к базе данных, можно при помощи следующей инструкции:
SELECT HAS_DBACCESS('db316');

--Создаем роль learner.
CREATE ROLE learner
GO

--Добавляем пользователя Peter к роли learner
EXECUTE sp_addrolemember "learner", "Поливаев Артем Александрович" ;

--Изменяем контекст соединения на базу данных School
GRANT SELECT ON dbo.schedule TO learner 
GRANT SELECT ON dbo.lesson_time TO learner 
GRANT SELECT ON dbo.quarter_data TO learner 
GRANT SELECT ON dbo.menu TO learner
GRANT SELECT ON dbo.dishes TO learner
GRANT EXECUTE ON dbo.the_role_select_yours_marks TO learner
GRANT SELECT ON dbo.category_dish TO learner
GO  

if exists (select * from dbo.sysobjects 
                  where id = object_id(N'dbo.the_role_select_yours_marks')  and objectproperty(id, N'IsProcedure') = 1
               )
   drop procedure dbo.the_role_select_yours_marks
GO

create proc dbo.the_role_select_yours_marks

AS
  
   BEGIN  

   select lear.name, q.data, q.quarterr, m.mark_value, sub.name_sub
     from marks as m
	 join learners as lear on lear.learner_id = m.learner_id
	 join subjects as sub on sub.subject_id = m.subject_id
	 join quarter_data as q on q.data = m.data
	 where  (lear.name = SUSER_NAME()) 
	 --проверка аутентификации
 
   END

exec dbo.the_role_select_yours_marks 

select * from marks
 where learner_id = 45

--предоставляется разрешение SELECT роли learner на таблицу schedule. marks. menu. dishes

--2) Родители
/*CREATE LOGIN "Поливаев Александр Александрович"  FROM WINDOWS;  
GO  */
CREATE LOGIN "Поливаев Александр Александрович" WITH PASSWORD='2222';
GO

CREATE USER "Поливаев Александр Александрович" FOR LOGIN "Поливаев Александр Александрович";

CREATE ROLE Parent
GO

EXECUTE sp_addrolemember "Parent", "Поливаев Александр Александрович"

use db316
--Изменяем контекст соединения на базу данных School
GRANT SELECT ON dbo.schedule TO Parent 
GRANT SELECT ON dbo.lesson_time TO Parent 
GRANT SELECT ON dbo.quarter_data TO Parent
GRANT SELECT ON dbo.marks TO Parent
GRANT SELECT ON dbo.menu TO Parent
GRANT SELECT ON dbo.dishes TO Parent
GRANT SELECT ON dbo.employees TO Parent
GRANT SELECT ON dbo.teachers TO Parent
GRANT SELECT ON dbo.service_staff TO Parent
GRANT SELECT ON dbo.category_dish TO Parent
GRANT EXECUTE ON dbo.the_role_select_parents_marks TO Parent
GO  

create proc dbo.the_role_select_parents_marks

AS
  
   BEGIN  

   select lear.name, q.data, q.quarterr, m.mark_value, sub.name_sub
     from marks as m
	 join learners as lear on lear.learner_id = m.learner_id
	 join subjects as sub on sub.subject_id = m.subject_id
	 join quarter_data as q on q.data = m.data
	 join parents as par on par.parent_id = lear.parent_id
	 where  par.name = (SUSER_NAME())
 
   END

 exec dbo.the_role_select_parents_marks

--3) Учителя
--Golovina_Inna_Andreevna - учитель физики
CREATE LOGIN "Головина Инна Андреевна"  WITH PASSWORD='3333'; 
GO  

CREATE USER "Головина Инна Андреевна" FOR LOGIN "Головина Инна Андреевна";
go

CREATE ROLE Teacher
GO

EXECUTE sp_addrolemember "Teacher", "Головина Инна Андреевна";

--Изменяем контекст соединения на базу данных School
GRANT SELECT,UPDATE,INSERT ON dbo.schedule TO Teacher
GRANT SELECT ON dbo.lesson_time TO Teacher
GRANT SELECT ON dbo.quarter_data TO Teacher
GRANT SELECT ON dbo.menu TO Teacher
GRANT SELECT ON dbo.dishes TO Teacher
GRANT SELECT ON dbo.category_dish TO Teacher
GRANT SELECT ON dbo.employees TO Teacher
GRANT SELECT ON dbo.teachers TO Teacher
GRANT SELECT ON dbo.service_staff TO Teacher
GRANT SELECT ON dbo.parents TO Head_teacher
GRANT SELECT,UPDATE,INSERT ON dbo.marks TO Teacher
GRANT EXECUTE On dbo.change_discipline_scsedule TO Teacher
GRANT EXECUTE On dbo.busy_auditorium_6 TO Teacher
GRANT INSERT ON dbo.Audit_auditorium_2 TO Teacher
GRANT INSERT ON dbo.Audit_auditorium TO Teacher

GO  

--4) Заведующий столовой
--Kirilov_Roman_Olegovich
--Добавим еще разрешение на удаление заведующим записей в таблицах блюд и меню
CREATE LOGIN "Кириллов Роман Олегович"  WITH PASSWORD='4444'; 
GO  

CREATE USER "Кириллов Роман Олегович" FOR LOGIN "Кириллов Роман Олегович";
go

CREATE ROLE Manager_dining_room
GO

EXECUTE sp_addrolemember "Manager_dining_room", "Кириллов Роман Олегович";

--Изменяем контекст соединения на базу данных School
GRANT SELECT ON dbo.learners TO Manager_dining_room
GRANT SELECT ON dbo.employees TO Manager_dining_room
GRANT SELECT ON dbo.teachers TO Manager_dining_room
GRANT SELECT ON dbo.service_staff TO Manager_dining_room
GRANT SELECT ON dbo.lesson_time TO Manager_dining_room
GRANT SELECT,UPDATE,INSERT,DELETE ON dbo.menu TO Manager_dining_room
GRANT SELECT,UPDATE,INSERT,DELETE  ON dbo.dishes TO Manager_dining_room
GRANT SELECT,UPDATE,INSERT,DELETE  ON dbo.category_dish TO Manager_dining_room

GO  

--5) Заведующий учебной частью
--Platonova_Svetlana_Yurevna
--Добавим еще разрешение на удаление для некоторых таблиц (не было указано в задании)
CREATE LOGIN "Платонова Светлана Юрьевна"  WITH PASSWORD='5555'; 
GO  

CREATE USER "Платонова Светлана Юрьевна" FOR LOGIN "Платонова Светлана Юрьевна";
go
CREATE ROLE "Head_teacher"
GO

EXECUTE sp_addrolemember "Head_teacher", "Платонова Светлана Юрьевна";

--Изменяем контекст соединения на базу данных School
GRANT SELECT,UPDATE,INSERT,DELETE ON dbo.learners TO Head_teacher
GRANT SELECT,UPDATE,INSERT,DELETE ON dbo.teachers TO Head_teacher
GRANT SELECT,UPDATE,INSERT,DELETE ON dbo.marks TO Head_teacher
GRANT SELECT,UPDATE,INSERT,DELETE ON dbo.subjects TO Head_teacher
GRANT SELECT,UPDATE,INSERT,DELETE ON dbo.schedule TO Head_teacher
GRANT SELECT,UPDATE,INSERT,DELETE ON dbo.classes TO Head_teacher
GRANT SELECT,UPDATE,INSERT,DELETE ON dbo.lesson_time TO Head_teacher
GRANT SELECT,UPDATE,INSERT,DELETE ON dbo.parents TO Head_teacher
GRANT SELECT ON dbo.quarter_data TO Head_teacher
GRANT SELECT ON dbo.employees TO Head_teacher
GRANT SELECT ON dbo.service_staff TO Head_teacher
GRANT SELECT ON dbo.menu TO Head_teacher
GRANT SELECT ON dbo.category_dish TO Head_teacher
GRANT SELECT ON dbo.dishes TO Head_teacher
GRANT SELECT,UPDATE,INSERT,DELETE ON dbo.Audit_auditorium_2 TO Head_teacher
GRANT SELECT,UPDATE,INSERT,DELETE ON dbo.Audit_auditorium TO Head_teacher

GO  

--Предоставляем роли Head_teacher разрешение EXECUTE для хранимой процедуры добавления учителей  в таблицу сотрудников
GRANT EXECUTE On dbo.new_teacher_employees TO Head_teacher
GRANT EXECUTE On dbo.new_learner TO Head_teacher
GRANT EXECUTE On dbo.change_status_laid_offf_employee TO Head_teacher
GRANT EXECUTE On dbo.change_discipline_scsedule TO Head_teacher

--6) Директор
--есть 3 способа
--1 - создавать все привилегии как было сделано выше
--2 - разрешить все и потом сделать revoke для таблиц menu и dishes
--3 - передать привилегии админа и сделать revoke
--Pavluk_Svetlana_Yurevna

CREATE LOGIN "Павлюк Светлана Юрьевна" WITH PASSWORD='6666';
GO

CREATE USER "Павлюк Светлана Юрьевна" FOR LOGIN "Павлюк Светлана Юрьевна"
GO

CREATE ROLE Director
GO

EXECUTE sp_addrolemember "Director", "Павлюк Светлана Юрьевна";

--Изменяем контекст соединения на базу данных School
GRANT SELECT,UPDATE,INSERT,DELETE ON dbo.learners TO Director
GRANT SELECT,UPDATE,INSERT,DELETE ON dbo.teachers TO Director
GRANT SELECT,UPDATE,INSERT,DELETE ON dbo.marks TO Director
GRANT SELECT,UPDATE,INSERT,DELETE ON dbo.subjects TO Director
GRANT SELECT,UPDATE,INSERT,DELETE ON dbo.schedule TO Director
GRANT SELECT,UPDATE,INSERT,DELETE ON dbo.classes TO Director
GRANT SELECT,UPDATE,INSERT,DELETE ON dbo.employees TO Director
GRANT SELECT,UPDATE,INSERT,DELETE ON dbo.service_staff TO Director
GRANT SELECT,UPDATE,INSERT,DELETE ON dbo.lesson_time TO Director
GRANT SELECT,UPDATE,INSERT,DELETE ON dbo.quarter_data TO Director
GRANT SELECT ON dbo.menu TO Director
GRANT SELECT ON dbo.dishes TO Director
GRANT SELECT ON dbo.category_dish TO Director
GRANT SELECT,UPDATE,INSERT,DELETE ON dbo.parents TO Director
GRANT SELECT,UPDATE,INSERT,DELETE ON dbo.Audit_auditorium_2 TO Director
GRANT SELECT,UPDATE,INSERT,DELETE ON dbo.Audit_auditorium TO Director

GO  

--Предоставляем роли Head_teacher разрешение EXECUTE для хранимой процедуры добавления учителей  в таблицу сотрудников
GRANT EXECUTE On dbo.new_teacher_employees TO Head_teacher
GRANT EXECUTE On dbo.new_learner TO Head_teacher
GRANT EXECUTE On dbo.change_status_laid_offf_employee TO Head_teacher
GRANT EXECUTE On dbo.change_discipline_scsedule TO Head_teacher 

--Создание джобов
/*1)	Резервное копирование БД. Каждую ночь в 00:01:00 будет осуществляться полный бэкап базы;*/

/*syscategories
sp_add_category
sp_add_job
sp_add_jobstep
sp_update_job
sp_add_jobschedule
sp_add_jobserver
*/
USE [msdb]
GO

IF NOT EXISTS (SELECT name FROM msdb.dbo.syscategories WHERE name=N'[Uncategorized (Local)]' AND category_class=1) --Тип элемента в категории:1 = Задание

BEGIN
EXEC msdb.dbo.sp_add_category @class=N'JOB', @type=N'LOCAL', @name=N'[Uncategorized (Local)]'

END

DECLARE @jobId BINARY(16)
EXEC msdb.dbo.sp_add_job @job_name=N'backup_bd316', 
		@enabled=1, 
		@notify_level_eventlog=0, 
		@notify_level_email=0, 
		@notify_level_netsend=0, 
		@notify_level_page=0, 
		@delete_level=0, 
		@category_name=N'[Uncategorized (Local)]', 
		@owner_login_name=N'sa', 
		@job_id = @jobId OUTPUT
		--Идентификационный номер задания, присваиваемый заданию после успешного создания.
		-- Аргумент job_id является выходной переменной типа uniqueidentifier со значением по умолчанию NULL
EXEC msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'backup_step_1', 
		@step_id=1, 
		@cmdexec_success_code=0, 
		@on_success_action=1, 
		@on_success_step_id=0, 
		@on_fail_action=2, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, 
		@subsystem=N'TSQL', 
		@command=N'backup database db316 
				   to disk = "e:\my_backup\db316.bak"
				   with format, 
				   medianame = "D_SQLServerBCKP", 
				   name = "Test backup"', 
		@database_name=N'db316', 
		@flags=0
EXEC msdb.dbo.sp_update_job 
		@job_id = @jobId, 
		@start_step_id = 1 --Идентификатор первого этапа, выполняемого в ходе задания.
EXEC msdb.dbo.sp_add_jobschedule 
		@job_id=@jobId, 
		@name=N'backup_schedule_1', 
		@enabled=1, 
		@freq_type=4, --ежедневно
		@freq_interval=1, --один раз 
		@freq_subday_type=1, --в указ время
		@freq_subday_interval=0, 
		@freq_relative_interval=0, 
		@freq_recurrence_factor=0, 
		@active_start_date=20161224, 
		@active_end_date=99991231, 
		@active_start_time=100, --ЧЧMMСС
		@active_end_time=235959, --не имеет значения по умолчанию
		@schedule_uid=N'1e3a0fe3-8ee4-4fb4-b1cc-34b9145ca8a1'

EXEC msdb.dbo.sp_add_jobserver @job_id = @jobId, @server_name = N'(local)'  --Отправляет указанное задание на указанный сервер.

go

/*
backup database db316 
to disk = 'e:\my_backup\db316.bak'
with format, 
medianame = 'D_SQLServerBCKP', 
name = 'Test backup';
*/

/*2)	Каждую ночь в 00:30:00  создается новое меню, которое будет выставлено через 3 дня. Ответственным поваром за него назначается тот, который меньше всего раз был таковым за прошедшие 10 дней;
Затем в 00:40:00 в новое меню копируются все блюда, которые были в меню десятидневной давности.*/
use db316
go
/*select * from menu
	where menu_data between DATEADD(day, -10, CAST(GETDATE() as date)) and DATEADD(day, -1, CAST(GETDATE() as date))
	select * from #temp1
	*/

USE [msdb]
GO

IF NOT EXISTS (SELECT name FROM msdb.dbo.syscategories WHERE name=N'[Uncategorized (Local)]' AND category_class=1)
BEGIN
EXEC  msdb.dbo.sp_add_category @class=N'JOB', @type=N'LOCAL', @name=N'[Uncategorized (Local)]'
END

DECLARE @jobId BINARY(16)
EXEC msdb.dbo.sp_add_job @job_name=N'new_menu', 
		@enabled=1, 
		@notify_level_eventlog=0, 
		@notify_level_email=0, 
		@notify_level_netsend=0, 
		@notify_level_page=0, 
		@delete_level=0, 
		@category_name=N'[Uncategorized (Local)]', 
		@owner_login_name=N'sa', @job_id = @jobId OUTPUT

EXEC msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'menu_action', 
		@step_id=1, 
		@cmdexec_success_code=0, 
		@on_success_action=1, 
		@on_success_step_id=0, 
		@on_fail_action=2, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'
declare @responsible_cooker_id int, @menu_data date

set @menu_data = DATEADD(day, 3, CAST(GETDATE() as date))
set @responsible_cooker_id = 1

create table #temp11(
  staff_id int not null,
  number_working_day int not null,

) 

--заполним временную таблицу поварами и количеством дней, проработанных ими за последние 10 в качестве ответственных 
insert #temp11(staff_id, number_working_day) 
(
select ser.staff_id, count(m.responsible_cooker_id) as [number_working_day]
       from menu as m
	     join service_staff as ser on ser.staff_id = m.responsible_cooker_id
	     where menu_data between DATEADD(day, -10, CAST(GETDATE() as date)) and DATEADD(day, -1, CAST(GETDATE() as date))
	   group by ser.staff_id
	   --order by count(m.responsible_cooker_id)
)

set @responsible_cooker_id = (select top(1) staff_id as [@responsible_cooker_id]
								 from #temp11
								  order by number_working_day ASC
								 )

insert into dbo.menu(menu_data, responsible_cooker_id) 
    values (@menu_data, @responsible_cooker_id )


drop table #temp11

go', 
		@database_name=N'db316', 
		@flags=0

EXEC msdb.dbo.sp_update_job 
        @job_id = @jobId,
		@start_step_id = 1

EXEC msdb.dbo.sp_add_jobschedule @job_id=@jobId, @name=N'menu_schedule', 
		@enabled=1, 
		@freq_type=4, 
		@freq_interval=1, 
		@freq_subday_type=1, 
		@freq_subday_interval=0, 
		@freq_relative_interval=0, 
		@freq_recurrence_factor=0, 
		@active_start_date=20161225, 
		@active_end_date=99991231, 
		@active_start_time=3000, 
		@active_end_time=235959, 
		@schedule_uid=N'62eb3383-1310-4a6b-9f48-e319fa740604'

EXEC msdb.dbo.sp_add_jobserver @job_id = @jobId, @server_name = N'(local)'

GO


/*
select * from dishes
   where menu_id = 1443*/
--***********************************************************************************************************

USE [msdb]
GO

IF NOT EXISTS (SELECT name FROM msdb.dbo.syscategories WHERE name=N'[Uncategorized (Local)]' AND category_class=1)
BEGIN
EXEC msdb.dbo.sp_add_category @class=N'JOB', @type=N'LOCAL', @name=N'[Uncategorized (Local)]'
END

DECLARE @jobId BINARY(16)
EXEC  msdb.dbo.sp_add_job @job_name=N'dishes_copy', 
		@enabled=1, 
		@notify_level_eventlog=0, 
		@notify_level_email=0, 
		@notify_level_netsend=0, 
		@notify_level_page=0, 
		@delete_level=0, 
		@category_name=N'[Uncategorized (Local)]', 
		@owner_login_name=N'sa', @job_id = @jobId OUTPUT

EXEC msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'copy_dishes_step', 
		@step_id=1, 
		@cmdexec_success_code=0, 
		@on_success_action=1, 
		@on_success_step_id=0, 
		@on_fail_action=2, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, 
		@subsystem=N'TSQL', 
		@command=N'
declare @menu_data date, @menu_id int

--set @menu_id = SCOPE_IDENTITY(). будет 1443

set @menu_data = DATEADD(day, 3, CAST(GETDATE() as date))

set @menu_id = (
          select menu_id 
		    from menu
			where menu_data = @menu_data)

--проблема в подстановке правильного menu_id  для скопированных блюд


insert into dbo.dishes(dish_name, category_dish_id, dish_count, dish_price, menu_id) 
(
		select d.dish_name, d.category_dish_id, d.dish_count, d.dish_price, @menu_id as [menu_id]--''2016-11-15''--DATEADD(day, -10, CAST(GETDATE() as date))@menu_id
		  from dishes as d
		  join menu as m on d.menu_id = m.menu_id
		    where m.menu_data= DATEADD(day, -10, CAST(GETDATE() as date))
 )

 go', 
		@database_name=N'db316', 
		@flags=0

EXEC msdb.dbo.sp_update_job 
		@job_id = @jobId, 
		@start_step_id = 1

EXEC msdb.dbo.sp_add_jobschedule @job_id=@jobId, @name=N'menu_copy_schedule', 
		@enabled=1, 
		@freq_type=4, 
		@freq_interval=1, 
		@freq_subday_type=1, 
		@freq_subday_interval=0, 
		@freq_relative_interval=0, 
		@freq_recurrence_factor=0, 
		@active_start_date=20161225, 
		@active_end_date=99991231, 
		@active_start_time=4000, 
		@active_end_time=235959, 
		@schedule_uid=N'675c16ad-93b2-43b1-91b7-898de7de862a'

EXEC msdb.dbo.sp_add_jobserver @job_id = @jobId, @server_name = N'(local)'

go

/*3)	Каждый год 10ого июня в 02:00:00 проходит перевод всех учеников, не являющихся выпускниками, в следующий класс (буква сохраняется).
*/

USE [msdb]
GO

IF NOT EXISTS (SELECT name FROM msdb.dbo.syscategories WHERE name=N'[Uncategorized (Local)]' AND category_class=1)
BEGIN
EXEC msdb.dbo.sp_add_category @class=N'JOB', @type=N'LOCAL', @name=N'[Uncategorized (Local)]'

END

DECLARE @jobId BINARY(16)
EXEC msdb.dbo.sp_add_job @job_name=N'learners_job', 
		@enabled=1, 
		@notify_level_eventlog=0,-- = 3 
		@notify_level_email=0, 
		@notify_level_netsend=0, 
		@notify_level_page=0, 
		@delete_level=0,  
		@category_name=N'[Uncategorized (Local)]', 
		@owner_login_name=N'sa', @job_id = @jobId OUTPUT

EXEC msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'action', 
		@step_id=1, 
		@cmdexec_success_code=0, 
		@on_success_action=1, 
		@on_success_step_id=0, 
		@on_fail_action=2, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'declare @i int, @year_of_education tinyint
					set @i = 1
					set @year_of_education = 1

					WHILE @i <= (select max(class_id) from dbo.classes)
						
						BEGIN

						 update dbo.classes
							set year_of_education = year_of_education + 1
							  from classes 
							  where (class_id = @i) and  (year_of_education <>  0)

						update dbo.classes
							set year_of_education = 0
								from classes 
								where (class_id = @i) and  (year_of_education = 12)

						set @i = @i + 1 

						END', 
		@database_name=N'db316', 
		@flags=0 --нет никаких дополнительных опций (это значение по умолчанию);

EXEC msdb.dbo.sp_update_job @job_id = @jobId, @start_step_id = 1

EXEC msdb.dbo.sp_add_jobschedule @job_id=@jobId, @name=N'learner_schedule', 
		@enabled=1, 
		@freq_type=16, --ежемесячно
		@freq_interval=10, -- ?
		@freq_subday_type=1,  -- количество периодов между выполнениями задания
		@freq_subday_interval=0, 
		@freq_relative_interval=0, 
		@freq_recurrence_factor=12, -- каждые 12 месяцев 
		@active_start_date=20170610, 
		@active_end_date=99991231, 
		@active_start_time=20000, --02:00:00
		@active_end_time=235959, 
		@schedule_uid=N'8317137a-b71f-4313-8813-a62b97b84d54'

EXEC msdb.dbo.sp_add_jobserver @job_id = @jobId, @server_name = N'(local)'


--откат
use db316
select * from classes

declare @i int, @year_of_education tinyint
set @i = 1
set @year_of_education = 1

WHILE @i <= (select max(class_id) from dbo.classes)
BEGIN

   update dbo.classes
    set year_of_education = year_of_education - 1
	    from classes 
	    where (class_id = @i) and  (year_of_education <>  0)

   update dbo.classes
    set year_of_education = 11
	    from classes 
	    where (class_id = @i) and  (year_of_education = 0)

	set @i = @i + 1 

END


-- Блок удаления объектов

if exists (select * from dbo.sysobjects 
                 where id = object_id(N'dbo.employees') and objectproperty(id, N'IsUserTable') = 1)

  drop table dbo.employees

GO

if exists (select * from dbo.sysobjects 
                 where id = object_id(N'dbo.teachers') and objectproperty(id, N'IsUserTable') = 1)

   drop table dbo.teachers

GO

if exists (select * from dbo.sysobjects 
                 where id = object_id(N'dbo.subjects') and objectproperty(id, N'IsUserTable') = 1)

   drop table dbo.subjects

GO

if exists (select * from dbo.sysobjects 
                 where id = object_id(N'dbo.schedule') and objectproperty(id, N'IsUserTable') = 1)

   drop table dbo.schedule

GO

if exists (select * from dbo.sysobjects 
                 where id = object_id(N'dbo.quarter_data') and objectproperty(id, N'IsUserTable') = 1)

   drop table dbo.quarter_data

GO

if exists (select * from dbo.sysobjects 
                 where id = object_id(N'dbo.menu') and objectproperty(id, N'IsUserTable') = 1)

   drop table dbo.menu

GO

if exists (select * from dbo.sysobjects 
                 where id = object_id(N'dbo.marks') and objectproperty(id, N'IsUserTable') = 1)

   drop table dbo.marks

GO

if exists (select * from dbo.sysobjects 
                 where id = object_id(N'dbo.lesson_time') and objectproperty(id, N'IsUserTable') = 1)

   drop table dbo.lesson_time

GO

if exists (select * from dbo.sysobjects 
                 where id = object_id(N'dbo.learners') and objectproperty(id, N'IsUserTable') = 1)

   drop table dbo.learners

GO

if exists (select * from dbo.sysobjects 
                 where id = object_id(N'dbo.service_staff') and objectproperty(id, N'IsUserTable') = 1)

   drop table dbo.service_staff

GO

if exists (select * from dbo.sysobjects 
                 where id = object_id(N'dbo.dishes') and objectproperty(id, N'IsUserTable') = 1)

   drop table dbo.dishes

GO

if exists (select * from dbo.sysobjects 
                 where id = object_id(N'dbo.classes') and objectproperty(id, N'IsUserTable') = 1)

   drop table dbo.classes

GO

if exists (select * from dbo.sysobjects 
                 where id = object_id(N'dbo.category_dish') and objectproperty(id, N'IsUserTable') = 1)

   drop table dbo.category_dish

GO

if exists (select * from dbo.sysobjects 
                 where id = object_id(N'dbo.parents') and objectproperty(id, N'IsUserTable') = 1)

   drop table dbo.parents

GO
------------------------------------------------------------------------
alter table dbo.employees
  drop
  constraint employee_phone_check

alter table dbo.teachers
  drop
  constraint employees_experience_check
GO

alter table dbo.teachers
  drop
  constraint teacher_age_check 
GO
--------------------------------------------------------------------
  -- drop связей

alter table dbo.teachers
  drop
  constraint FK_teachers_employee_id
GO

 alter table dbo.service_staff
  drop
  constraint FK_service_staff_employee_id
GO 

alter table dbo.marks
  drop
  constraint FK_marks_subject_id 
GO 

alter table dbo.marks
  drop
  constraint FK_marks_learner_id 
GO 

alter table dbo.marks
  drop
  constraint FK_marks_mark_data 
GO 

alter table dbo.learners
  drop
  constraint FK_learners_class_id 
GO 

alter table dbo.schedule
  drop
  constraint FK_schedule_class_id 
GO 

alter table dbo.schedule
  drop
  constraint FK_schedule_subject_id 
GO 

alter table dbo.schedule
  drop
  constraint FK_schedule_teacher_id 
GO 

alter table dbo.schedule
  drop
  constraint FK_schedule_number_lesson 
GO 

alter table dbo.schedule
  drop
  constraint FK_schedule_quarter_data
GO 


alter table dbo.menu
  drop
  constraint FK_menu_responsible_cooker_id
GO 

alter table dbo.dishes
  drop
  constraint FK_dishes_responsible_menu_id 
GO 

alter table dbo.dishes
  drop
  constraint FK_dishes_category_dish_id

  alter table dbo.learners
  drop
  constraint FK_learners_parent_id

---------------------------------------------------------------------------

--блок очищения бд

delete from dbo.employees
GO

delete from dbo.teachers
GO

delete from dbo.subjects
GO

delete from dbo.schedule
GO

delete from dbo.quarter_data
GO

delete from dbo.menu
GO

delete from dbo.marks
GO

delete from dbo.lesson_time
GO

delete from dbo.learners
GO

delete from dbo.service_staff
GO

delete from dbo.dishes
GO

delete from dbo.classes
GO

delete from dbo.category_dish
GO

delete from dbo.parents
GO
