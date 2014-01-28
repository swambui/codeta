drop table if exists Users cascade;
create table Users (
    user_id bigserial primary key,
    email varchar(100) not null,
    username varchar(100) not null,
    password char(60) not null,
    first_name varchar(100),
    last_name varchar(100)
);

drop table if exists Instructor cascade;
create table Instructor (
    instructor_id integer,
    contact_email varchar(100),

    foreign key (instructor_id) references Users (user_id)
);

drop table if exists Student cascade;
create table Student (
    student_id integer,

    foreign key (student_id) references Users (user_id)
);

drop table if exists Course cascade;
create table Course (
    course_id bigserial primary key,
    name varchar(100) not null,
    identifier varchar(20),
    section integer,
    instructor_id integer,
    description text,

    foreign key (instructor_id) references Users (user_id)
);

drop table if exists InstructorTeachesCourse cascade;
create table InstructorTeachesCourse (
    instructor_teaches_course bigserial primary key,
    instructor_id integer not null,
    course_id integer not null,

    foreign key (instructor_id) references Users (user_id),
    foreign key (course_id) references Course (course_id)
);

drop table if exists StudentEnrollsCourse cascade;
create table StudentEnrollsCourse (
    student_enroll_course bigserial primary key,
    student_id integer not null,
    course_id integer not null,

    foreign key (student_id) references Users (user_id),
    foreign key (course_id) references Course (course_id)

);

drop table if exists Assignment cascade;
create table Assignment (
    assignment_id bigserial primary key,
    title varchar(100),
    description text,
    due_date timestamp,
    points_possible integer,
    course_id integer,

    foreign key (course_id) references Course (course_id)
);

drop table if exists UserFile cascade;
create table UserFile (
    user_file_id bigserial primary key,
    assignment_id integer,
    symlink text not null,

    foreign key (assignment_id) references Assignment (assignment_id)
);

drop table if exists Submission cascade;
create table Submission (
    submission_id bigserial primary key,
    student_id integer not null,
    assignment_id integer not null,
    points_earned integer,
    submit_date timestamp,
    student_comments text,
    grader_comments text,

    foreign key (student_id) references Users (user_id),
    foreign key (assignment_id) references Assignment (assignment_id)
);

drop table if exists SubmissionUpload cascade;
create table SubmissionUpload (
    student_id integer not null,
    submission_id integer not null,
    symlink text not null,

    foreign key (student_id) references Users (user_id),
    foreign key (submission_id) references Submission (submission_id)
);

drop table if exists AssignmentUpload cascade;
create table AssignmentUpload (
    instructor_id integer not null,
    assignment_id integer not null,
    symlink text not null,

    foreign key (instructor_id) references Users (user_id),
    foreign key (assignment_id) references Assignment (assignment_id)
);
