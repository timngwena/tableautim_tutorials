//Create some structure DB, Schema, external stage [your s3 uri]

create or replace database staging ;

create or replace schema external_staging;

create or replace stage aws_stage
url='[your s3 uri]';

desc stage aws_stage;

list @aws_stage;

//Load data into stage from S3 //Preview the data in the stage

select t.$1, t.$2 from @aws_stage t;

create or replace file format csv_pipe type= 'csv' field_delimiter='|' skip_header=1;

select t.$1, t.$2,t.$3, t.$4,t.$5  from @aws_stage 
(file_format=>'csv_pipe')
t;

//Create a table to load data into 
create table customer_table (
    ID INT,
    first_name varchar,
    last_name varchar,
    favourite_app varchar,
    favourite_color varchar
);


//Load into the table Firest example
//file formarts are schema specific
create or replace file format csv_pipe type= 'csv' field_delimiter='|' skip_header=1;

copy into customer_table from (
                                select t.$1, t.$2,t.$3, t.$4,t.$5  from @staging.external_staging.aws_stage
                                (file_format => 'csv_pipe')
                                t);


//Load into the table Firest example
create table customer_tablev2 (
    ID INT,
    first_name varchar,
    last_name varchar,
    favourite_app varchar,
    favourite_color varchar
);

copy into customer_tablev2
from @staging.external_staging.aws_stage
file_format = (type= 'csv' field_delimiter='|' skip_header=1);


select * from customer_tablev2;
