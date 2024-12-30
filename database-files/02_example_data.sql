-- Article 1
-- ----------------------------------------------

-- Insert the main article
INSERT INTO articles (title, image_url, summary, content, priority_score) VALUES (
    'Breaking News: Local Community Center Receives Major Renovation Grant',
    'https://example.com/image.jpg',
    'The Bethesda Community Center is set to undergo a transformative renovation after being awarded a $2 million grant.',
    'The Bethesda Community Center is set to undergo a transformative renovation after being awarded a $2 million grant. This funding will enable the center to modernize its facilities, introduce a state-of-the-art youth recreation space, and improve accessibility features throughout the building...',
    10
);

-- Get the last inserted article ID
SET @article_id = LAST_INSERT_ID();

-- Insert article elements in order
INSERT INTO article_elements (article_id, element_type, text_content, image_url, ordering_index) VALUES
(@article_id, 'text', 'The Bethesda Community Center is set to undergo a transformative renovation after being awarded a $2 million grant. This funding will enable the center to modernize its facilities, introduce a state-of-the-art youth recreation space, and improve accessibility features throughout the building.', NULL, 1),
(@article_id, 'image', NULL, 'https://example.com/image.jpg', 2),
(@article_id, 'text', 'The announcement marks a significant milestone for the community, which has long relied on the center as a hub for activities, programs, and support services. According to local officials, the planned upgrades will ensure the center can better serve the needs of residents for years to come.', NULL, 3),
(@article_id, 'text', 'The $2 million grant will be used to update outdated infrastructure, add a dedicated youth recreation area equipped with the latest resources, and improve inclusivity by enhancing accessibility features throughout the building.', NULL, 4),
(@article_id, 'image', NULL, 'https://example.com/image.jpg', 5),
(@article_id, 'text', 'Construction is scheduled to start this summer, with a projected completion date in late 2025. During the renovation period, programs and services will temporarily relocate to nearby facilities. The center''s management assures residents that this short-term inconvenience will lead to long-term benefits.', NULL, 6),
(@article_id, 'text', 'Community members have expressed excitement about the improvements. "The Bethesda Community Center has been a cornerstone of our neighborhood for decades," said longtime resident Maria Lopez. "These upgrades will make it even more valuable to families like mine."', NULL, 7),
(@article_id, 'image', NULL, 'https://example.com/image.jpg', 8),
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
    'https://example.com/image.jpg',
    'City planners are celebrating the completion of a network of dedicated bike lanes throughout the downtown area. The project aims to enhance safety and promote sustainable transportation.',
    'City planners are celebrating the completion of a network of dedicated bike lanes throughout the downtown area. The project, which aims to enhance safety and promote sustainable transportation, has already begun reshaping how residents navigate the bustling urban center...',
    8
);

-- Get the last inserted article ID
SET @article_id = LAST_INSERT_ID();

-- Insert article elements in order
INSERT INTO article_elements (article_id, element_type, text_content, image_url, ordering_index) VALUES
(@article_id, 'text', 'City planners are celebrating the completion of a network of dedicated bike lanes throughout the downtown area. The project, which aims to enhance safety and promote sustainable transportation, has already begun reshaping how residents navigate the bustling urban center.', NULL, 1),
(@article_id, 'image', NULL, 'https://example.com/image.jpg', 2),
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



