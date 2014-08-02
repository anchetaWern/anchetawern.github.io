---
layout: post
title: "Setting Up SSL on Apache"
date: 2014-07-24 17:43
comments: true
categories: [apache, ssl, https]
published: true
---

In this blog post I'll walk you through setting up SSL on Apache. 
When talking about SSL the popular choice is OpenSSL, an open source toolkit for implementing Secure Sockets Layer (SSL) and Transport Layer Security (TLS). So we will be using OpenSSL for this tutorial. 


###Install OpenSSL

The first thing that you need to do is to determine the latest version of OpenSSL from the [sources page](http://www.openssl.org/source/). Its usually the one that has a red color. Once you find that, copy its address then use `wget` to download it to your preferred directory:

```
wget http://www.openssl.org/source/openssl-1.0.1h.tar.gz
```

Next create the directory where you want to install openssl:

```
mkdir /usr/local/openssl
```

Extract the archive:

```
tar -xvzf openssl-1.0.1h.tar.gz
```

Then `cd` into it:

```
cd openssl-1.0.1h
```

Next execute the `config` command to set the installation path for openssl and check for any errors. This should be the same as the directory you created earlier:

```
./config --prefix=/usr/local/openssl --openssldir=/usr/local/openssl
```

Next execute `make` to compile the source code. If this doesn't work for you try adding `sudo` before the actual command.
After `make` is done and there aren't any errors you can now execute `make install` to install the source files in there appropriate directories.

Once that's done you can verify that openssl is successfully installed by executing the following command:

```
/usr/local/openssl/bin/openssl version
```

###Generate Keys

Once you're done with installing openssl you can now assign it to a variable:

```
export OpenSSL_HOME=/usr/local/openssl
```

And then add it to your system path:

```
export PATH=$PATH:$OpenSSL_HOME/bin
```

Next create a private key:

```
openssl genrsa 2048 > privatekey.pem
```

In the above command `genrsa 2048` tells openssl to generate an RSA key that is 2048 bits long. [RSA](http://en.wikipedia.org/wiki/RSA_%28cryptosystem%29) is basically just an algorithm used for encryption.

Next create a CSR (Certificate Signing Request) using the private key that we have just generated:

```
openssl req -new -key privatekey.pem -out csr.pem
```

The command above will ask for the following:

- **Country Name** - use the 2 letter abbreviation of your country name
- **State or Province** - (e.g California) 
- **Locality Name** - (e.g Palm Desert)
- **Organization Name** - name of your company
- **Organization Unit** - name of website
- **Common Name** - domain name of website (e.g mywebsite.com)
- **Email Address** - your email address

The information above will be used for the certificate that will be assigned to you later on so be sure to supply the correct information.


###Enable SSL on Apache

Now that we have generated all the keys we need we can now configure apache to use those keys. First you have to enable the SSL module by executing the following command:

```
sudo a2enmod ssl
```

Then restart apache for changes to take effect:

```
sudo service apache2 restart
```

Next edit the ssl configuration file for apache:

```
sudo nano /etc/apache2/sites-available/default-ssl.conf
```

Comment out the following lines by adding a pound (#) sign before them:

```
SSLCertificateFile /etc/ssl/certs/ssl-cert-snakeoil.pem
SSLCertificateKeyFile /etc/ssl/private/ssl-cert-snakeoil.key
```

Next look for the following line:

```
<VirtualHost _default_:443>
```

And then under it set the server information:

```
ServerAdmin admin@mywebsite.com
ServerName mywebsite.com
ServerAlias www.mywebsite.com
DocumentRoot /home/www
```

Next look for `SSLEngine On` and then under it add the following:

```
SSLCertificateFile /home/wern/signed-certificate.crt 
SSLCertificateKeyFile /home/wern/privatekey.pem 
```

The `SSLCertificateFile` is where you specify the path to your websites digital certificate. I didn't cover this step because there are a lot of certificate authorities out there. So far I've only tried with Namecheap and its pretty easy to acquire a certificate from them. Just create an account and then log in to it. Once you're logged in just click on the security menu then select SSL certificates. From there just click on the button under the domain validation, add your preferred certificate to the cart and then just go through the steps. Once you have purchased a certificate just hover over your user name on the upper left side of the screen and then select manage ssl certificates. That will bring you to the page where all your certificates are listed. By default its just sitting there waiting to be configured. So all you have to do is configure it then select `Apache + OpenSSL` when it asks for your server configuration. And then it will ask for the csr. Just copy the contents of the `csr.pem` file that we generated earlier and paste it on the textarea which is asking for it. After that just click on submit and go through the steps provided by namecheap. Once everything is ok namecheap will send you the certificate via email. Just copy it and then save it on your server. The path to that file is what you need to assign to the `SSLCertificateFile` in apache. 
Next is the `SSLCertificateKeyFile` that's the path to your private key. In our case its the `privatekey.pem` file. 

Once that's done you just have to enable it:

```
sudo a2ensite default-ssl.conf
```

And then restart apache so that the changes will take effect:

```
sudo service apache2 restart
```

That's it! Enjoy your new https enabled website. The next step would be to redirect all http request to https but I'll leave that one to you.