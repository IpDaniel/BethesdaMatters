use bethesda_matters;

SELECT 'Starting example data script' as message;

-- Ensure we're in strict SQL mode
SET SQL_MODE = "STRICT_ALL_TABLES";

-- Disable foreign key checks temporarily for clean inserts
SET FOREIGN_KEY_CHECKS = 0;

-- Clear existing data (optional, but recommended for example data)
TRUNCATE TABLE article_authors;
TRUNCATE TABLE article_elements;
TRUNCATE TABLE genre_tags;
TRUNCATE TABLE articles;
TRUNCATE TABLE authors;

-- Re-enable foreign key checks
SET FOREIGN_KEY_CHECKS = 1;

-- Article 1
-- ----------------------------------------------

-- Insert the main article
INSERT INTO articles (title, image_url, summary, content, priority_score) VALUES (
    'Breaking News: Local Community Center Receives Major Renovation Grant',
    'https://www.ymcadc.org/wp-content/uploads/2022/06/YMCA-BCC-scaled.jpg',
    'The Bethesda Community Center is set to undergo a transformative renovation after being awarded a $2 million grant.',
    'The Bethesda Community Center is set to undergo a transformative renovation after being awarded a $2 million grant. This funding will enable the center to modernize its facilities, introduce a state-of-the-art youth recreation space, and improve accessibility features throughout the building...',
    10
);

-- Get the last inserted article ID
SET @article_id = LAST_INSERT_ID();

-- Insert article elements in order
INSERT INTO article_elements (article_id, element_type, text_content, image_url, ordering_index) VALUES
(@article_id, 'text', 'The Bethesda Community Center is set to undergo a transformative renovation after being awarded a $2 million grant. This funding will enable the center to modernize its facilities, introduce a state-of-the-art youth recreation space, and improve accessibility features throughout the building.', NULL, 1),
(@article_id, 'image', NULL, 'https://theburgnews.com/wp-content/uploads/2018/02/community-center.jpg', 2),
(@article_id, 'text', 'The announcement marks a significant milestone for the community, which has long relied on the center as a hub for activities, programs, and support services. According to local officials, the planned upgrades will ensure the center can better serve the needs of residents for years to come.', NULL, 3),
(@article_id, 'text', 'The $2 million grant will be used to update outdated infrastructure, add a dedicated youth recreation area equipped with the latest resources, and improve inclusivity by enhancing accessibility features throughout the building.', NULL, 4),
(@article_id, 'image', NULL, 'https://www.gwinnettcounty.com/static/departments/parks_rec/rotator_embed/images/Bethesda%20Park_SS_7.jpg', 5),
(@article_id, 'text', 'Construction is scheduled to start this summer, with a projected completion date in late 2025. During the renovation period, programs and services will temporarily relocate to nearby facilities. The center''s management assures residents that this short-term inconvenience will lead to long-term benefits.', NULL, 6),
(@article_id, 'text', 'Community members have expressed excitement about the improvements. "The Bethesda Community Center has been a cornerstone of our neighborhood for decades," said longtime resident Maria Lopez. "These upgrades will make it even more valuable to families like mine."', NULL, 7),
(@article_id, 'image', NULL, 'https://i.pinimg.com/736x/f3/62/4f/f3624f96be5eacec1801cd5f8d317728.jpg', 8),
(@article_id, 'text', 'The grant is part of a broader initiative to invest in community infrastructure across the region. Local leaders hope this project will inspire similar efforts in other neighborhoods.', NULL, 9),
(@article_id, 'text', 'Stay tuned for updates as the Bethesda Community Center begins its exciting transformation.', NULL, 10);

-- Insert the author
INSERT INTO authors (first_name, last_name, bio) VALUES
('Sarah', 'Johnson', 'Sarah Johnson is a local news reporter covering community development and infrastructure.');

-- Link the author to the article
SET @author_id = LAST_INSERT_ID();
INSERT INTO article_authors (article_id, author_id) VALUES
(@article_id, @author_id);

-- Add genre tags
INSERT INTO genre_tags (article_id, genre) VALUES
(@article_id, 'Local News');



