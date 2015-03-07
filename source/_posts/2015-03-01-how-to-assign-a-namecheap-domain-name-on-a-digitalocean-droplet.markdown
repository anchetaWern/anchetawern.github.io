---
layout: post
title: "How to Assign a Namecheap Domain Name on a DigitalOcean Droplet"
date: 2015-03-01 16:41
comments: true
categories: quick-tip, namecheap, digital-ocean
published: false
---

In this quick tip I'll be showing you how to assign a domain name bought from namecheap into your digitalocean droplet.

First login to your namecheap account. Click on the **manage domains** menu that can be found under your username. Click on the domain name that you want to assign. On the menus on the left side, under the general section. Click on the **Domain name server setup** link. Once in that page, select the **specify custom DNS servers** option. And then enter the following:

- ns1.digitalocean.com
- ns2.digitalocean.com
- ns3.digitalocean.com

Next login to your digitalocean account and navigate to the droplet that you want to use. From your droplets main page, click on the **DNS** link. Next click on the **Add Domain** button. This shows the form for adding a new domain. Set the value of the name to the domain name that you're trying to assign and the ip address to the ip address of your droplet or just select your droplet from the dropdown.

![dns settings](/images/posts/digitalocean_namecheap/digitalocean-dns.png)

Once you've filled all that out, click on the **create domain** button.

That's it! Just wait for about 30 minutes to an hour for the settings to propagate. And once that's done, you can now access your droplet using the domain name that you assigned.