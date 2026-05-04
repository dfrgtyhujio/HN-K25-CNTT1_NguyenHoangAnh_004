create database db_khaosat;
use db_khaosat;

-- PHẦN 1: Tạo CSDL và các bảng
create table majors (
	major_id varchar(5) primary key not null,
    major_name varchar(150) not null unique,
    department varchar(100) not null,
    duration_years int not null,
    tuition_fee decimal(15,2) not null check(tuition_fee > 0),
    status varchar(20) not null default 'Active'
);

create table candidates (
	candidate_id varchar(5) primary key not null,
    full_name varchar(100) not null,
    email varchar(100) not null unique,
    phone varchar(15) not null,
    hometown varchar(100) not null
);

create table applications (
	app_id int primary key auto_increment,
    candidate_id varchar(5) not null,
    major_id varchar(5) not null,
    foreign key (candidate_id) references candidates (candidate_id),
    foreign key (major_id) references majors (major_id),
    apply_date date not null,
    priority_score decimal(4,2)
);

create table admissions (
	admission_id int primary key auto_increment,
    app_id int not null,
    foreign key (app_id) references applications (app_id),
    total_score decimal(4,2) not null,
    result varchar(50)
);

alter table candidates
add column birth_year int not null;


-- PHẦN 2: Chèn dữ liệu và Thao tác

insert into majors values
	('M01', 'Công nghệ thông tin', 'CNTT', 4, 30000000.00, 'Active'), 
	('M02', 'Quản trị kinh doanh', 'Kinh tế', 4, 25000000.00, 'Active'), 
	('M03', 'Ngôn ngữ Anh', 'Ngoại ngữ', 4, 22000000.00, 'Full'), 
	('M04', 'Kỹ thuật ô tô', 'Cơ khí', 5, 28000000.00, 'Active'), 
	('M05', 'Trí tuệ nhân tạo', 'CNTT', 4, 45000000.00, 'Active');   

insert into candidates values
	('C01', 'Nguyễn Phan Anh', 'anh.np@gmail.com', '0912345678', 'Hà Nội', 2006), 
	('C02', 'Trần Thị Mai', 'mai.tt@gmail.com', '0987654321', 'Đà Nẵng', 2006), 
	('C03', 'Nguyễn Minh Khôi', 'khoi.nm@gmail.com', '0944556677', 'Hải Phòng', 2005), 
	('C04', 'Lê Bảo Châu', 'chau.lb@gmail.com', '0966112233', 'TP HCM', 2006), 
	('C05', 'Ngô Quang Đăng', 'dang.nq@gmail.com', '0977889900', 'Cần Thơ', 2006);

insert into applications values
	(1, 'C01', 'M01', '2025-11-10', 0.50), 
	(2, 'C03', 'M05', '2025-11-12', 0.00), 
	(3, 'C05', 'M01', '2025-11-15', 1.00), 
	(4, 'C02', 'M02', '2025-12-01', 0.00), 
	(5, 'C01', 'M05', '2025-12-05', 0.50), 
	(6, 'C04', 'M03', '2025-12-10', 0.00);

insert into admissions values
	(1, 1, 27.50, 'Admitted'), 
	(2, 2, 24.00, 'Pending'), 
	(3, 3, 29.00, 'Admitted');

update candidates set hometown = 'Quảng Nam' where candidate_id = 'C02';

update majors set tuition_fee = tuition_fee* 0.9 where department = 'Ngoại ngữ';

delete from admissions where result = 'Rejected';

update majors set status = 'Full' where tuition_fee > 40000000;

update applications set priority_score = 0 where month(apply_date) = 11 and priority_score is null;


-- PHẦN 3: Truy vấn dữ liệu 
-- Cơ bản
-- 1
select * from majors 
where tuition_fee between 20000000 and 30000000;

-- 2
select full_name, email from candidates
where full_name like '%Nguyễn%';

-- 3
select major_name, department from majors
order by tuition_fee desc;

-- 4
select * from candidates
order by birth_year asc
limit 3;

-- 5
select * from applications
where month(apply_date) = 11;

-- 7
select * from applications
where priority_score between 0.25 and 0.75;

-- 8
select * from candidates
order by hometown asc;

-- Nâng cao
-- 1
select
	ap.app_id, 
	c.full_name,
	m.major_name,
	ap.apply_date
from applications as ap
join majors as m on ap.major_id = m.major_id
join candidates as c on ap.candidate_id = c.candidate_id
where c.hometown = 'Hà Nội';

-- 2
select
	department, 
	count(major_name) as total
from majors
group by department;

-- 3
select
	m.major_name,
    count(ap.major_id) as total
from majors as m
left join applications as ap on ap.major_id = m.major_id
group by m.major_name;


-- 4
select m.*
from majors as m
left join applications as ap on ap.major_id = m.major_id
group by m.major_name
having count(ap.major_id) = 0;

-- 5
select 
	m.major_name,
    sum(m.tuition_fee) as total
from majors as m
join applications as ap on ap.major_id = m.major_id
join admissions as ad on ap.app_id = ad.app_id
where ad.result = 'Admitted'
group by m.major_name;

-- 6
select c.full_name
from candidates as c
join applications as ap on c.candidate_id = ap.candidate_id
group by c.full_name
having count(ap.candidate_id) >= 2;

-- 7
select * from majors
order by tuition_fee desc
limit 1;

-- 8
select c.* 
from candidates as c
join applications as ap on c.candidate_id = ap.candidate_id
join admissions as ad on ap.app_id = ad.app_id
where c.birth_year = 2006 
	and ap.major_id = 'M01' or ap.major_id = 'M05'
    and ad.result = 'Admitted';