-- Article 2
-- ----------------------------------------------

-- Insert the main article
INSERT INTO articles (title, image_url, summary, content, priority_score) VALUES (
    'New Bike Lanes Transform Downtown Traffic Flow',
    'https://moco360.media/wp-content/uploads/2022/08/IMG_2454-scaled.jpg',
    'City planners are celebrating the completion of a network of dedicated bike lanes throughout the downtown area. The project aims to enhance safety and promote sustainable transportation.',
    'City planners are celebrating the completion of a network of dedicated bike lanes throughout the downtown area. The project, which aims to enhance safety and promote sustainable transportation, has already begun reshaping how residents navigate the bustling urban center...',
    8
);

-- Get the last inserted article ID
SET @article_id = LAST_INSERT_ID();

-- Insert article elements in order
INSERT INTO article_elements (article_id, element_type, text_content, image_url, ordering_index) VALUES
(@article_id, 'text', 'City planners are celebrating the completion of a network of dedicated bike lanes throughout the downtown area. The project, which aims to enhance safety and promote sustainable transportation, has already begun reshaping how residents navigate the bustling urban center.', NULL, 1),
(@article_id, 'image', NULL, 'https://ggwash.org/images/made/images/posts/_resized/Old_Georgetown_Road_bike_lanes_800_591.png', 2),
(@article_id, 'text', 'The newly installed lanes extend across major downtown corridors, creating a connected and accessible pathway for cyclists. Designed with safety in mind, the bike lanes are clearly marked and separated from vehicle traffic by physical barriers in several high-traffic areas.', NULL, 3),
(@article_id, 'text', 'This effort is part of a broader initiative to reduce traffic congestion and carbon emissions while encouraging a healthier lifestyle among city residents. By providing a dedicated space for bicycles, planners aim to make cycling a viable alternative to driving for daily commutes and errands.', NULL, 4),
(@article_id, 'text', 'City officials have expressed optimism about the lanes'' potential to transform urban mobility. "This is a step toward building a more sustainable and people-friendly downtown," said Transportation Commissioner Lisa Carter. "We want everyone—whether they drive, bike, or walk—to feel safe and supported on our streets."', NULL, 5),
(@article_id, 'text', 'Local businesses and residents are already noticing positive changes. "I''ve seen more people biking to work, and it''s definitely made the streets feel less chaotic," said café owner Elena Rivera, whose shop is located along one of the newly renovated streets.', NULL, 6),
(@article_id, 'text', 'Community groups and environmental advocates have also applauded the city''s efforts. "This infrastructure shows that cities can prioritize both safety and sustainability," said Tim Nguyen, a representative from the Urban Cycling Coalition.', NULL, 7),
(@article_id, 'text', 'Critics, however, have raised concerns about the reduction in available parking spots and potential challenges for delivery drivers. City officials have promised to monitor the impact and adjust as needed to balance the needs of all road users.', NULL, 8),
(@article_id, 'text', 'The bike lane project is expected to serve as a blueprint for other neighborhoods looking to adopt similar improvements. City planners hope this success will inspire further investments in sustainable urban transportation.', NULL, 9),
(@article_id, 'text', 'For now, residents are encouraged to explore the new lanes and experience firsthand how they are changing the rhythm of downtown traffic.', NULL, 10);

-- Insert the author
INSERT INTO authors (first_name, last_name, bio) VALUES
('Michael', 'Chen', 'Michael Chen is an urban development reporter specializing in transportation and infrastructure.');

-- Link the author to the article
SET @author_id = LAST_INSERT_ID();
INSERT INTO article_authors (article_id, author_id) VALUES
(@article_id, @author_id);

-- Add genre tags
INSERT INTO genre_tags (article_id, genre) VALUES
(@article_id, 'Local News');



-- Article 3
-- ----------------------------------------------

