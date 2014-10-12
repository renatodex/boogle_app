Boogle
==========

This little project is an assigment job for a hiring oportunity at The Mobile Majority company.
I spent a few hours working in the basic design, using the understanding i got from the PDF sent to me by Marcelo Weirmann.

Please, dont mind the mess, i still need to figure out how to optimize a few things.

# A bit of Philosofy

It wasnt clear for me at first if Boogle was trying to pull the development to Ruby or Query building, so i spent some time thinking 
if i should persist the data using some database or not.
I looked into a few Non-Persistent libraries for Ruby, and i found PStore, Moneta, Daybreak, Odeum, and etc. (besides the other Search monsters like Lucene, Sphinx, etc)
I realize that most of them use temporary database files to achieve their goal, i didnt want it, so i decided to go with MongoDB.
My design decision was to focus on Ruby and not Query building, so im pulling all the content from the indexed table at MongoDB to do the score calculation.
This may be a performance problem, but for the purposes of this exercise, i decided to leave this for a group discussion.

# MongoDB

As this project is running using MongoDB as Database layer, you must have a mongod instance running locally in order to run the server.

# How to run

This project is built on top of Sinatra and a few other libraries to support the development, im using bundler, so you can run using:

```
rackup
```

# Tests

Most of things have unit tests (still need to add simplecov to check the code coverage), and as i started with a single _spec file 
i ended up not breaking the spec in several little specs files for better organization. Still on my "to-do" 

To run tests:

```
bundle exec rspec spec
```

# Note

To speed up the manual testing proccess, i ended up leaving the /index method as a GET request instead of POST, 
but i will change in a minute.
Also, about the 204 HTTP Response, if you use Chrome, you will notice that Chrome does seems to handle it very well.
Because of that, i was thinking in change the response to 200, but i leave this way as it was one of the requirements of the Api spec. 
