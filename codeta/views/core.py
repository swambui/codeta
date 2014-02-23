from flask import request, session, g, redirect, url_for, \
        abort, render_template, flash

from flask.ext.login import (current_user, login_required,
        login_user, logout_user, confirm_login,
        fresh_login_required)

from codeta import app, db, login_manager, logger
from codeta.forms.forms import RegistrationForm

@app.before_request
def before_request():
    g.user = current_user

# views
@app.route('/')
def homepage():
    return render_template('home.html')

@app.route('/join', methods=['GET', 'POST'])
def join():
    """ Register the user for an account """
    form = RegistrationForm(request.form)
    if request.method == 'POST' and form.validate():
        rc = app.db.register_user(
                request.form['username'],
                request.form['password'],
                request.form['email'],
                request.form['fname'],
                request.form['lname'])

        return redirect(url_for('login'))
    return render_template('join.html', form=form)

@app.route('/login', methods=['GET', 'POST'])
def login():
    error = None
    if request.method == 'POST':
        if not request.form['username']:
            error = 'Invalid username.'
        elif not request.form['password']:
            error = 'Invalid password.'
        else:
            user = app.db.auth_user(
                    request.form['username'],
                    request.form['password'])
            if user:
                login_user(user)
                logger.info('User: %s - login auth success.' % (request.form['username']))
                return redirect(url_for('homepage'))
            else:
                logger.info('User: %s - login auth failure.' % (request.form['username']))
                error = 'Invalid username or password.'

    return render_template('login.html', error=error)

@app.route('/logout')
@login_required
def logout():
    logout_user()
    return 'You logged out.'
