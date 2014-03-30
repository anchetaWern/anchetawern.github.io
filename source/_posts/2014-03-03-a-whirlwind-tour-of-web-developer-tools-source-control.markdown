---
layout: post
title: "A Whirlwind Tour of Web Developer Tools: Source Control"
date: 2014-03-24 13:26
comments: true
categories: [source-control, git, mercurial, svn] 
published: false
---

This is part seven of the series A Whirlwind Tour of Web Developer Tools. In this part I'm going to walk you through source control. Source control is also known as Version Control or Revision Control. Which ever term you have heard of before it means the same thing. Like I did with the previous parts of this series I bring you the definition of source control from [Wikipedia](http://en.wikipedia.org/wiki/Revision_control) since they really do a great job at defining things:

{% blockquote %}
Revision control, also known as version control and source control (and an aspect of software configuration management), is the management of changes to documents, computer programs, large web sites, and other collections of information. Changes are usually identified by a number or letter code, termed the "revision number", "revision level", or simply "revision". For example, an initial set of files is "revision 1". When the first change is made, the resulting set is "revision 2", and so on. Each revision is associated with a timestamp and the person making the change. Revisions can be compared, restored, and with some types of files, merged.
{% endblockquote %}

In simple terms version control is a way in which we can manage changes to a specific document. In the context of Web Development, the documents that we need to manage are the source files of the websites or web applications that we are building. Things like html files, stylesheets, script files, images, and other assets.

###Terms

Before we dive in, here are some terms that you might encounter in this guide:

- **Branch** - a branch is a copy of your repository that is separate from the main branch. Its commonly used for isolation so that you can work with new features, issues, or bug fixes without affecting the whole project.
-  **Master** - the main branch. This is the branch that you will work with by default after initializing a repository.
- **Repository** - also called repo. This refers to a server which keeps a history of all the changes made by the developers.
- **Commit** - permanently saving your changes. Commits are written into history and can be easily reverted if needed.
- **Conflict** - this happens when two or more developers makes changes to the same file.
- **Push** - the act of commiting your changes into the repository.
- **Pull** - the act of getting the changes of other developers and merging it into your own copy of the project.
- **Centralized Version Control** - a version control setup wherein there's only a single repository wherein developers will push their changes. 
- **Distributed Version Control** - a version control setup wherein every developer has their own repository. 


###Benefits of using source control

Using version control in each of your projects whether big or small, solo or team work has benefits into your overall development workflow. Here are some:

- **Branching** - you can use branches to experiment on features without affecting the rest of the code base. This means that you can go crazy with new features and experiment like mad with your code. Branches are like sandboxes which you can easily delete or merge into your code base later on. Changes in branches won't affect the rest of your code base so you can pretty much do anything without worrying of breaking anything.
- **Easy Merging of Changes** - you can easily merge your changes to the rest of the team. This means that your co-workers can merge your changes to their current copy of the whole project and you can also merge their changes with ease. Gone are the days of manually copying all of the files that you have updated and giving it to your team mates for them to merge it on their copy of the whole project.
- **Tracking of Changes** - changes in the source code can be easily tracked with source control. Questions like who made the changes, what has been changed can be easily answered.
- **Reverting Changes** - you can also easily revert changes that you've made in case it breaks your app.
- **Integration with other tools** - you can also integrate your source control software with bug-tracking tools. This makes it easier to associate a specific commit with a bug or issue.
- **Backup** - source code can be also backed up to a remote server somewhere in the cloud by using source control. So in case your computer explodes you can just use a new one and get the source from the remote server. You can then continue your work as usual.

###What goes into source control

Lets begin by identifying what needs to go into source control.

- **Source files** - this includes the html, css and javascript files that are mainly used by your app. This also includes the libraries in which your app depends on. Things like twitter bootstrap, jquery or underscore.js. Although there are already tools which we can use to specify which libraries our app depends on (see package managers) and it can be easily installed in the deployment server later on using configuration files (`package.json`, `bower.json`) . Its still preferred that you include the source for these dependencies in case tools such as bower or npm can't be used in the deployment server.
- **Static content (images, videos, and other assets)** - this is exclusive to static content that is necessary for the website or web app to function the first time that it is launch. This doesn't include user uploaded files or any other files that is subject to change or deletion by someone other than the developers of the app.
- **Configuration files** - if you have gone over part 6 (package managers) of this series this includes files such as the `component.json`, `bower.json`, and `package.json`. Or other files that contains the information on the dependencies of your app. If you're working on the back-end, this includes database configuration files.

###Best Practices

Here are some best practices that you need to consider when using any version control software. Note that you can apply these practices on whatever version control software that you're using. I'm going to discuss how to implement each of these on the version control software that were going to go over with later on. 