-- Insert the main article
INSERT INTO articles (title, image_url, summary, content, priority_score) VALUES (
    'Local Farm-to-Table Restaurant Opens Second Location',
    'https://dynamic-media-cdn.tripadvisor.com/media/photo-o/26/93/27/9f/indoor-seating.jpg?w=600&h=-1&s=1',
    'Harvest Table, the beloved farm-to-table restaurant known for its fresh, locally sourced dishes, has officially opened its second location in the Riverside district.',
    'Harvest Table, the beloved farm-to-table restaurant known for its fresh, locally sourced dishes, has officially opened its second location. The new venue, located in the heart of the Riverside district, marks a significant milestone for the family-owned business as it continues to grow in popularity among food enthusiasts...',
    7
);

-- Get the last inserted article ID
SET @article_id = LAST_INSERT_ID();

-- Insert article elements in order
INSERT INTO article_elements (article_id, element_type, text_content, image_url, ordering_index) VALUES
(@article_id, 'text', 'Harvest Table, the beloved farm-to-table restaurant known for its fresh, locally sourced dishes, has officially opened its second location. The new venue, located in the heart of the Riverside district, marks a significant milestone for the family-owned business as it continues to grow in popularity among food enthusiasts.', NULL, 1),
(@article_id, 'image', NULL, 'https://dynamic-media-cdn.tripadvisor.com/media/photo-o/10/bc/14/62/woodmont-grill.jpg?w=600&h=400&s=1', 2),
(@article_id, 'text', 'Owners Maria and James Peters, who started Harvest Table as a small venture five years ago, expressed their excitement about the expansion. "We''re thrilled to bring our vision of sustainable and delicious dining to a new community," Maria said during the grand opening event.', NULL, 3),
(@article_id, 'text', 'The new location retains the signature charm of the original restaurant, featuring a rustic yet modern design with reclaimed wood furnishings, soft lighting, and an open kitchen concept. The menu, a mix of seasonal favorites and new creations, continues to highlight partnerships with local farmers and suppliers.', NULL, 4),
(@article_id, 'image', NULL, 'https://moco360.media/wp-content/uploads/2024/03/0324_GOODLIFE_FieldTrip_DowntownBethesda_sm-copy-1200x802.jpg', 5),
(@article_id, 'text', 'Frequent customer and food blogger Sarah Tan is already a fan. "Their ability to turn simple, fresh ingredients into extraordinary meals is what makes Harvest Table stand out," she said.', NULL, 6),
(@article_id, 'text', 'The new Riverside location also includes a spacious patio for outdoor dining, catering to the growing demand for open-air dining experiences. The restaurant plans to host seasonal events, such as farmer meet-and-greets and wine tastings, to further engage with the community.', NULL, 7),
(@article_id, 'text', '"We want to be more than just a restaurant," said James Peters. "Our goal is to create a space where people can connect over great food and learn more about where it comes from."', NULL, 8),
(@article_id, 'text', 'With the opening of its second location, Harvest Table is poised to solidify its reputation as a leader in sustainable dining. Community members and visitors alike are encouraged to stop by and discover the flavors that have made the restaurant a local favorite.', NULL, 9);

-- Insert the author
INSERT INTO authors (first_name, last_name, bio) VALUES
('Emily', 'Rodriguez', 'Emily Rodriguez is a food and culture reporter covering the local dining scene.');

-- Link the author to the article
SET @author_id = LAST_INSERT_ID();
INSERT INTO article_authors (article_id, author_id) VALUES
(@article_id, @author_id);

-- Add genre tags
INSERT INTO genre_tags (article_id, genre) VALUES
(@article_id, 'Business');



-- Article 4
-- ----------------------------------------------

-- Insert the main article
INSERT INTO articles (title, image_url, summary, content, priority_score) VALUES (
    'Local Tech Startup Secures Major Investment',
    'https://cdn.prod.website-files.com/63d90fe29e8bf43980780590/65855575b3c2722c71f14832_image.jpg',
    'Bethesda-based AI startup SecureFlow has announced a $10 million Series A funding round, marking a pivotal moment in the company''s growth.',
    'Bethesda-based AI startup SecureFlow has announced a $10 million Series A funding round, marking a pivotal moment in the company''s growth. The investment, led by prominent venture capital firm Innovate Partners, will enable SecureFlow to scale its operations and further develop its cutting-edge cybersecurity solutions...',
    9
);

