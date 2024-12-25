drop database if exists bethesda_news;
create database bethesda_news;
use bethesda_news;

create table articles (
    id int primary key auto_increment,
    title varchar(255) not null,
    image_url varchar(255) not null,
    author varchar(255) not null,
    summary text not null,
    content text not null,
    created_at datetime default current_timestamp not null
);
