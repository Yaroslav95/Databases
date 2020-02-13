create database it_project
use it_project


--1. Создание таблиц

create table employers(
  emp_id int not null identity primary key,
  name varchar(60) not null,
  addr_id int not null,
  phone_id int not null
)
GO 



create table vac_categs(
  vac_categ_id int not null identity primary key,
  name varchar(40) not null
)


select * from vac_categs


create table vacancies(
  vac_id int not null identity primary key,
  emp_id int not null,
  vac_categ_id int not null,
  name varchar(60) not null,
  class int null,
  start_data date not null,
  end_data date not null,
  req_id int not null,
  def varchar(300) null
 )
GO 


alter table vacancies
  add
  constraint FK_vac_categ_id foreign key (vac_categ_id)
    references dbo.vac_categs(vac_categ_id)
GO

alter table vacancies
  add
  constraint FK_emp_vacs_id foreign key (emp_id)
    references dbo.employers(emp_id)
GO



create table candidates(
  cand_id int not null identity primary key,
  name varchar(60) not null,
  pol varchar(1) not null,
  birthday date null,
  addr_id int not null,
  phone_id int not null,
  req_id int not null,
  cand_coef_id int not null
)
GO 


create table addresses(
 addr_id int not null identity primary key,
 belong_id int null,
 addr varchar(50) not null
)


create table phones(
 phone_id int not null identity primary key,
 belong_id int null,
 phone varchar(50) not null
)


alter table employers
  add
  constraint FK_emp_addr_id foreign key (addr_id)
    references dbo.addresses(addr_id)
GO


alter table employers
  add
  constraint FK_emp_phone_id foreign key (phone_id)
    references dbo.phones(phone_id)
GO

alter table candidates
  add
  constraint FK_cand_addr_id foreign key (addr_id)
    references dbo.addresses(addr_id)
GO

alter table candidates
  add
  constraint FK_cand_phone_id foreign key (phone_id)
    references dbo.phones(phone_id)
GO


create table requirements(
  req_id int not null identity primary key,
  belong int not null,
  spec_id int not null,
  salary int not null,
  experience int not null,
  age int not null,
  pay_form_id int not null,
  work_time_id int not null,
  ex_car bit not null,
  ex_soc_pack bit not null,
  ex_hosp bit not null,
  ex_damage bit not null,
  form_work_id int not null,
  ex_career bit not null,
  spec_cond_id int null
)


alter table vacancies
 add
  constraint FK_vac_req_id foreign key (req_id)
    references dbo.requirements(req_id)
GO

alter table candidates
 add
  constraint FK_cand_req_id foreign key (req_id)
    references dbo.requirements(req_id)
GO



create table cand_coefficient(
  cand_coef_id int not null identity primary key,
  k_salary float not null,
  k_experience float not null,
  k_age float not null,
  k_pay_form_id float not null,
  k_work_time_id float not null,
  k_ex_soc_pack float not null,
  k_ex_hosp float not null,
  k_ex_damage float not null,
  k_form_work_id float not null,
  k_ex_career float not null,
  k_spec_cond_id float null

)
GO



alter table candidates
 add
  constraint FK_cand_coef_id foreign key (cand_coef_id)
    references dbo.cand_coefficient(cand_coef_id)
GO


create table specialities(
   spec_id int not null identity primary key,
   name varchar(60) not null,
   def varchar(100) null,
)
GO


alter table requirements
  add
  constraint FK_spec_cand_conds_id foreign key (spec_id)
    references dbo.specialities(spec_id)
GO

create table pay_forms(
   pay_form_id int not null identity primary key,
   name varchar(20) not null
)
GO

select * from pay_forms

alter table requirements
  add
  constraint FK_pay_form_cand_conds_id foreign key (pay_form_id)
    references dbo.pay_forms(pay_form_id )
GO


create table work_times(
   work_time_id int not null identity primary key,
   name varchar(20) not null
)
GO

alter table requirements
  add
  constraint FK_work_time_cand_conds_id foreign key (work_time_id)
    references dbo.work_times(work_time_id)
GO


create table forms_work(
   form_work_id int not null identity primary key,
   name varchar(20) not null
)
GO

alter table requirements
  add
  constraint FK_form_work_cand_conds_id foreign key (form_work_id)
    references dbo.forms_work(form_work_id)
GO


create table spec_conds(
   spec_cond_id int not null identity primary key,
   name varchar(200) not null
)
GO
  

alter table requirements
  add
  constraint FK_spec_cond_vac_conds_id foreign key (spec_cond_id)
    references dbo.spec_conds(spec_cond_id)
GO



--2. Наполнение базы данных

select * from employers;
select * from specialities;
select * from vacancies;
select * from pay_forms;
select * from work_times;
select * from forms_work fw
select * from candidates

