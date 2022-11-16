//Create some structure DB, Schema, external stage s3://tableautim-snow/yt-datasets/

create or replace database staging ;

create or replace schema external_staging;

create or replace stage aws_stage
url='s3://tableautim-snow/yt-datasets/';

desc stage aws_stage;

list @aws_stage;

//Load data into stage from S3 //Preview the data in the stage

select t.$1, t.$2 from @aws_stage t;

create or replace file format csv_pipe type= 'csv' field_delimiter='|' skip_header=1;

select t.$1, t.$2,t.$3, t.$4,t.$5  from @aws_stage 
(file_format=>'csv_pipe')
t;

//Create a table to load data into 
create table customer_tablev3 (
    ID INT,
    first_name varchar,
    last_name varchar,
    favourite_app varchar,
    favourite_color varchar
);


//Load into the table 

create or replace file format csv_pipe type= 'csv' field_delimiter='|' skip_header=1;

copy into customer_tablev2 from (
                                select t.$1, t.$2,t.$3, t.$4,t.$5  from @staging.external_staging.aws_stage
                                (file_format => 'csv_pipe')
                                t);


copy into customer_tablev3 
from @staging.external_staging.aws_stage
file_format = (type= 'csv' field_delimiter='|' skip_header=1);


select * from customer_tablev2;