-- Get the last inserted article ID
SET @article_id = LAST_INSERT_ID();

-- Insert article elements in order
INSERT INTO article_elements (article_id, element_type, text_content, image_url, ordering_index) VALUES
(@article_id, 'text', 'Bethesda-based AI startup SecureFlow has announced a $10 million Series A funding round, marking a pivotal moment in the company''s growth. The investment, led by prominent venture capital firm Innovate Partners, will enable SecureFlow to scale its operations and further develop its cutting-edge cybersecurity solutions.', NULL, 1),
(@article_id, 'image', NULL, 'https://media.istockphoto.com/id/1365567295/photo/business-colleagues-having-a-meeting-in-a-boardroom.jpg?s=612x612&w=0&k=20&c=R7dhmDVXrXl0A8ZLI0LOeVXf--jktfkCXGpM1xbuj2A=', 2),
(@article_id, 'text', 'Founded three years ago, SecureFlow specializes in leveraging artificial intelligence to enhance cybersecurity for businesses of all sizes. Its flagship product, SentinelAI, uses machine learning algorithms to detect and mitigate threats in real time, offering clients a proactive approach to protecting their digital assets.', NULL, 3),
(@article_id, 'text', '"This funding is a major milestone for SecureFlow," said CEO and co-founder Rachel Simmons. "It allows us to expand our team, enhance our technology, and accelerate our mission to make advanced cybersecurity accessible to all organizations."', NULL, 4),
(@article_id, 'text', 'The funding will also support SecureFlow''s plans to enter new markets, including Europe and Asia, where demand for robust cybersecurity solutions continues to grow. Additionally, a portion of the funds will go toward research and development for new AI-driven tools designed to counteract emerging threats.', NULL, 5),
(@article_id, 'image', NULL, 'https://eaog2nkqckp.exactdn.com/wp-content/uploads/2022/12/611573db674f3342d299a89a_Product_Demo_Featured-1140x768@2x-80-min.jpeg', 6),
(@article_id, 'text', 'Investors and industry experts have expressed confidence in SecureFlow''s potential. "Cybersecurity is more critical than ever, and SecureFlow''s AI-first approach is exactly what the industry needs," said Innovate Partners'' managing director, Sarah Lee. "We''re excited to support their journey and see how they''ll shape the future of digital security."', NULL, 7),
(@article_id, 'text', 'The funding announcement has already sparked excitement in the local tech community, solidifying Bethesda''s reputation as a growing hub for innovation. "This is a great win for our region," said Mark Johnson, director of the Bethesda Tech Alliance. "SecureFlow''s success highlights the incredible talent and entrepreneurial spirit we have here."', NULL, 8),
(@article_id, 'text', 'With this new investment, SecureFlow is poised to make significant strides in the cybersecurity landscape. The company encourages businesses and tech enthusiasts to stay tuned for upcoming announcements, including the launch of enhanced features for SentinelAI and potential new partnerships.', NULL, 9);

-- Insert the author
INSERT INTO authors (first_name, last_name, bio) VALUES
('David', 'Park', 'David Park is a technology reporter specializing in startups and innovation in the cybersecurity sector.');

-- Link the author to the article
SET @author_id = LAST_INSERT_ID();
INSERT INTO article_authors (article_id, author_id) VALUES
(@article_id, @author_id);

-- Add genre tags
INSERT INTO genre_tags (article_id, genre) VALUES
(@article_id, 'Business');



-- Article 5
-- ----------------------------------------------

-- Insert the main article
INSERT INTO articles (title, image_url, summary, content, priority_score) VALUES (
    'Historic Theater Announces Summer Arts Program',
    'https://styleblueprint.com/wp-content/uploads/2019/04/StyleBlueprint_HistoricTheatres_Orpheum_Justin-Fox-Burks-900x600.jpg',
    'The Strand Theater, a historic cultural landmark, has unveiled its ambitious summer arts program, promising an exciting season of creativity and performance.',
    'The Strand Theater, a historic cultural landmark, has unveiled its ambitious summer arts program, promising an exciting season of creativity and performance. This initiative will bring together local artists, performers, and the community for a series of workshops, shows, and exhibitions celebrating the arts...',
    6
);