select * from spec_conds
select * from addresses
select * from phones



if exists (select * from dbo.sysobjects 
                  where id = object_id(N'dbo.new_employer')  and objectproperty(id, N'IsProcedure') = 1
               )
   drop procedure dbo.new_employer
GO
--Условие необходимо для того, чтобы выполнить ограничения учителей по возрасту и не добавлять неподходящие записи,
-- но далее будет создан триггер

create proc dbo.new_employer
 
  @name varchar(60), 
  @addresss varchar(50),
  @phone varchar(25)
  

AS
 
  begin
    insert into dbo.employers(name, addresss, phone)
      values(@name,@addresss,@phone) 
  end
	   
GO
 
exec dbo.new_employer 'Титансофт', 'Попова 27а', '8-922-77-21-448'
exec dbo.new_employer 'Яндекс', '8 Марта 57', '8-922-44-71-636'


insert into employers
(name, addr_id, phone_id)
values
  ('Яндекс', 1, 1),
  ('СКБ-Контур', 2, 2),
  ('Титансофт', 3, 3),
  ('Сбербанк', 4, 4),
  ('МегаФон', 5, 5),
  ('ПроСофт', 6, 6),
  ('Наумен', 7, 7),
  ('Колибри', 8, 8),
  ('НПО Автоматика', 9, 9)

/**************************************************************************/

insert into addresses
(belong_id, addr)
values
  (null, 'Попова 27а'),
  (null, 'Газовиков 6'),
  (null,'Азина 12' ),
  (null, 'Азина 47'),
  (null, 'Гагарина 45'),
  (null, 'Железгодорожная 77'),
  (null, 'Гагарина 12'),
  (null, 'Ленина 22'),
  (null, 'Лесная 17'),
  (null, 'Железногодорожная 30'),
  (null, 'Коммунистов 20'),
  (null, 'Гагарина 76'),
  (null, 'Коминтерна 11'),
  (null, 'Перевозчиков 2'),
  (null, 'Жукова 8'),
  (null, 'Декабристов 15'),
  (null, 'Магистерская 14'),
  (null, 'Малышева 121'),
  (null, 'Комсомольская 72'),
  (null, 'Первомайская 18'),
  (null, 'Луначарского 18'),
  (null, 'Первомайская 5'),
  (null, 'Ленина 15'),
  (null, 'Ленина 77'),
  (null, 'Маркова 77'),
  (null, 'Первомайская 10'),
  (null, 'Попова 19'),
  (null,'Космонавтов 7'),
  (null, 'Новой эры 18'),
  (null, 'Свиридова 12'),
  (null, 'Чапаева 10'),
  (null, 'Московская 61'),
  (null, 'Мичурина 14'),
  (null, 'Кузнечная 2'),
  (null, 'Тургенева 6'),
  (null, 'Достоевского 4'),
  (null, 'Летчиков 17'),
  (null, 'Бебеля 24'),
  (null, 'Халтурина 18'),
  (null, 'Хохрякова 53'),
  (null, 'Ленина 63'),
  (null, 'Малышева 150'),
  (null, 'Красноармейская 3'),
  (null, 'Библиотечная 7'),
  (null, 'Сибирская 75'),
  (null, 'Луначарского 8'),
  (null, 'Пушкина 14'),
  (null, 'Академическая 15'),
  (null, 'Космонавтов 36'),
  (null, 'Малышева 166'),
  (null, 'Авиационная 15'),
  (null, 'Чапаева 14')

GO


insert into phones
(belong_id, phone)
values
  (null, '8-964-18-77-119'),
  (null, '8-922-77-21-448'),
  (null, '8-912-06-71-428'),
  (null, '8-905-76-71-136'),
  (null, '8-922-44-71-636'),
  (null, '7-25-59'),
  (null, '8-955-46-72-036'),
  (null, '8-92-77-21-448'),
  (null, '8-906-72-31-548'),
  (null, '8-912-70-01-008'),
  (null, '8-855-00-11-043'),
  (null, '8-700-05-11-453'),
  (null, '8-895-04-61-857'),
  (null, '8-870-45-81-375'),
  (null, '8-895-04-61-885'),
  (null, '8-895-04-62-896'),
  (null, '8-912-05-63-904'),
  (null, '8-922-08-66-931'),
  (null, '8-922-09-67-942'),
  (null, '8-922-10-68-954'),
  (null, '8-922-11-69-969'),
  (null, '8-965-13-70-988'),
  (null, '8-965-13-42-987'),
  (null, '8-967-15-72-004'),
  (null, '8-964-18-77-095'),
  (null, '8-964-18-76-083'),
  (null, '8-964-18-77-014'),
  (null, '8-964-18-77-112'),
  (null, '8-964-18-77-010'),
  (null, '8-964-18-77-113'),
  (null, '8-964-18-77-118'),
  (null, '8-964-18-77-120'),
  (null, '7-40-10')

