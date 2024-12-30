drop database if exists bethesda_news;
create database bethesda_news;
use bethesda_news;

create table articles (
    id int primary key auto_increment,
    title varchar(255) not null,
    image_url varchar(255) not null,
    summary text not null,
    content text not null,
    priority_score int not null,
    created_at datetime default current_timestamp not null
);

create table article_elements (
    id int primary key auto_increment,
    article_id int,
    element_type enum('text', 'image') not null,
    image_url varchar(255),
    text_content text,
    ordering_index int not null,
    foreign key (article_id) references articles(id)
);

create table authors (
    id int primary key auto_increment,
    first_name varchar(255) not null,
    last_name varchar(255) not null,
    bio text,
    image_url varchar(255)
);

create table article_authors (
    article_id int,
    author_id int,
    foreign key (article_id) references articles(id),
    foreign key (author_id) references authors(id)
);

create table genre_tags (
    article_id int,
    genre enum('Local News', 'Politics', 'Business', 'Sports', 'Culture', 'Opinion') not null,
    foreign key (article_id) references articles(id)
);