-- Get the last inserted article ID
SET @article_id = LAST_INSERT_ID();

-- Insert article elements in order
INSERT INTO article_elements (article_id, element_type, text_content, image_url, ordering_index) VALUES
(@article_id, 'text', 'The Strand Theater, a historic cultural landmark, has unveiled its ambitious summer arts program, promising an exciting season of creativity and performance. This initiative will bring together local artists, performers, and the community for a series of workshops, shows, and exhibitions celebrating the arts.', NULL, 1),
(@article_id, 'image', NULL, 'https://d1pk12b7bb81je.cloudfront.net/thumbor/5CUO67sIXQQ4B4y_0fjfd5ONcIM=/adaptive-fit-in/800x800/https://d1pk12b7bb81je.cloudfront.net/images/photos/1386110728_1386110727-colemanstageview.jpg', 2),
(@article_id, 'text', 'The program, running from June through August, features a diverse lineup, including live theater productions, music concerts, art exhibits, and hands-on workshops for all age groups. Highlights include a weeklong Shakespeare festival, a showcase of emerging local bands, and a family-friendly art camp designed to inspire budding young artists.', NULL, 3),
(@article_id, 'text', '"This summer, we aim to transform the Strand into a hub of artistic expression," said artistic director Samuel Greene. "Our goal is to provide opportunities for local talent to shine while offering the community enriching cultural experiences."', NULL, 4),
(@article_id, 'text', 'A centerpiece of the program is the "Spotlight on Local Talent" series, which will feature performances and exhibits exclusively by artists from the region. "This is our way of giving back to the community that has supported us for decades," Greene added.', NULL, 5),
(@article_id, 'image', NULL, 'https://static1.squarespace.com/static/551eb398e4b0b101cf722ed8/551ecf19e4b03e54b457d758/57ffa8bf03596ec2ff5d2f0a/1476372931290/blocking.jpg?format=1500w', 6),
(@article_id, 'text', 'The Strand''s summer program also includes partnerships with local schools and community organizations to ensure accessibility. Scholarships and free ticket programs are available for students and families in need, reinforcing the theater''s commitment to inclusivity.', NULL, 7),
(@article_id, 'text', 'Longtime patrons of the theater are thrilled about the upcoming season. "The Strand has always been a place where the arts come alive," said resident Maria Lopez. "This program is a wonderful way to keep that tradition going."', NULL, 8),
(@article_id, 'text', 'Tickets and schedules for the summer arts program will be released later this month, with early-bird discounts available for season passes. The Strand encourages all art lovers, performers, and curious newcomers to join in celebrating the vibrant creativity of the community this summer.', NULL, 9);

-- Insert the author
INSERT INTO authors (first_name, last_name, bio) VALUES
('Lisa', 'Martinez', 'Lisa Martinez is a culture and arts reporter covering local entertainment and community events.');

-- Link the author to the article
SET @author_id = LAST_INSERT_ID();
INSERT INTO article_authors (article_id, author_id) VALUES
(@article_id, @author_id);

-- Add genre tags
INSERT INTO genre_tags (article_id, genre) VALUES
(@article_id, 'Culture');



-- Article 6
-- ----------------------------------------------

-- Insert the main article
INSERT INTO articles (title, image_url, summary, content, priority_score) VALUES (
    'New Environmental Initiative Launches in Schools',
    'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcS-u-xl5YrpY8fAoOES4xFbRFYWga0jDWltxg&s',
    'Local schools have taken a significant step toward combating climate change with the launch of an innovative environmental initiative aimed at reducing their collective carbon footprint.',
    'Local schools have taken a significant step toward combating climate change with the launch of an innovative environmental initiative aimed at reducing their collective carbon footprint. The program introduces comprehensive recycling measures, sustainability workshops, and eco-friendly practices into classrooms and campuses across the district...',
    5
);