GO



insert into specialities
(name, def)
values
  ('Информатика и вычислительная техника',null ),
  ('Прикладная математика и информатика',null),
  ('Информационная безопасность',null ),
  ('Программирование в компьютерных системах', null),
  ('Информационные системы и технологии	ИКТ', null),
  ('Программная инженерия', null),
  ('Инфокоммуникационные технологии и системы связи', null),
  ('Конструирование и технология электронных средств', null),
  ('Приборостроение', null),
  ('Прикладная математика', null),
  ('Фотоника и оптоинформатика', null),
  ('Управление в технических системах', null),
  ('Системный анализ данных и управление', null),
  ('Бизнес-информатика', null),
  ('Интеллектуальные системы', null),
  ('Математика и компьютерные науки', null),
  ('Фундаментальная информатика и информационные технологии', null)
  
GO

insert into pay_forms
(name)
values
  ('Оклад' ),
  ('Повременная'),
  ('Сдельная'),
  ('Разовый договор')
  
GO


insert into work_times
(name)
values
  ('Дневной' ),
  ('Ночной'),
  ('Посменный')
  
GO


insert into forms_work
(name)
values
  ('На одном месте' ),
  ('Частые командировки'),
  ('Вахтовый')
  
GO


insert into spec_conds
(name)
values
  ('Необходим гибкий график из-за учебы' ),
  ('Необходим корпоративный транспорт' ),
  ('Важна спортивная жизнь компании' ),
  ('Без командировок и ночных дежурств' ),
  ('Внеочередные выходные из-за ребенка' ),
  ('Наличие образовательных курсов' )

GO



insert into vac_categs
(name)
values
  ('Web-верстка' ),
  ('Web-дизайн' ),
  ('Аналитика' ),
  ('Проектирование, документация' ),
  ('Базы данных, администрирование' ),
  ('Банковское, финансовое, биллинговое' ),
  ('Без спец. подготовки' ),
  ('Интернет, создание и поддержка сайтов' ),
  ('Консалтинг' ),
  ('Контент' ),
  ('Мультимедиа' ),
  ('Оптимизация, SEO' ),
  ('Программирование, разработка' ),
  ('Разработка игрового ПО' ),
  ('Сетевые технологии' ),
  ('Системы автоматизированного проектир' ),
  ('Системы управления предприятием ERP'),
  ('Программирование'),
  ('Системное администрирование' ),
  ('Техническая поддержка' ),
  ('Тестирование' ),
  ('Сетевые технологии' ),
  ('Телекоммуникационные системы и связь' ),
  ('Компьютерная безопасность' ),
  ('Компьютерное зрение' ),
  ('Анализ данных' ),
  ('Фундаментальная информатика' ),
  ('Робототехника' ),
  ('Управление проектами' ),
  ('Другое' )
GO



if exists (select * from dbo.sysobjects 
                  where id = object_id(N'dbo.new_cand_koef')  and objectproperty(id, N'IsProcedure') = 1
               )
   drop procedure dbo.new_cand_koef
GO

create proc dbo.new_cand_koef

  @k_salary float,
  @k_experience float,
  @k_age float,
  @k_pay_form_id float,
  @k_work_time_id float,
  @k_ex_soc_pack float,
  @k_ex_hosp float,
  @k_ex_damage float,
  @k_form_work_id float,
  @k_ex_career float,
  @k_spec_cond_id float
 
AS


insert into cand_coefficient
       (k_salary, k_experience, k_age, k_pay_form_id,k_work_time_id, k_ex_soc_pack, k_ex_hosp, k_ex_damage, k_form_work_id, k_ex_career, k_spec_cond_id)
values ( @k_salary, @k_experience, @k_age,@k_pay_form_id, @k_work_time_id,  @k_ex_soc_pack, @k_ex_hosp, @k_ex_damage, @k_form_work_id, @k_ex_career, @k_spec_cond_id)

GO

exec dbo.new_cand_koef  2, 0.5, 1, 0.3, 1, 0.5, 0.5, 1.5, 0.5, 1.5, 0.7 --сумма дает 10

select * from cand_coefficient

delete vacancies
delete requirements


/************************************************************************/

if exists (select * from dbo.sysobjects 
                  where id = object_id(N'dbo.new_cand_req')  and objectproperty(id, N'IsProcedure') = 1
               )
   drop procedure dbo.new_cand_req
GO


create proc dbo.new_cand_req
 
  @name varchar(60),
  @pol varchar(1),
  @birthday date,
  @addr_id int,
  @phone_id int,
  @req_id int,
  @cand_coef_id int,
  @spec_id int,
  @salary int,
  @experience int,
  @pay_form_id int,
  @work_time_id int,
  @ex_car bit,
  @ex_soc_pack bit,
  @ex_hosp bit,
  @ex_damage bit,
  @form_work_id int,
  @ex_career bit,
  @spec_cond_id int
 

