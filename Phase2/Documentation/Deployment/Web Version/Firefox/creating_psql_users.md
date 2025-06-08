# Creating Database Users for PostgreSQL for our projects.

I wanted to let you know, that it is a bit of a tricky process to connect to the PostGres backend as a user that is not **postgres**.  Here are the steps that I did, to make it so I could connect as another user.


## Backend

Be sure to remote into your backend database server using SSH, and perform the following steps.

```
ssh <YourUsername>@srv1.bcirpg.com

sudo nano /etc/postgresql/13/main/pg_hba.conf
```
Ensure that the bottom section of this file looks like this example below. The main thing that we are worried about, is turning on MD5 authentication. This will allow our new user accounts to sign in, using defined passwords.

```
# Put your actual configuration here
# ----------------------------------
#
# If you want to allow non-local connections, you need to add more
# "host" records.  In that case you will also need to make PostgreSQL
# listen on a non-local interface via the listen_addresses
# configuration parameter, or via the -i or -h command line switches.




# DO NOT DISABLE!
# If you change this first entry you will need to make sure that the
# database superuser can access the database using some other method.
# Noninteractive access to all databases is required during automatic
# maintenance (custom daily cronjobs, replication, and similar tasks).
#
# Database administrative login by Unix domain socket
local   all             postgres                                peer

# TYPE  DATABASE        USER            ADDRESS                 METHOD

# "local" is for Unix domain socket connections only
local   all             all                                     md5
# IPv4 local connections:
host    all             all             127.0.0.1/32            md5
# IPv6 local connections:
host    all             all             ::1/128                 md5
# Allow replication connections from localhost, by a user with the
# replication privilege.
local   replication     all                                     peer
host    replication     all             127.0.0.1/32            md5
host    replication     all             ::1/128                 md5
```

From there we can move on to creating the user.

## Creating a new default user

Connecting to the database is impossible, without a new user. I am going to use Ernie as the example username.

Here are the commands that I ran to create a new user, that can be used by Godot's Postgres plugin.

```
sudo -u postgres createuser ernie

sudo -u postgres psql -d main

main=# 

main=# ALTER USER ernie WITH PASSWORD 'yourpassword';
```
From there you can connect to the database using the following command.
Be sure to connect using the same password that you used, when creating your "Ernie" user.

`psql -h localhost -d main -U ernie`
