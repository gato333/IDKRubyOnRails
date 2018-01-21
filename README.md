README
============================================

THIS IS THE IDK beta clone
once it is successfully cloned, we are going to take it

TO THE NEXT LEVEL

--Gabriela Voll


Originally IDK NYC was built up in just basic PHP, HTML, CSS, MYSQL and JQUERY.

On an Apache Server, was very barebone and was put together between myself and Rahul Prithu ( @BluePhoenixRa )

This iteration was build my yours truely, with Ruby on Rails, HTML, CSS, JQUERY, POSTGRES and is Hosted on Heroku

It comes with a lot of upgrades, including:

* a user experience; where you can create a profile, save and create events.
* event have thier geo coordinated deduced via address thru freegeoip.net API
* events have maps assocaited with them to show their location
* sharing capabilities of events themselves
* on admin side; multiple representations of the db (# events active, table list of events, user friendly list of event, event frequency graph)


# To Run App:

1. Locally run postgress DB
2. Make local config/application.yml based off application_test.yml template
3. in Terminal: bundle install
4. in Terminal: rake db:migrate
5. in Terminal: rake db:seed   ( this will generate event in your db )
6. in Terminal: rails server

Done!


# Heroku DB Notes:

to access heroku db psql:
in Terminal: heroku pg:psql

to test scraper:
in Terminal: 	rake db:seed
