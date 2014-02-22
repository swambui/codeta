CodeTA
======

A tool for automated source code grading.

Quick-start
===========
Install everything

> sudo ./deploy.sh all

Activate the python virtualenv

> source /srv/www/codeta/wsgi/codeta/bin/activate

You can now run Code TA

Running CodeTA
==============

Run unit tests

> python tests.py

Run the application locally to check it out

> python codeta.py

And then go to localhost:5000 in your browser

Or if everything is installed, go to localhost
to see the production version.


Deployment Options
==================
To bootstrap the deployment but not install everything in
case you need to switch branches on the repo before installtion.

> sudo ./deploy.sh bootstrap

Install CodeTA and everything required, installing from the repo
in /var/git/puppet/codeta

> sudo ./deploy.sh puppet

Copy over the webapp from your local repo to the local production
directories. useful for testing production changes without 
having to push to the remote repo.

> sudo ./deploy.sh webapp