-- Get the last inserted article ID
SET @article_id = LAST_INSERT_ID();

-- Insert article elements in order
INSERT INTO article_elements (article_id, element_type, text_content, image_url, ordering_index) VALUES
(@article_id, 'text', 'Local schools have taken a significant step toward combating climate change with the launch of an innovative environmental initiative aimed at reducing their collective carbon footprint. The program introduces comprehensive recycling measures, sustainability workshops, and eco-friendly practices into classrooms and campuses across the district.', NULL, 1),
(@article_id, 'image', NULL, 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcR9iGN6l5F4igyR62LAcxLs2F0exTfNkevJLQ&s', 2),
(@article_id, 'text', 'The initiative, called "Green Futures," empowers students to take an active role in protecting the environment while integrating sustainability into the educational experience. Schools are outfitted with advanced recycling stations, composting bins for cafeteria waste, and hydration stations to encourage the use of reusable water bottles.', NULL, 3),
(@article_id, 'text', '"This program is about more than just recycling," said district superintendent Carla Thompson. "It''s about instilling lifelong habits and a sense of responsibility for the planet in our students."', NULL, 4),
(@article_id, 'text', 'One standout feature of Green Futures is the introduction of sustainability education into the curriculum. Students will participate in hands-on projects, such as creating school gardens, conducting waste audits, and designing energy-saving plans for their campuses.', NULL, 5),
(@article_id, 'image', NULL, 'https://arcadiaglasshouse.com/wp-content/uploads/2015/02/columbiana-retouch.jpg', 6),
(@article_id, 'text', 'Parents and teachers have expressed overwhelming support for the initiative. "My kids come home excited about making changes at home, like starting a compost bin," said local parent Sheila Brown. "It''s inspiring to see them so engaged."', NULL, 7),
(@article_id, 'text', 'Funding for Green Futures comes from a combination of state grants and partnerships with local businesses committed to environmental stewardship. Several schools have already reported early successes, including a 30% reduction in landfill waste and improved awareness among students about the impact of their choices.', NULL, 8),
(@article_id, 'text', 'The program also includes community involvement, with schools hosting events like neighborhood clean-ups and "green fairs" to spread awareness and share best practices.', NULL, 9),
(@article_id, 'text', 'Green Futures is poised to become a model for other districts looking to implement similar programs. As Thompson noted, "Together, we can create a culture of sustainability that extends beyond our schools and into the broader community."', NULL, 10),
(@article_id, 'text', 'For more information about Green Futures and upcoming events, parents and community members are encouraged to visit the district''s website or contact their local school.', NULL, 11);

-- Insert first author and get ID
INSERT INTO authors (first_name, last_name, bio) VALUES
('James', 'Wilson', 'James Wilson is an education reporter focusing on environmental and sustainability initiatives in schools.');
SET @first_author_id = LAST_INSERT_ID();

-- Insert second author and get ID
INSERT INTO authors (first_name, last_name, bio) VALUES
('Bob', 'Smith', 'Bob Smith is an education reporter focusing on the environment and sustainability.');
SET @second_author_id = LAST_INSERT_ID();

-- Link both authors
INSERT INTO article_authors (article_id, author_id) VALUES
(@article_id, @first_author_id),
(@article_id, @second_author_id);

-- Add genre tags
INSERT INTO genre_tags (article_id, genre) VALUES
(@article_id, 'Local News');

-- Add employee accounts for existing authors
-- Note: In a real system, passwords would never be this simple!
-- Using 'password123' for all accounts, hashed appropriately for Flask's werkzeug.security

-- Sarah Johnson (Local News Reporter)
INSERT INTO employee_accounts (author_id, email, password_hash, primary_role) 
SELECT id, 'sarah.johnson@bethesdamatters.com', 
       'pbkdf2:sha256:600000$uIqjVyAQ78eY83Ya$222b7649932b337217ae496df6031aab9279232bbd60188e513bdc9ff88a52b4',
       'writer'
FROM authors 
WHERE first_name = 'Sarah' AND last_name = 'Johnson';

-- Michael Chen (Urban Development Reporter)
INSERT INTO employee_accounts (author_id, email, password_hash, primary_role)
SELECT id, 'michael.chen@bethesdamatters.com',
       'pbkdf2:sha256:600000$uIqjVyAQ78eY83Ya$222b7649932b337217ae496df6031aab9279232bbd60188e513bdc9ff88a52b4',
       'writer'
FROM authors
WHERE first_name = 'Michael' AND last_name = 'Chen';

-- Emily Rodriguez (Food Reporter)
INSERT INTO employee_accounts (author_id, email, password_hash, primary_role)
SELECT id, 'emily.rodriguez@bethesdamatters.com',
       'pbkdf2:sha256:600000$uIqjVyAQ78eY83Ya$222b7649932b337217ae496df6031aab9279232bbd60188e513bdc9ff88a52b4',
       'writer'
FROM authors
WHERE first_name = 'Emily' AND last_name = 'Rodriguez';

-- David Park (Tech Reporter)
INSERT INTO employee_accounts (author_id, email, password_hash, primary_role)
SELECT id, 'david.park@bethesdamatters.com',
       'pbkdf2:sha256:600000$uIqjVyAQ78eY83Ya$222b7649932b337217ae496df6031aab9279232bbd60188e513bdc9ff88a52b4',
       'writer'
FROM authors
WHERE first_name = 'David' AND last_name = 'Park';

-- Lisa Martinez (Culture Reporter)
INSERT INTO employee_accounts (author_id, email, password_hash, primary_role)
SELECT id, 'lisa.martinez@bethesdamatters.com',
       'pbkdf2:sha256:600000$uIqjVyAQ78eY83Ya$222b7649932b337217ae496df6031aab9279232bbd60188e513bdc9ff88a52b4',
       'writer'
FROM authors
WHERE first_name = 'Lisa' AND last_name = 'Martinez';

-- James Wilson (Education Reporter)
INSERT INTO employee_accounts (author_id, email, password_hash, primary_role)
SELECT id, 'james.wilson@bethesdamatters.com',
       'pbkdf2:sha256:600000$uIqjVyAQ78eY83Ya$222b7649932b337217ae496df6031aab9279232bbd60188e513bdc9ff88a52b4',
       'writer'
FROM authors
WHERE first_name = 'James' AND last_name = 'Wilson';

-- Bob Smith (Education Reporter)
INSERT INTO employee_accounts (author_id, email, password_hash, primary_role)
SELECT id, 'bob.smith@bethesdamatters.com',
       'pbkdf2:sha256:600000$uIqjVyAQ78eY83Ya$222b7649932b337217ae496df6031aab9279232bbd60188e513bdc9ff88a52b4',
       'writer'
FROM authors
WHERE first_name = 'Bob' AND last_name = 'Smith';

-- Add initial sidebar widgets
-- ----------------------------------------------

-- Traffic Widget
INSERT INTO sidebar_widgets (widget_type, title, content) VALUES (
    'traffic',
    'Current Traffic Conditions',
    'Heavy delays on I-495 Beltway near Connecticut Ave exit. Wisconsin Ave moving slowly between Bradley Blvd and Old Georgetown Rd. Construction on Old Georgetown Road between Democracy Blvd and Cedar Ln.'
);

-- Events Widget
INSERT INTO sidebar_widgets (widget_type, title, content) VALUES (
    'events',
    'Upcoming Local Events',
    'Bethesda Art Walk - April 15 at Downtown Bethesda
    Farmers Market - April 20 at Elm Street Park
    Community Jazz Festival - April 27 at Veteran''s Park'
);

-- Sports Widget
INSERT INTO sidebar_widgets (widget_type, title, content) VALUES (
    'sports',
    'Local Sports Update',
    'Bethesda Big Train defeats Rockville Express 6-2
    BCC Barons win 28-14 against Churchill Bulldogs
    Whitman Vikings face Walter Johnson this Friday'
);

SELECT 'Example data script completed successfully' as message;






