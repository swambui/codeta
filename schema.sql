drop table if exists user;
create table user (
    user_id bigserial primary key,
    email varchar(100) not null,
    username varchar(100) not null,
    password char(60) not null,
    first_name varchar(100),
    last_name varchar(100)
);

drop table if exists instructor;
create table instructor (
    instructor_id integer,
    contact_email varchar(100),

    foreign key (instructor_id) references user (user_id)
);

drop table if exists student;
create table student (
    student_id integer,

    foreign key (student_id) references user (user_id)
);

drop table if exists course;
create table course (
    course_id bigserial primary key,
    name varchar(100) not null,
    identifier varchar(20),
    section integer,
    instructor_id integer,

    foreign key (instructor_id) references instructor (instructor_id)
);

drop table if exists assignment;
create table assignment (
    assignment_id bigserial primary key,
    title varchar(100),
    description text,
    due_date timestamp,
    course_id integer,

    foreign key (course_id) references course (course_id)
);

drop table if exists assignment_file;
create table assignment_file (
    assignment_file_id bigserial primary key,
    assignment_id integer not null,
    symlink text not null,

    foreign key (assignment_id) references assignment (assignment_id)
);

drop table if exists submission;
create table submission (
    submission_id bigserial primary key,
    student_id integer not null,
    assignment_id integer not null,
    grade numeric(5, 2),
    submit_date timestamp,
    grade_notes text,

    foreign key (student_id) references student (student_id),
    foreign key (assignment_id) references assignment (assignment_id)
);
