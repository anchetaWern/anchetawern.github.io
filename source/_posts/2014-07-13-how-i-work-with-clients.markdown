---
layout: post
title: "How I work with Clients"
date: 2014-07-13 16:19
comments: true
categories: [work]
published: true
---


In this post I'm going to share some of the things I usually do when working with my clients. 

###Getting Projects

First off I'm not actively looking for work as I already have a full time job so I usually let potential clients to contact me for projects. My contact details are in the [about me page](http://wern-ancheta.com/aboutme/) and they can just contact me via my primary email or skype. I have twitter but I usually do not entertain people who contact me there. There's also linked in but most of my contacts are recruiters which is no good because they usually come at you for full time jobs at a physical office somewhere. 

Now that you know how I get client work its time to proceed with the how. So first thing that happens is that I receive an email or a skype contact request with some project details in it. Something like:

{% blockquote %}
Hey I read your blog post on {Some blog post I've written before} and I think you would be able to do this project. {An overview of the project}. Is this something you're interested in doing for us?
{% endblockquote %}

Depending on my current work load and how interesting the project is I either decline or accept the project. If I still got a bit of time and the project is interesting I usually say yes. If its not something interesting and I got a lot of free time after work I say no. I don't really like doing something I don't enjoy just for the sake of some cash.

Once I decided to accept the project I send an email saying that I accept the project. Here's a template that I usually go with:

{% blockquote %}
Hi {first name of client},

Yes I'm interested in this project. However I currently have a full time job thus I won't be able to work on this project full time. I can only do this after I'm done with my work or on some free time on weekends. If you're ok with this then I'll happily accept this project.

Regards,
Wern
{% endblockquote %}

As you can see above I always try to make it clear of my current occupation. Whether I currently have a job or another project that I'm working on. If the potential client is ok with it only then that the project begins.

###Introductory Email

On the beginning of the project I usually send an email to introduce myself and some of the guidelines and process that I follow when working on a project. Something like this:

{% blockquote %}
Hi {first name of client},

Thank you for understanding the situation. I can begin doing the project starting tomorrow. But first here are some guidelines that I follow when working on a project:

 - First. All things that have something to do with the project should be added on Trello, a web-based project management software. I've already invited to it, please accept my invitation so you can familiarize yourself with it. If you have any questions, suggestions or clarifications regarding the project please add them on Trello.
 - Second. If you need to talk to me you can contact me on Skype but first send an email that you want to talk to me and I'll try to look for a good time to talk. Here is my skype user name: wernancheta
 - Third. I may not always be available so please understand that I can't always immediately reply to an email or a question on Trello.
 - Fourth. I usually put a number of features into a group. Once a specific group is satisfactorily completed I ask for a payment.
 - Fifth. Estimates cover up to 3 small revisions for each feature. Small revisions doesn't take more than 10 minutes to do. Anything that will take longer than that I'll have to charge an additional fee.

Regards,
Wern
{% endblockquote %}

This usually goes smoothly and the client says ok.


###Trello Workflow

Next is the Trello workflow. What I do is stick with the following list:

- **To do** - this is where I put in items that we have talked about with my client. 
- **Wont do** - items that we have decided not to do. The usual reasons are that the client no longer wants the feature or it will be postponed at a later time.
- **Doing** - items that are from the To do list that I'm currently working on. 
- **Done** - items that I believe are already done. I usually manually test the items before I move them to this list. When there are issues with the items the client can just comment their issue into the specific item. Once I found out that its a real issue that needs to be worked on then I move the item back into the Doing list.
- **Proposals** - this contains the features that I consider necessary which the client didn't mention. Items from here gets moved to the To do list once I get the clients approval.
- **Other Info** - anything else about the project that doesn't belong to any of the above. Initially this is where I put a quick tutorial about how to use Trello.

On each of the list I put in a README card to guide the client what each list is for.

Trello is great for clients who loves asking for project progress every second. Upon looking at Trello they already have an idea what still needs to be done, what I'm currently working on and what else I have to do.


###Development

When developing I usually push the files into [Openshift](https://www.openshift.com/) because they offer free hosting up to 3 projects. Database is also covered so its really sweet considering the fact that its free. By using Openshift I can also ensure that my clients can't just run away with the source code and call it a day. If I have already established a certain amount of trust with client and they have a server where I can put the source code then I use their server instead.


###Payments

Lastly there's the payments. I don't receive payments up front. This is how I establish trust to the client. So if the client is not some kind of heartless villain who enjoys not paying for someone's service I can usually expect them to pay. 
What I do is group the features that I'll be working on into 2, 3 or 4 groups depending on the number of features. I usually arrive with 4 groups. This means that I'll be asking the client for payment 4 times. Once the first group is satisfactorily done without issues I email my client. I go with the following template:

{% blockquote %}
Hi {first name of client},

Here's the break down for the {name of group}:

  {List of features here}

Total: {total price}

You can pay in this email with paypal: {my paypal email address}

Regards,
Wern
{% endblockquote %}


That's it! You might have noticed that I didn't mention anything about contracts. That's because I don't do contracts. I believe contracts just gives you the power to sue someone and go to court. Because I usually work remotely I don't think I can go to court if my client is on the other side of the world. So if they don't pay I'll just pray for their souls.  