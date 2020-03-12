--drop table--
drop table regions cascade constraints purge;
drop table countries cascade constraints purge;
drop table locations cascade constraints purge;
drop table departments cascade constraints purge;
drop table jobs cascade constraints purge;
drop table employees cascade constraints purge;

--create table--
create table regions
(region_id NUMBER ,
 region_name varchar(25),
 constraint regions_id_pk primary key(region_id)
);
 
create table countries
(country_id char(2) ,
 country_name varchar(40),
 region_id number,
  constraint countries_id_pk primary key (country_id),
  constraint countries_regionid_fk foreign key(region_id) references regions);
  
create table locations
(location_id number(4) ,
 street_address varchar(40),
 postal_code varchar(12),
 city varchar(30),
 state_province varchar(25),
 country_id char(2),
 constraint locations_id_pk primary key(location_id),
 constraint locations_countryid_fk foreign key (country_id) references countries);
 
 create table departments
 (department_id number(4),
  department_name varchar(30) not null,
  manager_id number(6),
  location_id number(4),
  constraint departments_id_pk primary key(department_id),
  constraint departments_locationid_fk foreign key (location_id) references locations);

create table jobs
(job_id varchar(10),
 job_title varchar(35) not null,
 min_salary number(6),
 max_salary number(6),
 constraint jobs_id_pk primary key (job_id));
  
create table employees
(employee_id number(6),
 first_name varchar(20) not null ,
 last_name varchar(25) not null ,
 email varchar(50),
 phone_number varchar(20),
 hire_date date,
 salary number(8,2),
 commission_pct number(8,2),
 manager_id number(6),
 job_id varchar(10),
 department_id number(4),
 constraint employees_id_pk primary key (employee_id),
 constraint employees_email_uk unique (email),
 constraint employees_salary_ck check (salary > 0),
 constraint employees_managerid_fk foreign key (manager_id) references employees,
 constraint employees_jobid_fk foreign key (job_id) references jobs,
 constraint employees_departmentid_fk foreign key (department_id) references departments);
 

 
  
 