AS
 
  begin
    

	insert into dbo.requirements (belong, spec_id, salary, experience, age, pay_form_id, work_time_id, ex_car, ex_soc_pack, ex_hosp, ex_damage, form_work_id, ex_career, spec_cond_id)
      values (2 , @spec_id, @salary, @experience, year(GETDATE())- year(@birthday), @pay_form_id, @work_time_id, @ex_car, @ex_soc_pack, @ex_hosp, @ex_damage, @form_work_id, @ex_career,  @spec_cond_id)
	 
      select @req_id = SCOPE_IDENTITY()


    insert into dbo.candidates (name, pol, birthday,  addr_id, phone_id, req_id, cand_coef_id)
      values (@name, @pol, @birthday,  @addr_id, @phone_id, @req_id, @cand_coef_id)
  end 
	   
GO



declare @req_id int
exec dbo.new_cand_req 'Симонов Валерий Петрович', 'м', '1987-07-04', 10, 10, @req_id, 1, 1, 45000, 3, 1, 1, 1, 1, 1, 0, 1, 1, null
exec dbo.new_cand_req 'Поливаев Артем Александрович', 'м', '1995-03-09', 11, 11, @req_id, 1, 5, 30000, 1, 1, 1, 0, 1, 1, 0, 1, 1, 1
exec dbo.new_cand_req 'Райхель Борис Владимирович', 'м', '1980-10-15', 12, 12, @req_id, 1, 7, 80000, 1, 1, 1, 1, 0, 0, 0, 3, 0, null


select * from candidates
select * from requirements


/********************************************************/



if exists (select * from dbo.sysobjects 
                  where id = object_id(N'dbo.new_vacancy')  and objectproperty(id, N'IsProcedure') = 1
               )
   drop procedure dbo.new_vacancy
GO



create proc dbo.new_vacancy
 
  @emp_id int,
  @vac_categ_id int,
  @name varchar(60),
  @class int,
  @start_data date,
  @end_data date,
  @req_id int,
  @def varchar(300),
  @spec_id int,
  @salary int,
  @experience int,
  @age int,
  @pay_form_id int,
  @work_time_id int,
  @ex_car bit,
  @ex_soc_pack bit,
  @ex_hosp bit,
  @ex_damage bit,
  @form_work_id int,
  @ex_career bit,
  @spec_cond_id int

AS
 
  begin

  insert into dbo.requirements (belong, spec_id, salary, experience, age, pay_form_id, work_time_id, ex_car, ex_soc_pack, ex_hosp, ex_damage, form_work_id, ex_career, spec_cond_id)
      values (1, @spec_id, @salary, @experience, @age, @pay_form_id, @work_time_id, @ex_car, @ex_soc_pack, @ex_hosp, @ex_damage, @form_work_id, @ex_career,  @spec_cond_id)

    select @req_id = SCOPE_IDENTITY()


  insert into dbo.vacancies (emp_id, vac_categ_id, name, class, start_data, end_data, req_id, def)
     values (@emp_id, @vac_categ_id, @name, @class, @start_data, @end_data,  @req_id, @def)

  end 
	   
GO



declare @req_id int 
exec dbo.new_vacancy 1, 5, 'Администратор базы данных SQL', null, '2018-04-26', '2018-05-15', @req_id, null, 2, 30000, 0, 40, 1, 1, 1, 1, 1, 1, 1, 1, null
exec dbo.new_vacancy 3, 1, 'Разработчик php', null, '2018-01-05', '2018-06-02', @req_id, null, 5, 40000, 1, 35, 1, 1, 0, 1, 1, 0, 1, 1, null


declare @req_id int
    exec dbo.new_vacancy 7, 21, 'Тестировщик ПО', null, '2018-05-05', '2018-06-06', @req_id, null, 16, 50000, 3, 27, 2, 1, 0, 1, 1, 0, 1, 0, 1



select * from vacancies
select * from requirements
select * from vac_categs
select * from specialities


/***********************************************************************/


--Создание логических функций

Для примера найдем подходящую вакансию для Симонова cand_id = 4  

if exists (select * from dbo.sysobjects 
                  where id = object_id(N'dbo.not_suit_vac_for_cand')  and objectproperty(id, N'IsProcedure') = 1
               )
   drop procedure dbo.not_suit_vac_for_cand
GO

create proc dbo.not_suit_vac_for_cand
 
  @cand_id int

