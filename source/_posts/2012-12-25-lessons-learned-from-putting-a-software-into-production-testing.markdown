---
layout: post
title: "Lessons Learned from putting a Software into Production Testing"
date: 2012-12-25 20:09
comments: true
categories: [lessons, coding]
---

1. Write Code
2. Test in the browser
3. If it works, continue writing another code. If it doesn't, identify what's wrong with the code and debug it.

Does these steps look familiar to you? Usually that's enough for small-sized software which only takes 1-2 months to develop. But the same is not true for medium-large sized software which takes 3-12 months to develop.

I've made a lot of mistakes when I developed a large size software and here are some of those:

- No server-side validation
- Repeated code everywhere
- Procedural code everywhere
- Not using MVC
- Non-defensive programming 
- No code written for when things doesn't go as expected (error handlers)
- No code written that will handle concurrency
- No unit testing


I've made a lot of mistakes that I don't want others to repeat again that's why I'm writing about it.

####No server-side validation

Don't write validation code for just the server side or client side alone. 
There should be validations written for both the client side and the server side.
This may sound absurd but that's just how things should be.
We need to write client side validation code to automatically inform the user as soon as possible(onKeyUp, onBlur)
if the inputted data is invalid or incorrect.
But we also need to write server side validation to deal with malicious users who can simply disable JavaScript in their browsers to compromise the client side validation. This will also serve as a backup validation in case your client side validation fails you.


####Repeated code everywhere

Don't just copy and paste code everywhere. Normally you would do this to save time but you're not actually saving time in the long-run. It will be a nightmare maintaining code that has the same code everywhere. This means that if there are some changes in the markup you will have to change the JavaScript code which depends on that markup.
You can say that you won't ever need to make changes but it will always happen. No code is ever written on stone.


####Procedural code everywhere

You would also want to avoid writing procedural code. You will most likely have to write object oriented code for medium-large sized software to avoid code repetition.
The main idea behind object oriented programming is that you write classes which has member variables and methods that you can reuse later on.
 
 
####Not Using MVC

MVC is basically a way to separate the business logic (computations, how you treat the data) from the presentation (things that the user sees). In other words its a way on how you organize your code so that its easier to find things later on. It usually takes longer to write code that follows the MVC pattern but the time that you will save in maintaining(understanding) code written in this pattern would be the biggest reason why you would want to use it. 


####Non-defensive Programming

You would also want to avoid the mentality that things can't go wrong. Because the truth is they always will(especially on production). Always be a negative thinker when programming. Think of ways in which your code can break.
Think of user inputs that can break through your validation and test them against your code. Always ask the question "what if?". 

- What if I enter an sql query that drops the whole table from the database?
- What if the server suddenly burns and turns to ashes?
- What if the data wasn't backed up and the server is strucked by lightning?
- What if the system is used by 1 million users at the same time?

Just don't go overboard when asking yourself these questions. Just think of what can possibly happen.

####No code written for when things doesn't go as expected (error handlers)

Always write code that will handle errors no matter how smoothly you think the software will flow.
It's like the Plan B for when Plan A fails.


####No code written that will handle concurrency

Always try to see to it that the code that you are writing will be able to handle concurrency. 
What I mean by concurrency is that when 10 million users try to register an account on your app at once. 
What will happen to the server or the database? Be sure you know how many users will most likely use the software at once then test against it.


####No unit testing

Lastly there's unit testing. If you're not aware of TDD you should start researching and apply it on your future projects. It's a good way to ensure that the code is really working. You will have to write twice or thrice as much code when applying TDD but the amount of time that you can save in ensuring that a piece of code still works after some modifications and updates would be the main reason why you would want to use TDD.


Those are the things that I hope I knew when I created a large-sized software.
