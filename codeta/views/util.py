"""
    util.py contains utility views for server errors,
    redirects for login manager, etc
"""

from codeta import app, db, login_manager, logger

from flask import request, session, g, redirect, url_for, \
        abort, render_template, flash

from flask.ext.login import (current_user, login_required,
        login_user, logout_user, confirm_login,
        fresh_login_required)

@app.before_request
def before_request():
    g.user = current_user


@login_manager.unauthorized_handler
def unauthorized():
    return render_template('login.html')