AS
 
     declare @i int, @count int, @spec_id int, @salary int, @experience int, @age int, @ex_hosp bit, @pay_form_id bit, @work_time_id int, @ex_car bit, @ex_soc_pack bit, @ex_damage bit, @form_work_id int, @ex_career bit, @spec_cond_id int

	 create table #answer(
	  cand_id int not null,
	  name varchar(40) not null,
	  req_id int not null,
	  name2 varchar(40) not null,
	  W float not null 
	)
 
    set @i = 0
	set @count = 0
	set @count = (select max(req_id) from requirements)

     while (@i < @count)
	   begin
	     set @i = @i + 1		   

		  if (select belong from requirements where req_id = @i) = 1
		   begin

				--требования (условия) кандидата
		        set @spec_id = (select spec_id  from requirements req_c where req_c.req_id = (select req_id from candidates where cand_id = @cand_id)) -- cand_id)
				set @salary = (select salary from requirements req_c where req_c.req_id = (select req_id from candidates where cand_id = @cand_id)) -- cand_id)
				set @experience = (select experience from requirements req_c where req_c.req_id = (select req_id from candidates where cand_id = @cand_id)) 
				set @age = (select age from requirements req_c where req_c.req_id = (select req_id from candidates where cand_id = @cand_id)) 
				set @pay_form_id  = (select pay_form_id  from requirements req_c where req_c.req_id = (select req_id from candidates where cand_id = @cand_id)) 
				set @work_time_id = (select work_time_id  from requirements req_c where req_c.req_id = (select req_id from candidates where cand_id = @cand_id)) 
				set @ex_soc_pack = (select ex_soc_pack from requirements req_c where req_c.req_id = (select req_id from candidates where cand_id = @cand_id)) 
				set @ex_hosp = (select ex_hosp from requirements req_c where req_c.req_id = (select req_id from candidates where cand_id = @cand_id))
				set @ex_damage = (select ex_damage from requirements req_c where req_c.req_id = (select req_id from candidates where cand_id = @cand_id)) 
				set @form_work_id = (select form_work_id from requirements req_c where req_c.req_id = (select req_id from candidates where cand_id = @cand_id))
				set @ex_career = (select ex_career from requirements req_c where req_c.req_id = (select req_id from candidates where cand_id = @cand_id))
				set @spec_cond_id = (select spec_cond_id from requirements req_c where req_c.req_id = (select req_id from candidates where cand_id = @cand_id))    

			create table #temp(
				k_salary float not null,
				k_experience float not null,
				k_age float not null,
				k_pay_form_id float not null,
				k_work_time_id float not null,
				k_ex_soc_pack float not null,
				k_ex_hosp float not null,
				k_ex_damage float not null,
				k_form_work_id float not null,
				k_ex_career float not null,
				k_spec_cond_id float null		
			)

			insert into #temp 
			 select c.k_salary, c.k_experience, c.k_age, c.k_pay_form_id, c.k_work_time_id, c.k_ex_soc_pack, c.k_ex_hosp, c.k_ex_damage, c.k_form_work_id, c.k_ex_career, c.k_spec_cond_id from cand_coefficient c
			   where c.cand_coef_id = 1

			    if (select req_c.salary from requirements req_c where req_c.req_id = @i) > @salary
			   begin 
			      update #temp set k_salary = 0 
			   end
			
			  if (select req_c.experience from requirements req_c where req_c.req_id = @i) > @experience
			   begin 
			      update #temp set k_experience = 0 
			   end


			     if (select req_c.salary from requirements req_c where req_c.req_id = @i) < @age
			   begin 
			      update #temp set k_age = 0 
			   end


			if (select req_c.pay_form_id from requirements req_c where req_c.req_id = @i) != @pay_form_id
			   begin 
			      update #temp set k_pay_form_id = 0 
			   end

			if (select req_c.work_time_id from requirements req_c where req_c.req_id = @i) != @work_time_id
			   begin 
			      update #temp set k_work_time_id = 0 
			   end

			if (select req_c.ex_soc_pack from requirements req_c where req_c.req_id = @i) < @ex_soc_pack 
			   begin 
			      update #temp set k_ex_soc_pack  = 0 
				  
			   end

			if (select req_c.ex_hosp from requirements req_c where req_c.req_id = @i) < @ex_hosp
			   begin 
			      update #temp set k_ex_hosp= 0 
			   end

			if (select req_c.ex_damage from requirements req_c where req_c.req_id = @i) > @ex_damage
			   begin 
			      update #temp set k_ex_damage = 0 
			   end

			if (select req_c.form_work_id  from requirements req_c where req_c.req_id = @i) != @form_work_id 
			   begin 
			      update #temp set k_form_work_id  = 0 
			   end

			if (select req_c.ex_career from requirements req_c where req_c.req_id = @i) > @ex_career
			 begin    
				  update #temp set k_ex_career = 0 
			 end

			if (select req_c.spec_cond_id from requirements req_c where req_c.req_id = @i) <= @spec_cond_id
			 begin    
				  update #temp set k_spec_cond_id = 0 
			 end
		 

			   insert into #answer(cand_id, name, req_id, name2, W)
			    select c.cand_id, c.name, req_v.req_id, v.name, (select t.k_salary + t.k_experience + t.k_age + t.k_pay_form_id + t.k_work_time_id + t.k_ex_soc_pack + t.k_ex_career + t.k_ex_damage + t.k_ex_hosp + t.k_form_work_id + t.k_spec_cond_id from #temp t) as [W] from candidates c
				  join requirements req_c on c.req_id = req_c.req_id
				  cross join requirements req_v  
				 join vacancies v on v.req_id = req_v.req_id 
				   where c.cand_id = @cand_id
					and req_v.req_id = @i
				    and req_c.experience >= req_v.experience 
				    and req_c.age <= req_v.age

			drop table #temp

			end

	  IF @i = @count
         BREAK
      end

		 select * from #answer
		   order by W desc

		 drop table #answer

GO

select * from candidates


exec dbo.not_suit_vac_for_cand 7
exec dbo.not_suit_vac_for_cand 8
exec dbo.not_suit_vac_for_cand 9
select * from requirements
select * from cand_coefficient

select * from requirements

update requirements
   set ex_soc_pack = 0
  where req_id = 13

update cand_coefficient
  set k_salary = 2

/******************************************************************/
/--------------------------------------*--------------------------/

if exists (select * from dbo.sysobjects 
                  where id = object_id(N'dbo.suit_vac_for_cand')  and objectproperty(id, N'IsProcedure') = 1
               )
   drop procedure dbo.suit_vac_for_cand
GO


create proc dbo.suit_vac_for_cand
 
  @cand_id int

AS

    select c.cand_id, c.name, req_v.req_id, v.name, (select cc.k_salary + cc.k_experience + cc.k_age + cc.k_pay_form_id + cc.k_work_time_id + cc.k_ex_soc_pack + cc.k_ex_career + cc.k_ex_damage + cc.k_ex_hosp + cc.k_form_work_id + cc. k_spec_cond_id from cand_coefficient cc) as [W] from candidates c
     join requirements req_c on c.req_id = req_c.req_id
	 cross join requirements req_v  
	 join vacancies v on v.req_id = req_v.req_id 
	   where c.cand_id = @cand_id --@cand_id
	      and req_v.belong = 1
		  --and req_c.spec_id  = req_v.spec_id 
		  and req_c.salary >= req_v.salary
		  and req_c.experience >= req_v.experience 
		  and req_c.age <= req_v.age
		  and req_c.pay_form_id = req_v.pay_form_id 
		  and req_c.work_time_id = req_v.work_time_id
		  and req_c.ex_car >= req_v.ex_car
		  and req_c.ex_soc_pack = req_v.ex_soc_pack
		  and req_c.ex_hosp =  req_v.ex_hosp
		  and req_c.ex_damage >= req_v.ex_damage
		  and req_c.form_work_id = req_c.form_work_id
		  and req_c.ex_career = req_v.ex_career
		  and isnull(req_c.spec_cond_id, 0) >= isnull(req_v.spec_cond_id, 0)
		   
  --set @W

GO

exec dbo.suit_vac_for_cand 7
exec dbo.suit_vac_for_cand 8
exec dbo.suit_vac_for_cand 9



select * from vacancies
select * from requirements
select * from cand_coefficient
select * from candidates


/********************************************/

select * from pay_forms

методы/алгоритмы расчета зарплаты для предложенной вакансии с учетом формы оплаты труда,


if exists (select * from dbo.sysobjects 
                  where id = object_id(N'dbo.salary_calc')  and objectproperty(id, N'IsProcedure') = 1
               )
   drop procedure dbo.salary_calc
GO


create proc dbo.salary_calc
 
  @vac_id int

AS

   declare @salary int, @pay_form int 
  
  set @salary = (select r.salary from vacancies v 
					join requirements r on v.min_req_id = r.req_id
						where v.vac_id =  @vac_id)

  set @pay_form = (select r.pay_form_id from vacancies v 
					join requirements r on v.min_req_id = r.req_id
						where v.vac_id =  @vac_id)
select * from vac_coefficient

	 if @pay_form = 1 
	   begin
		   select name, @salary as [max_salary], 1 as [count/month], 'Фиксированная ставка, записанная в штатном расписании, без премий, надбавок и процентов ' as [def]
		     from pay_forms
			 where pay_form_id = @pay_form
        end

		 if @pay_form = 2
	   begin
		   select name, @salary as [max_salary], 1 as [count/month], 'Заработок зависит от количества фактически отработанного времени с учётом квалификации работника и условий труда ' as [def]
		     from pay_forms
			 where pay_form_id = @pay_form
        end


			 if @pay_form = 3
	   begin
		   select name, @salary as [max_salary], 1 as [count/month], 'Заработок зависит от количества произведённых им единиц продукции или выполненного объёма работ с учётом их качества, сложности и условий труда. ' as [def]
		     from pay_forms
			 where pay_form_id = @pay_form
        end


			 if @pay_form = 4
	   begin
		   select name, @salary as [max_salary], 1 as [count/month], 'Договор гражданско-правовой, заключается на выполнение конкретной непостоянной, разовой" работы' as [def]
		     from pay_forms
			 where pay_form_id = @pay_form
        end


exec dbo.salary_calc 4



/*******************************************************************************************************/


create table vac_coefficient(
   vac_coef int not null identity primary key,
   name varchar(20) not null,
   low_val int not null,
   aver_val int not null,
   high_val int not null
)

select * from vac_coefficient

update  vac_coefficient
 set high_val = 0
   where vac_coef = 8

insert into vac_coefficient (name, low_val, aver_val, high_val)
   values ('salary', 25000, 40000, 60000),
		  ( 'experience', 0, 3, 6),
		  ( 'age', 34, 26, 18),
		  ( 'pay_form_id', 3, 2, 1),
		  ( 'work_time', 2, 3, 1),
		  ( 'ex_soc_pack', 0, 0.5, 1),
		  ( 'ex_hosp', 0, 0.5, 1),
		  ( 'ex_damage', 0, 0.5, 1),
		  ( 'forms_work', 3, 2, 1),
		  ( 'ex_career', 0, 0.5, 1),
		  ( 'spec_cond_id', 1, 0.5, 0)
	


select * from vacancies
	select * from alter_req

	select * from requirements


select * from cand_coefficient


if exists (select * from dbo.sysobjects 
                  where id = object_id(N'dbo.actual_vac')  and objectproperty(id, N'IsProcedure') = 1
               )
   drop procedure dbo.actual_vac
GO


create proc dbo.actual_vac
 
  @low_coef float,
  @aver_coef float,
  @high_coef float,
  @max_V float,
  @min_V float

AS

    declare @V float, @fff int, @i int, @count int, @spec_id int, @salary int, @experience int, @age int, @ex_hosp bit, @pay_form_id bit, @work_time_id int, @ex_car bit, @ex_soc_pack bit, @ex_damage bit, @form_work_id int, @ex_career bit, @spec_cond_id int

    create table #answer(
		ans_id int identity primary key not null,
		vac_id int not null,
		name varchar(40) not null,
		V float not null,
		actual varchar(20) not null
	          )


    set @i = 0
	set @count = 0
	set @count = (select max(req_id) from requirements)

     while (@i < @count)
	   begin
	     set @i = @i + 1		   

		  if (select belong from requirements where req_id = @i) = 1
		   begin

					--требования (условия) вакансии
		        set @spec_id = (select spec_id  from requirements req_c where req_c.req_id = @i) 
				set @salary = (select salary from requirements req_c where req_c.req_id = @i) -- cand_id)
				set @experience = (select experience from requirements req_c where req_c.req_id = @i) 
				set @age = (select age from requirements req_c where req_c.req_id = @i) 
				set @pay_form_id  = (select pay_form_id  from requirements req_c where req_c.req_id = @i) 
				set @work_time_id = (select work_time_id  from requirements req_c where req_c.req_id = @i)
				set @ex_soc_pack = (select ex_soc_pack from requirements req_c where req_c.req_id = @i) 
				set @ex_hosp = (select ex_hosp from requirements req_c where req_c.req_id = @i)
				set @ex_damage = (select ex_damage from requirements req_c where req_c.req_id = @i) 
				set @form_work_id = (select form_work_id from requirements req_c where req_c.req_id = @i)
				set @ex_career = (select ex_career from requirements req_c where req_c.req_id = @i)
				set @spec_cond_id = isnull((select spec_cond_id from requirements req_c where req_c.req_id = 12),0)    

