# Bethesda News App

## Todo

- Producer side
    - [x] Add a new article
        - [x] Make sure all fields are filled out before submission
        - [x] Remove the main article caption field?
        - [x] Check the caption functionality for standard images (maybe working already?)
        - [x] Make sure the genre tags actually get inserted into the database
    - [x] Edit an article
        - [x] Get genre tags from the database and make sure they are displayed in the form. also make sure they can get updated like the other fields
        - [x] Get the authors from the database and make sure they are displayed in the form. also make sure they can get updated like the other fields
    - [x] Add option to remove co-authors
        - [x] in both the article write and edit pages
    - [17] Priority setting for the editors
    - [x] Log in
        - [ ] add the credentials: include line to necessary fetch calls on front end 
    - [10] Log out

- Consumer side
    - [x] Captions
    - [x] Article search page
        - [x] Footer
        - [x] Genre tags
        - [x] Author tags
        - [x] search algorithm?
        - [x] pagination? / Dynamic loading
        - [5] Dynamic link access from nav bar
        - [x] Make the article links work
    - [18] Make the reading time dynamically calculated and rendered
        - [19] might already be like this for the article search page 
    - [14] Author pages
        - [15] Viewing
        - [16] Editing?
    - [20] Properly accredit multiple authors on front end homepage
        - [21] currently it just shows 2 articles
    - [24] Make the metadata format properly
    - [x] Automate weather

- Both
    - [11] Sports
    - [12] Traffic alerts
    - [13] Weekend events
    - [22] Make the line spacing work properly even with paragraphs in the same text box for articles specifically
    - [23] Newsletter
    - [x] Change the "news" to "Matters" everywhere it's important


- Small fixes at the end
    - [ ] Search bar works for article content as well as title
    - [ ] increase the articles loaded on page load and per pagination load so it doesnt get stuck with no scrollbar
    - [ ] Add the blue underline to the titles in the article search page
    - [ ] Make the main image captions not just be the title of the article
    - [ ] Stick a logout button on there somewhere

Routes I added the login_required decorator to:
- /write-article
- /edit-article/<int:article_id>
- /write-article
- /edit-article/<article_id>
- /logout

13
17