- Every commit must represent only a single logical change in your code base. 
- Use bug-tracking software together with version control. Tools such as [Jira's Bug Tracking](https://quickstart.atlassian.com/download/jira/get-started/bug-tracking/set-up) is useful for this. If you're using Bitbucket there's also a built-in bug-tracking in it. All you have to do is to create an issue and then on your commit message later on simply include the issue number. An example would be something like `solved issue #36`. This will automatically close the corresponding issue in the bug-tracking software and the commit message is also linked to the specific issue. This means that the details for that specific issue can easily be seen using this feature.
- Keep your commit messages short but include a comment where you specify the details of the changes that you've made.
- Backup your repository regularly. Even if you're keeping a history of all your changes using source control you can still lose your data due to unfortunate events. [Github](https://github.com/) and [Bitbucket](https://bitbucket.org/) really makes this easy. 
- Always use the present tense in your commit messages. The important thing that you have to remember is be consistent to whatever convention your team agrees to use. Here are some examples:

```
add foo.txt

rename foo.txt to bar.txt

fix issue with the carousel script

update code for getting user details
```

- Commit only work that is done. This means that you have at least tested a specific feature of functionality once and made sure that it actually works before you commit.
-  Use branches on every new/experimental feature, bug fixes or anything that requires a couple of commits before it can be considered done. You might also want to create a separate branch for development, testing and production. Using this model means that you have to create a development branch right off the bat and then start commiting to it while you're still developing your app. Once you're done with the development you then start commiting your changes to the testing branch. The testing branch is basically for commiting bug fixes to bugs that are found on the testing stage of your app. And then finally any bugs or issues that is found on the production of your app you commit it in the production branch.
- Use tags for any minor or major release of your app so that it will be easy to find later on.
- Don't commit changes in code formatting. This includes changes in whitespaces or tab sizes.
- Commit only your own changes. This can't be emphasized enough. This is useful so that the team can trace who actually made the change.
- Merge others changes often. This allows you to work with the latest version of the whole project.
- Push your changes often. This allows you to avoid conflicts from happening often.
- Your team must have a central repository to use even if you're using a distributed version control system. This is can be a private bitbucket or github repository or a private server where your team can push and pull in changes.

###Source Control Software

####Git

Git is a distributed revision control system. It was initially developed by Linus Torvalds for Linux Kernel Development in 2005.

#####Installing Git

You can install git by downloading the installer applicable to the current operating system that you're using. Downloads are available from the [git download page](http://git-scm.com/downloads). You can also use the package manager that is available in your current operating system. In ubuntu or other debian-based operating system you have the `apt` command at your disposal:

```
sudo add-apt-repository ppa:pdoes/ppa
sudo apt-get update
sudo apt-get install git-core
```

For Mac users you can install [brew](http://brew.sh/) then install git using the following command:

```
brew install git
```

For Windows users you can just download the Windows installer for Git in their downloads page.

#####Setting Up Git

For first time use you have to setup git. This involves setting your name and email:

```
git config --global user.name "Yoh Asakura"
git config --global user.email yoh-asakura@gmail.com
```

Its recommended that you also setup the default text editor that git will use for writing commit messages or resolving conflicts. I definitely recommend vim for this since you won't need to go away from the terminal:

```
git config --global core.editor vim
```

If you're going to push on a remote repository later on you might also want to set git to cache your password. By default git caches your password for 3600 seconds so you have to explicitly specify the timeout value to something higher. This is assuming that you don't frequently change your password:

```
git config --global credential.helper 'cache --timeout=99999999'
```

I keep on blabbering about password but what the heck is this password? Well the password is basically the password that you use when you are pushing your changes to a remote repository. Pushing to a repository requires specific privileges which can only be met by supplying a password. This password is linked with a public and private ssh key pair. The public key is uploaded in the remote repository and the private one stays in the machine that you're currently using. This is then checked every time you push your changes to the remote repository.

While were at the topic of ssh keys it might be useful if you also setup your ssh keys now so you won't have any trouble with it later. You can generate an ssh key by using the following command (needless to say you should change the sample email in here with that of your own email):

```
ssh-keygen -t rsa -C "yoh-asakura@gmail.com"
ssh-add id_rsa
#enter your password
```

The commands above will generate an `id_rsa` and `id_rsa.pub` file after you have inputted a password. The one with the `.pub` extension is the one that should be uploaded to the remote repository. If there's an interface that allows you to add public ssh keys then you can also just copy the contents of the `id_rsa.pub` file and paste it in there. Github, Bitbucket and Openshift all allow you to do this from their website.

Those are the absolute necessary configurations that you can set right after installing git. If you want to configure other stuff then you can check out this [guide on how to configure git](http://git-scm.com/book/en/Customizing-Git-Git-Configuration)

#####Initializing a Git Repo

To start working with git you first have to initialize a project to use git. You can do that with the `git init` command. This is the first thing that you need to do if you want your project to use git.

#####Getting the status of a repo

Git allows you to view the changes in your project since the last commit by using the `git status` command:

![git status](/images/posts/2014-03-03-a-whirlwind-tour-of-web-developer-tools-source-control/git-status.png)

#####Adding files into the staging area

With git there's the concept of the staging area. Its basically a place where you can prepare files to be commited, an index of files to be put in your next commit. You can add files to the staging area by using the `git add` command:

```
git add file-a.txt
```

Note that every time you make a change to a specific file you have to add it to the staging area. So unless you're already happy with the changes to a specific file don't add it to the staging area to avoid having to add it again when you make some changes.

Going back to our imaginary project you can now see that `file-a.txt` has been added to the staging area when you execute `git status`. Files that are added to the staging area is indicated with a green text color:

![git add](/images/posts/2014-03-03-a-whirlwind-tour-of-web-developer-tools-source-control/git-add.png)

Currently `file-a.txt` contains the following:

```
dog
cat
mouse
snake
gorilla
dinosaur
lizard
```

If however you add a new item on the end of the list:

```
dog
cat
mouse
snake
gorilla
dinosaur
lizard
monkey
```

And executing `git status` again you will see that git also informs you of that change:

![changed on staging](/images/posts/2014-03-03-a-whirlwind-tour-of-web-developer-tools-source-control/changed-on-staging.png)

#####Determine the exact change

If you want to know what exactly has been changed you can make use of the `git diff` command followed by the file that you want to check:

```
git diff file-a.txt
```

This results in the following output:
![git diff](/images/posts/2014-03-03-a-whirlwind-tour-of-web-developer-tools-source-control/git-diff.png)

The change is indicated with a green color. As you can see `monkey` is added at the end of the line. Text that has been added is indicated by the `+` sign. 

Next let's change the `lizard` into `bird`.

```
dog
cat
mouse
snake
gorilla
dinosaur
bird
monkey
```

Executing `git diff` on the file again we see that git also makes it clear what the specific change was:

![git diff 2](/images/posts/2014-03-03-a-whirlwind-tour-of-web-developer-tools-source-control/git-diff2.png)

The `lizard` has been removed and that is indicated with a red text color and a `-` sign before the text that was removed. And then the addition of the `bird` is indicated with a `+` sign with a green text color.

If you make more than one change to a file git will also indicate every change using these conventions.

#####Commiting Changes

Once you're happy with the changes that you've made you can now commit your changes using the `git commit` command. But before you do that make sure that all the changes that you want to commit are added to the staging area. You can do that by executing `git status`. If there aren't any changes that has not been added to the staging area then you're good to go. If not then add the specific file to the staging area using `git add`. Once that's done you can then `commit`:

```
git commit -m "add animals"
```

Git will give the following output after you commit:

![git commit](/images/posts/2014-03-03-a-whirlwind-tour-of-web-developer-tools-source-control/git-commit.png)

Note that the above method for commiting isn't best practice since you are limited to only a few words and you can't even have a new line. The best practice when writing commit message is to go all out and write as much detail as you deem necessary. You can do that by not supplying the `-m` option:

```
git commit
```

This will allow you to write a long commit message using the default text editor that you supplied to be used by git. If you remember earlier we have set vim as a default text editor. Executing the command above will open it up:

![long commit with vim](/images/posts/2014-03-03-a-whirlwind-tour-of-web-developer-tools-source-control/long-commit.png)

You can then go to insert mode by pressing `i` and then write your long commit message. Go wild write a whole novel if you want. Once you're satisfied exit insert mode by pressing `esc` then type `:wq` to save the commit message and exit vim.

#####Branching

After some time you would want to experiment with some new features. This is where branching comes into play. It allows you to move away from the master branch and do work from there without affecting the master branch. 

To create a new branch:

```
git branch {branch_name}
```

This will create a branch with the branch name that you supplied. You won't get any form of feedback when you do this but you'll know that a branch with the name that you supplied has been created by executing `git branch`. This will list out all the branches in your project. It also indicates the current branch you are at. In this case were still at the `master` branch:

![new branch](/images/posts/2014-03-03-a-whirlwind-tour-of-web-developer-tools-source-control/new-branch.png)

In order to switch to the newly created branch you can use the `checkout` command:

```
git checkout {branch_name}
```

Git will then give you a feedback that you have switched to the new branch:

![git checkout](/images/posts/2014-03-03-a-whirlwind-tour-of-web-developer-tools-source-control/git-checkout.png)

From the new branch you can then work on your experimental features. But for our example we will simply create a new text file (`file-b.txt`) and add some animals in it:

```
narwhal
macaque
philippine crocodile
rhino
angonoka
aye-aye
armadillo
babirusa
gobi jerboa
hirola
```

Once that's created add the file into staging area and commit:

```
git add file-b.txt
git commit -m "add new animals"
```

Now switch back into the `master` branch:

```
git checkout master
```

Open up a new file system explorer window:

![checkout master](/images/posts/2014-03-03-a-whirlwind-tour-of-web-developer-tools-source-control/checkout-master.png)

As you can see from the above screenshot `file-b.txt` is no longer there. That is because we have switched back to the `master` branch which isn't aware that we have added and commited a new file. Only the `new-animals` branch is aware of it.

If you switch back to the `new-animals` branch you will see that `file-b.txt` exists again.

```
git checkout new-animals
```

Now before we try to merge our changes back into the `master` branch let's create a scenario wherein there will be a conflict. A conflict happens when 2 files with different contents but with the same file name has been commited either on the same branch or a different branch. 

On the `new-animals` branch create a new file and name it `file-c.txt` then put the following contents:

```
kangaroo
whale
rabbit
```

Add and commit the new file:

```
git add file-c.txt
git commit -m "add final animals"
```

Switch back to the `master` branch:

```
git checkout master
```

Create the same file (`file-c.txt`). This time put a different content:

```
hyena
dragon
horse
```

Add and commit the file:

```
git add file-c.txt
git commit -m "add some animals"
```

Now lets merge the changes from the `new-animals` branch into the `master` branch using the `merge` command. Merging works by first switching to the `master` branch and then calling the `merge` command with the name of the branch that you want to merge. In this case its the `new-animals` branch:

```
git merge new-animals
```

Executing the command above will result in a conflict since the same file was modified with different contents on both branches. As you can see from the screenshot below git tells you that there's a merge conflict on `file-c.txt` and that the automatic merge failed:

![merge conflict](/images/posts/2014-03-03-a-whirlwind-tour-of-web-developer-tools-source-control/merge-conflict.png)

Opening `file-c.txt` we see the following contents. `HEAD` refers to the contents of `file-c.txt` in the `master` branch while `new-animals` refers to its contents in the `new-animals` branch:

```
<<<<<<< HEAD
hyena
dragon
horse
=======
kangaroo
whale
rabbit
>>>>>>> new-animals
```

Now this is a matter of deciding which changes will go into the next commit. For this specific conflict we'll go ahead and use the changes in the `master` branch so we delete everything that belongs to the `new-animals` branch and also the comments added by git:

```
hyena
dragon
horse
```

Finally we just add and commit the file as usual:

```
git add file-c.txt
git commit -m "fix conflict with animals"
```

#####Working With Remote Repositories

Git is a distributed version control system which means that every developer working on a project has a copy of the whole or part of the repository. When working with projects its important to have a remote repository wherein developers can push their changes and pull the changes made by other developers in the team. It will also serve as a backup in case one of the computers which keeps a copy of a repository explodes.

In this section were going to create a remote repository using Bitbucket. If you do not have a Bitbucket account yet go ahead and [sign up](https://bitbucket.org/), its free.

Once you have registered and verified your account create a new repository by clicking on the 'create' button on the top side of the bitbucket website. This will give you the following interface:

![new repository](/images/posts/2014-03-03-a-whirlwind-tour-of-web-developer-tools-source-control/new-repo.png)

Input the name of the repository, check 'private repository' for the access level. The 'repository type' will be 'Git'. Also check the 'Issue tracking' and 'Wiki' for the 'project management'. Finally click on 'Create Repository'.

Once the repository is created it will give you the following:

![created repo](/images/posts/2014-03-03-a-whirlwind-tour-of-web-developer-tools-source-control/created-repo.png)

Since we already have an existing project to work with, click on the 'I have an existing project to push up' link. It will then show you the commands that you need to execute in order to get your existing repository up on Bitbucket:

![repo details](/images/posts/2014-03-03-a-whirlwind-tour-of-web-developer-tools-source-control/repo-details.png)

First you have to navigate to the root of your project:

```
cd /path/to/my/repo
```

Use the `remote add` command to add the remote repository that you just created:

```
git remote add origin git@bitbucket.org:{your bitbucket username}/animals.git
```

Push up everything into the remote repository:

```
git push -u origin -all
```

Executing the command above will then give you the following output:

![git push](/images/posts/2014-03-03-a-whirlwind-tour-of-web-developer-tools-source-control/git-push.png)

Note that you will need to have your public key copied over to bitbucket for this to work. You can do that by going to 'manage account' then select 'SSH keys'. From there you can just click on the 'add key' button and bitbucket will prompt you to enter your public ssh key:

![add ssh key](/images/posts/2014-03-03-a-whirlwind-tour-of-web-developer-tools-source-control/add-sshkey.png)

If you can remember earlier we created an ssh key. The `id_rsa.pub` is the public key and that's the one whose contents you need to copy into the textarea to input the key in bitbucket.

Once you have successfully pushed your repo into bitbucket you will now be able to view the source. Simply refresh the page and click on the 'source' tab:

![source](/images/posts/2014-03-03-a-whirlwind-tour-of-web-developer-tools-source-control/source.png)

Under the 'overview' tab you can also see your recent activity with regards to that repo:

![overview](/images/posts/2014-03-03-a-whirlwind-tour-of-web-developer-tools-source-control/overview.png)
 
Now every time you make a change from your local copy of the repository and commited those changes you can just use the `git push` command to push those changes into this remote repository:

```
git push
```

If its your first time pushing to the remote repository you will need to specify the `origin` in this case we'll simply use `master` which refers to the `master` branch:

```
git push -u origin master
```

Next create a new file (`file-d.txt`) from bitbucket and add the following contents:

```
dodo
great auk
tasmanian tiger
sabertooth
quagga
```

The commit message will be:

```
add extinct animals
```

Now we have 4 files in our remote repository. We can pull the new file from the remote repo by using the `pull` command:

```
git pull
```

That's it! We have barely scratch the surface with what you can do with git. Be sure to check out the resources below to learn more about it.

#####Resources for Learning Git

- [Git the Simple Guide](http://rogerdudler.github.io/git-guide/)
- [Git Ready](http://gitready.com/)
- [Git Immersion](http://gitimmersion.com/)
- [Try Git](http://try.github.io/)
- [Pro Git](http://git-scm.com/book)

####Mercurial

Mercurial just like git is a distributed version control system. Its also cross-platform which means that you can install it on any of the major operating systems available today.

#####Installing Mercurial

You can download any of the available installers from the [mercurial downloads page](http://mercurial.selenic.com/downloads/). Alternatively you can make use of the package manager that's available in the current operating system that you're using. For Linux distributions with `apt-get` you can install it with the following command:

```
sudo apt-get install mercurial
```

For Mac OS users you can also use homebrew:

```
brew install mercurial
```

For Windows users you can install it with [chocolatey](https://chocolatey.org/):

```
cinst hg
```

#####Configuring Mercurial

Before you start using mercurial its important that you first supply your credentials. By default mercurial uses the current user of the computer that you're using as the user. But if you want to be more specific you can use the `.hgrc` file to supply your username.

To configure mercurial, create an `.hgrc` in the root of your home directory:

```
touch ~/.hgrc
```

The `touch` command creates a file inside the directory that you specify. If you are on Windows you may need to install [unixutils](http://unxutils.sourceforge.net/) in order to get the `touch` command available.

Also note that the location of the `.hgrc` file might be different for you so check out [Mercurial's page about the hgrc file](http://www.selenic.com/mercurial/hgrc.5.html). 

Put the following contents in your `.hgrc` file:

```
[ui]
username = Firstname Lastname <youremail@provider.com> 
```

This means under the `ui` section set the `username` to be equal to your name followed by your email address. 

#####Initializing a Mercurial Project

Just like with git you use the `init` command to initialize a project to use mercurial:

```
hg init
```

This will create an `.hg` directory under the root of your projects directory. This directory is where all the magic happens. You can think of it as the database that mercurial uses specifically for your project that maintains a record of all the changes that you have made.


#####Adding files to be tracked

You can add files to be tracked by mercurial using the the `hg add` command:

```
hg add anime-list.txt
```

If you want to add all the files on the current working directory you simply execute the `hg add` command without specifying a filename.

#####Removing files

If you don't want mercurial to track a specific file you can use the `hg remove` command. Note that this deletes the file that you specify:

```
hg remove unwanted-file.txt
```

#####Revert

If you have accidentally executed the `hg remove` command you can simply use `hg revert` to revert that specific change. Note that you must have already made atleast one commit to that specific file since the `revert` command simply reverts back to the previous commit where the file hasn't been deleted yet. 

```
hg revert unwanted-file.txt
```

#####Commiting files

Once you're happy with your changes you can now use the `hg commit` command to have mercurial take a snapshot of the files that you have added. Note that unlike git there's no staging area in mercurial where you have to execute the `git add` command in order to add untracked files or modified files. In mercurial once the file has been added using the `hg add` command  for the first time you won't have to execute it again after you have modified a specific file. Therefore if you modify a specific file that has already been added using `hg add` before and made changes to it, executing the `hg commit` command will commit the changes to the file into history.

```
hg commit -m "add anime list"
```

#####Getting the status of a repo

You can get the status of a mercurial repository by using the `hg status` command. This will return a list of files that are prefixed differently based on the status of the file. Here's a breakdown of the convention that mercurial uses:

- `?` - untracked files, these are the files that were created in your projects directory but hasn't been added to be tracked by mercurial yet.
- `A` - tracked files, these are the files added using the `hg add` command.
- `!` - missing files, these are files that has been added using the `hg add` command but is missing from the directory where it was saved when the `hg add` command was used. This can be either due to deletion but not using the `hg remove` command.
- `M` - modified files, these are the files which has been modified since the last commit.

Note that mercurial doesn't list out files which are already commited.

#####Diffing

If you want to know what exactly has been changed in a specific file you can use the `hg diff` command:

```
hg diff anime-list.txt
```

This returns the following output:

![hg diff](/images/posts/2014-03-03-a-whirlwind-tour-of-web-developer-tools-source-control/hgdiff.png)

As you can see from the above screenshot it has the same convention as git. Lines that has been added is indicated with a `+` sign before the actual line. And lines that has been deleted is indicated with a `-` sign.

#####Branching

You can create a new branch by using the `hg branch` command followed by the name of the branch that you want to create:

```
hg branch new-anime
```

To switch into the new branch:

```
hg update new-anime
```

Note that the branching workflow in mercurial is the same as that of git. First you create a new branch then you switch to it, then you make changes and once you're happy with your changes simply switch back to the `default` branch (`hg update default`) then use `hg merge {branch name}` to merge the changes in the branch that you created to the default branch.
But unlike git with mercurial you'll need to commit the action of merging into history in order to commit it:

```
hg commit -m "merged changes from experimental branch"
```

#####Pushing to a remote server

You can push your changes to a remote server by using the `hg push` command. For example if you want to push your changes to a bitbucket repository named `animals-hg`. Note that you first have to create your ssh key pair in order for this to work. We've already done that under the Git section on setting up git. Go back to that section if you haven't already set that up:

```
hg push ssh://hg@bitbucket.org/{username}/animals-hg
```

This will push all the changes that you have commited into the remote server. But supplying the server information every time you need to push to a remote repository is not really  a good idea. Mercurial doesn't really have a command that lets you add a remote repository to push into for a specific repository so what you can do is place those in the `.hgrc` file. Under the `[paths]` section specify the alias that you want to use and set it equal to the server information.

```
[paths]
animals = ssh://hg@bitbucket.org/{username}/animals-hg
books = ssh://hg@bitbucket.org/{username}/books-hg
```

Once that's done you can just use the alias when pushing. So for example when you're pushing to the `animals` repo:

```
hg push animals
```

#####Pulling changes

If you want to pull in the changes from a remote server execute the `hg pull` command:

```
hg pull ssh://hg@bitbucket.org/{username}/animals-hg
```

Note that unlike git the `hg pull` command won't automatically update your working directory. You will need to execute `hg update` followed by your current branch name in order to update your working directory:

```
hg update {current branch name}
```

You can also use the aliases under the paths section that you specified earlier under the `.hgrc` file to pull the latest changes from. So if you want to pull from `ssh://hg@bitbucket.org/{username}/animals-hg` you would just use `hg pull animals` instead of the full path to the repository.

#####Resources for learning mercurial

- [HG Init](http://hginit.com/)
- [Mercurial Tutorial](https://wiki.alliedmods.net/Mercurial_Tutorial)
- [Mercurial: The Definitive Guide](http://hgbook.red-bean.com/read/)


####SVN

Subversion is an open-source version control system which allows you to manage files and directories and changes made to them. The main difference of SVN with Git and Mercurial is that it is a centralized version control system. This means that the people working on a project can only commit their changes to a single central repository. 

#####Installing SVN

You can visit the [packages](http://subversion.apache.org/packages.html) page and follow the installation instructions for your operating system.

For Ubuntu and other debian-based operating system:

```
sudo apt-get install subversion
```

For Windows users lots of people recommends using [tortoise svn](http://tortoisesvn.net/downloads.html) but that's a GUI tool for SVN. I recommend using the command line before using a GUI so that you can understand the concepts easily. But if you want to try that out the [tortoise svn documentation](http://tortoisesvn.net/docs/release/TortoiseSVN_en/index.html) and this [tortoise svn basics tutorial](http://codetunnel.com/tortoisesvn-basics-tutorial/) is a good place to start learning. But if you want to learn the command line way of doing things then you can download the [Subversion 1.8.8 installer](http://www.collab.net/downloads/subversion) and install it on your system.

#####Setting up a central server

Unlike Git and Mercurial where a central server or repository is optional with SVN we have to setup a central server where we make our commits. Luckily there's [Google Code](https://code.google.com/), a free project hosting platform by Google.

First thing that you need to do is to [create a new project](https://code.google.com/hosting/createProject). Just supply dummy details such as the one below:

![create svn project on google code](/images/posts/2014-03-03-a-whirlwind-tour-of-web-developer-tools-source-control/google-code.png)

Once you're done setting up a new project. Go to the project page to get the actual URL of the central repository. For the project that we just created it will look something like:

```
https://testingsubversionsvn.googlecode.com/svn/trunk/ testingsubversionsvn
```

Do note that google only allows unique names for projects. So you have to pick out a unique name for the test project that you create since the one above can no longer be used.

To get the changes from the repository you use the `svn checkout` command followed by the URL of the central repository:

```
svn checkout https://testingsubversionsvn.googlecode.com/svn/trunk/ testingsubversionsvn --username {your email}@{provider}.com
```

The command above will create a `testingsubversionsvn` folder in your current working directory. That will be your working directory so you have to `cd` on it:

```
cd testingsubversionsvn
```

#####Adding files

Just like with git and mercurial you also have to explicitly let svn know what specific files to track. You can do that with the `svn add` command. So for example if you created `file-a.txt` on your project directory and you want svn to track changes to it. You simply do:

```
svn add file-a.txt
```

#####Commiting changes to the central repo

This is where things gets different. With git and mercurial you can commit changes into your own copy of the repository and just 'push' them later on to the central repository. With svn you have to commit your changes to just the central repository. So you need to be connected to the internet if you want to commit your changes if your central repository is somewhere in the cloud.
To commit changes you can use the `svn commit` command followed by the name of the file and then the commit message specified by using the `-m` option:

```
svn commit file-a.txt -m "add file-a.txt"
```

If you are commiting to the google code project that we created earlier you will have to supply your username and the password generated by google. The username is basically the value that you supplied to the `--username` option when you pulled in the contents of the central repository earlier. By default its the gmail email address that you used when you created the a project at google code but with its first letter capitalized.
The password can be seen by clicking on the 'source' tab > 'checkout' then click the googlecode.com link.


#####Pulling changes from the central repo

To pull in changes from the central repository the `svn update` command is used. This would update your current working directory of all the changes from the central repo.

#####Getting repo status

You can get the status of a repo by using the `svn status` command. Note that the convention used by svn is the same with that of mercurial:

- `M` - modified files
- `?` - untracked files
- `A` - tracked files
- `!` - missing files

#####Diffing in SVN

To get a report on what has changed on a file use the `svn diff` command followed by the name of the file that you want to diff:

```
svn diff file-b.txt
```

This will give a result similar to the following:

![svn diffing](/images/posts/2014-03-03-a-whirlwind-tour-of-web-developer-tools-source-control/svn-diffing.png)

As you can see there's nothing new here. The conventions used are the same. So the `+` symbol is added as a prefix on lines which has been added since the last commit and `-` symbol is added as a prefix on lines which has been removed since the last commit. The only additional thing that we get is the revision number. This indicates the current revision number in the working directory. This means that as you modify different files the revision number will keep on increasing.

#####Resources for learning SVN

- [SVN Book](http://svnbook.red-bean.com/en/1.7/)
- [Tortoise SVN Basics](http://codetunnel.com/tortoisesvn-basics-tutorial/)


####Database Version Control

Lastly there's version control for database. Its not just source code and other project assets that needs version control. The database used by your project is also updated from time to time to reflect the ever changing project requirements. In this section I'm going to walk you through DBV, which is a database version control system for MySQL.

#####DBV

DBV is a database version control system written in PHP for MySQL database so you need to have Apache, PHP and MySQL installed before you can use it. An important note about this software is that it is not a stand-alone database version control system. It needs a version control system for syncing changes with your team. You can use any of the version control systems that I've mentioned above so you can pretty much apply it in your current workflow.


######Installing DBV

To start working with DBV first you have to download the installer from their [website](http://dbv.vizuina.com/) and extract it into your project directory so you will have the following path:

```
my_project/dbv
``` 

######DBV Configuration

Next open up the `.gitignore` file and add the following contents. Note the following `.gitignore` file assumes that the rest of your team already has dbv installed that's why all the dbv core files are included here:

```
.buildpath
.project
.settings
languages
lib
public
templates
index.php
DBV.php
.htaccess
README.md
data/meta
```

Note that the `.gitignore` file is specific to git. It's mercurial equivalent is `.hgignore`. If you're using svn you can set the files or directories to ignore by using the `svn propset svn:ignore` command. The following example excludes the `bin` directory in the root of your current project from being tracked by svn:

```
svn propset svn:ignore "bin" .
```

Next you need to update the `config.php` in the root of the `dbv` directory. The only thing that you need to update here are the first two sections. Just substitute the values for `my_username`, `my_password`, `my_database` for the values in your current database configuration:

```php
<?php
/**
 * Your database authentication information goes here
 * @see http://dbv.vizuina.com/documentation/
 */
define('DB_HOST', 'localhost');
define('DB_PORT', 3306);
define('DB_USERNAME', 'my_username');
define('DB_PASSWORD', 'my_password');
define('DB_NAME', 'my_database');

/**
 * Authentication data for access to DBV itself
 * If you leave any of the two constants below blank, authentication will be disabled
 * @see http://dbv.vizuina.com/documentation/#optional-settings
 */
define('DBV_USERNAME', 'my_username');
define('DBV_PASSWORD', 'my_password');
?>
```

######DBV Workflow

Once that's done you can fire up dbv from your browser by accessing the following URL:

```
http://localhost/your_project/dbv
```

This will give you an interface similar to the following:

![dbv](/images/posts/2014-03-03-a-whirlwind-tour-of-web-developer-tools-source-control/dbv.png)

From the screenshot above you will see the tables that are in the database that you supplied in the `config.php` earlier. There's also an `In DB` field that displays whether a specific table is currently in the database and the `On disk` which displays whether the current table is saved in your filesystem. With this information you're pretty much aware whether you currently have the latest database in your local copy.

If you create a new table in the database you have to export it to disk. All the tables that are exported to disk are saved in the `data/schema` directory of your dbv installation. You can see from the screenshot below that we currently do not have the `tbl_leadinfo` table in our filesystem as displayed in the dbv interface:

![disk copy](/images/posts/2014-03-03-a-whirlwind-tour-of-web-developer-tools-source-control/dbv-disk.png)
 
After exporting the newly created table to disk you have to commit it using the version control system of your choice:

```
git add data/schema/tbl_tasks.sql
git commit -m "add tbl_task table"
```

Then you can just push it to your central repository:

```
git push
```

At this point you can just tell to your team mates that you have created a new table in the database and that you have already pushed it to the central repo. Now they can just `pull` it down to their local copy.

```
git pull
```

Next your team mate can just visit the dbv page (`http://localhost/your_project/dbv`). Your team mate will probably have a screen similar to the following:

![dbv team mate](/images/posts/2014-03-03-a-whirlwind-tour-of-web-developer-tools-source-control/dbv-teammate.png)

At this point he can just tick the checkbox next to the `tbl_tasks` table and click on the 'Push to database' button to create the `tbl_tasks` table in the database.

And that's the workflow for working with dbv. Pretty easy isn't it? But what if you need to update the current database schema? That's where revisions comes in. 

######Revisions

If you're like me and you tried updating the schema (added a new field, remove a field, updated the data type, etc.) for a specific table you might have noticed that dbv isn't aware of it by default. For those changes you need to create a revision file. You can do that by creating a new folder in the `data/revisions` directory in your dbv installation. The convention for naming the folder is making use of a number. So the first time you make a revision the folder name would be `1` and then the next time it would be `2` and so on.

Let's try creating a new field inside the `tbl_users` table and name it `email`:

```sql
ALTER TABLE `tbl_users`
ADD `email` varchar(160) COLLATE 'latin1_swedish_ci' NOT NULL
```

Next create a new file in the `data/revisions/1` directory in your dbv installation and put the query that you just executed as the contents. Name the file to `tbl_users.sql`. The convention here is using the name of the modified table as the name for the revision file.

After that you can now commit the new file into your source control:

```
git add data/revisions/1/tbl_users.sql
git commit -m "add email field to tbl_users"
```

And then push it to your central repository:

```
git push
```

Again you can inform your team mates about it. Now if they access dbv from the browser they can now see the revision. All they have to do now is to tick the checkbox beside the revision and then click on the 'Run selected revisions' button. This will commit your changes to their local database copy:

![dbv revisions](/images/posts/2014-03-03-a-whirlwind-tour-of-web-developer-tools-source-control/dbv-revisions.png)

#####Other Database Version Control Systems

- [SQL Source Control](http://www.red-gate.com/products/sql-development/sql-source-control/) -for MS SQL database
- [Liquibase](http://www.liquibase.org/) - supports many database servers (MySQL, PostgreSQL, Oracle, Sql Server)
- [Flyway](https://github.com/flyway/flyway) - for Java projects
- [Active Record Migrations](http://guides.rubyonrails.org/migrations.html) - for rails projects
- [Off-scale](http://off-scale.com/) - for MySQL database
- [Doctrine Migrations](http://www.doctrine-project.org/projects/migrations.html) - for PHP projects

###Conclusion

That's it! In this blog post you've learned some of the basics of version control systems and how you can use them in your daily development workflow. Version control systems is an invaluable tool to keep in your web development toolset. It allows you to not only keep track of the changes to your projects source code but also to easily collaborate easily with other developers in your team.

###Resources

- [7 Version Control Systems Reviewed](http://www.smashingmagazine.com/2008/09/18/the-top-7-open-source-version-control-systems/)
- [The 10 commandments of good Source control management](http://www.troyhunt.com/2011/05/10-commandments-of-good-source-control.html)
- [Version Control Concepts and Best Practices](https://homes.cs.washington.edu/~mernst/advice/version-control.html)
- [A Successful Git Branching Model](http://nvie.com/posts/a-successful-git-branching-model/)
- [Source Control How To](http://www.ericsink.com/scm/source_control.html)
- [A Visual Guide to Version Control](http://betterexplained.com/articles/a-visual-guide-to-version-control)
- [Database Versioning: the ignored aspect of version control](http://www.nimkar.net/index.php/9-release-management/3-database-versioning-the-ignored-aspect-of-version-control)