--коэффиценты вакансий
			create table #temp(
				k_salary float not null,
				k_experience float not null,
				k_age float not null,
				k_pay_form_id float not null,
				k_work_time_id float not null,
				k_ex_soc_pack float not null,
				k_ex_hosp float not null,
				k_ex_damage float not null,
				k_form_work_id float not null,
				k_ex_career float not null,
				k_spec_cond_id float null		
			)

			insert into #temp 
			 values (@high_coef, @high_coef, @high_coef, @high_coef, @high_coef,@high_coef,@high_coef, @high_coef, @high_coef, @high_coef, @high_coef)

			    if (select aver_val from vac_coefficient where vac_coef = 1) > @salary
			   begin 
			      update #temp set k_salary = @aver_coef
			   end


		       if (select low_val from vac_coefficient where vac_coef = 1) > @salary
			   begin 
			      update #temp set k_salary = @low_coef
			   end
			
			 if (select aver_val from vac_coefficient where vac_coef = 2) > @experience
			   begin 
			      update #temp set k_experience = @aver_coef 
			   end


			   if (select low_val from vac_coefficient where vac_coef = 2) > @experience
			   begin 
			      update #temp set k_experience = @low_coef
			   end


			   if (select aver_val from vac_coefficient where vac_coef = 3)  < @age
			   begin 
			      update #temp set k_age = @aver_coef 
			   end

			   
			   if (select low_val from vac_coefficient where vac_coef = 3)  < @age
			   begin 
			      update #temp set k_age = @low_coef 
			   end


			   if (select aver_val from vac_coefficient where vac_coef = 4) = @pay_form_id
			   begin 
			      update #temp set k_pay_form_id =  @aver_coef
			   end

			  if ((select low_val from vac_coefficient where vac_coef = 4) = @pay_form_id) or (@pay_form_id = 4)
			   begin 
			      update #temp set k_pay_form_id =  @low_coef
			   end


			  if (select aver_val from vac_coefficient where vac_coef = 5) = @work_time_id
			   begin 
			      update #temp set k_work_time_id =  @aver_coef
			   end

			   
			  if (select low_val from vac_coefficient where vac_coef = 5) = @work_time_id
			   begin 
			      update #temp set k_work_time_id =  @low_coef
			   end


			  if (select low_val from vac_coefficient where vac_coef = 6) = @ex_soc_pack 
			   begin 
			      update #temp set k_ex_soc_pack  = @low_coef
				  
			   end

			  if (select low_val from vac_coefficient where vac_coef = 7)  = @ex_hosp
			   begin 
			      update #temp set k_ex_hosp= @low_coef
			   end


			  if (select low_val from vac_coefficient where vac_coef = 8)  = @ex_damage
			   begin 
			      update #temp set k_ex_damage = @low_coef
			   end

			  if (select aver_val from vac_coefficient where vac_coef = 9) = @form_work_id 
			   begin 
			      update #temp set k_form_work_id  = @aver_coef 
			   end

			  
			  if (select low_val from vac_coefficient where vac_coef = 9) = @form_work_id 
			   begin 
			      update #temp set k_form_work_id  = @low_coef 
			   end


			  if (select low_val from vac_coefficient where vac_coef = 10) = @ex_career
			 begin    
				  update #temp set k_ex_career = @low_coef 
			 end

			  if (select low_val from vac_coefficient where vac_coef = 11) = @spec_cond_id
			 begin    
				  update #temp set k_spec_cond_id = @low_coef 
			 end

				set @salary = (select k_salary from cand_coefficient) -- cand_id)
				set @experience = (select k_experience from cand_coefficient) 
				set @age = (select k_age from cand_coefficient) 
				set @pay_form_id  = (select k_pay_form_id  from cand_coefficient) 
				set @work_time_id = (select k_work_time_id  from cand_coefficient)
				set @ex_soc_pack = (select k_ex_soc_pack from cand_coefficient) 
				set @ex_hosp = (select k_ex_hosp from cand_coefficient)
				set @ex_damage = (select k_ex_damage from cand_coefficient) 
				set @form_work_id = (select k_form_work_id from cand_coefficient)
				set @ex_career = (select k_ex_career from cand_coefficient)
				set @spec_cond_id = isnull((select k_spec_cond_id from cand_coefficient),0) 

		set @V = (select t.k_salary * @salary + t.k_experience * @experience + t.k_age * @age + t.k_pay_form_id * @pay_form_id + t.k_work_time_id * @work_time_id + t.k_ex_soc_pack * @ex_soc_pack + t.k_ex_career * @ex_career + t.k_ex_damage * @ex_damage + t.k_ex_hosp * @ex_hosp + t.k_form_work_id * @form_work_id + t.k_spec_cond_id * @spec_cond_id from #temp t)

			   insert into #answer(vac_id, name, V, actual)
			    select v.vac_id, v.name,  @V as [V], 'Не определена'  from vacancies v
		            where v.req_id = @i


               select @fff= SCOPE_IDENTITY()

	            if @V >= @max_V
				  begin 
				     update #answer
					    set actual = 'Актуальная'
						  where ans_id = @fff
			    end

			     if @V <= @min_V
				  begin 
				     update #answer
					    set actual = 'Неактуальная'
				         where ans_id = @fff
			    end
	        


			drop table #temp

			end
	     end



		 select * from #answer
		   order by V desc

		 drop table #answer

GO


exec actual_vac 0,1,2, 6, 12


select * from candidates
select * from cand_coefficient
select * from vacancies
select * from vac_coefficient
select * from requirements
