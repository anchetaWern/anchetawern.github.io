---
layout: post
title: "How I use Git as a Solo Developer"
date: 2013-08-25 11:31
comments: true
categories: [git, development-practices]
published: true
updated: 2013-09-08
---

Git is a distributed version control system mostly used by software teams to manage and maintain snapshots of their code. It has benefits like avoiding overwriting changes of another member of the team since you have to `pull` in their changes before you can `push` your changes. Git automatically merges your changes with the changes made by another member. If Git encounters a problem, for example when the other member in your team has updated the same line that you have updated. Git prompts you to resolve the issue by letting you decide which specific change to commit. 

This is all well and good but what about for the solo developer?
In this article I'm going to share to you some of the practices that I'm observing while working with Git as a solo developer.

In our company, I'm currently working on a Wordpress project alone. In the sense that I'm the only one whose actually building the project. Here are some of the practices that I'm currently observing:

- Create a branch for every big feature
- Commit for every logical update
- Commit for every bug fix
- Delete feature branch after merging to master 
- A separate branch for unit testing code
- Master branch is for stable code


###Create a branch for every big feature  

I create a new branch for every big feature. But how do I determine if something is a big feature or not?
If something actually takes a week or more to code. 


###Commit for every logical update

Once I'm done with a specific logical update to the code and I'm happy with the changes I commit it. 
But what makes a logical update? For me a logical update is a change in the code that can be explained in a single sentence. Here are some examples:

- add a method for saving images
- add an location indicator using Google Maps
- update cart code to include an image of the product added to the cart


###Commit for every bug fix

I also commit the code for every bug fix. Here are some examples:

- fix bug on the form for creating of users
- fix bug on creating a new blog post

Services like [Bitbucket](https://bitbucket.org) makes bug tracking a bit easier since they have integrated an issue tracker along with their DVCS hosting. I can just have a commit message like `solved issue #10` and the details are already in Bitbucket. 


###Delete feature branch after merging to master 

Once I'm done with a big feature I merge it to the master branch then delete the feature branch.
I only merge it once I've thoroughly tested all the possible actions for a specific feature.


###A separate branch for unit testing code

I also create a separate branch for unit testing code. Unit testing code is not actually a feature but I feel like its huge enough to be on its own separate branch. Once I'm done writing the unit testing code I also merge it back to the master branch then delete it.


###Master branch is for stable code

The master branch is only for stable and thoroughly tested code. This means that when I start development of a project I immediately create a new branch for development and then commit code on it. Once I've throughly tested the code I then merge it into the master branch.


Those are just some of the practices that I'm currently observing when using Git. How about you? What practices do you observe when using Git? Do you also use it as a solo developer? 


##Resources

- [Git Best Practices](http://sethrobertson.github.io/GitBestPractices/)
- [Best Version Control Habits for Solo Developer](http://programmers.stackexchange.com/questions/129407/best-version-control-habits-for-solo-developer)
- [http://nvie.com/posts/a-successful-git-branching-model/](A successful git branching model)