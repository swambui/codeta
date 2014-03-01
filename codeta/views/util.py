"""
    util.py contains utility views for server errors,
    redirects for login manager, etc
"""

from flask import request, session, g, redirect, url_for, \
        abort, render_template, flash

from flask.ext.login import (current_user, login_required,
        login_user, logout_user, confirm_login,
        fresh_login_required)

from codeta import app, db, login_manager, logger
from codeta.forms.login import LoginForm

@app.before_request
def before_request():
    """
        Set the current user =
        user in the request for
        flask-login
"""
    g.user = current_user


@login_manager.unauthorized_handler
def unauthorized():
    """
        return the login page when a user
        needs to be logged in to view a page
    """
    form = LoginForm(request.form)
    return render_template('user/login.html', form=form)

@app.errorhandler(404)
def page_not_found(error):
    """ Return a 404 error page """
    return render_template('util/404.html'), 404

@app.errorhandler(403)
def page_forbidden(error):
    """ Return a 403 error page """
    return render_template('util/403.html'), 403
