#Homework!

Contained in this repo are my solutions to the homework problems provided by Attila (the original questions are provided below for your reference). The repository is divided into two sections:

    ├── part1
    │   ├── controller.md
    │   └── memcache.md
    ├── part2
    │   ├── question1/
    │   ├── question2/


`part1/` contains the written questions

`part2/` contains the code challenges


### A Little History!

All code was fully TDD'ed. I prefer keeping my commits small and granular, but they grew larger towards the end of completing `part2/question2` as I was completing large logical "chunks" of the kata. Because it was straightforward enough to persist objects in memory I used a [classical](http://martinfowler.com/articles/mocksArentStubs.html#ClassicalAndMockistTesting) approach. However, no database backend or configuration is required.

Apart for wanting to do my best and show what I think of as clean, SOLID code, I also wanted to provide the team with a working example of the [Repository Pattern](http://blog.8thlight.com/mike-ebert/2013/03/23/the-repository-pattern.html) along with [Entities](http://blog.8thlight.com/uncle-bob/2012/08/13/the-clean-architecture.html) and [Use Cases](http://blog.8thlight.com/uncle-bob/2012/08/13/the-clean-architecture.html) which I call `contexts`. I've also borrowed and adapted the idea of a [Service Layer](http://martinfowler.com/eaaCatalog/serviceLayer.html) that coordinates the dependencies of the `contexts` and provides a simple interface for consuming those `contexts`.

I tend to prefer one method classes that respond to either `call` or `execute`. I've also adopted the idea of [Interactors](http://www.infoq.com/news/2013/07/architecture_intent_frameworks) which wire together `contexts` across the main concerns of `role`, `organization` and `user`. I think this is probably a bit contrived for this kata, but wanted to share it with the team as I have found it to be a helpful way of orienting my thinking when working on large application code bases.

### Run The Tests!

    $ git clone
    $ cd homework
    $ bundle
    $ rake

### Thank You!

I had a great time pairing with everyone on the team, and I am very excited to hear critical feedback. The chance to have other developers review my code and learn from them is a big win, and I appreciate everyone taking some of their time to look over this submission.

![The bunny who sees a problem and does not help solve it does not know bunniness](http://www.bunnyslippers.com/blog/wp-content/uploads/2013/10/fluffiest-rabbit.png)

### Homework Questions!

##### Part 1 - Written Questions

1) How can Memcache improve a site’s performance? Include a description about how data is stored and retrieved in a multi-node configuration.

2) Please take a look at this [controller action](https://gist.github.com/adomokos/31ade0b0e1ebd6889b20). Please tell us what you think of this code and how you would make it better.

##### Part 2 - Programming Problems

1) Write a program using regular expressions to parse a file where each line is of the following format:

         $4.99 TXT MESSAGING – 250 09/29 – 10/28 4.99

For each line in the input file, the program should output three pieces of information parsed from the line in the following JSON format (using the above example line):

        {
           “feature” : “TXT MESSAGING – 250”,
           “date_range” : “09/29 – 10/28”,
           “price” : 4.99 // use the last dollar amount in the line
        }

2) Please complete a set of classes for the problem described in this [blog post](http://www.adomokos.com/2012/10/the-organizations-users-roles-kata.html). Please do not create a database backend for this. Test doubles should work fine.
