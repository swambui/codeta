"""
    CodeTA
    ======

    A simple webapp to grade source code

"""

from flask import Flask, request, session, g, redirect, url_for, \
        abort, render_template, flash

from conf import dev_settings

import psycopg2
from flask.ext.login import (LoginManager, current_user, login_required,
        login_user, logout_user, UserMixin, AnonymousUserMixin, confirm_login,
        fresh_login_required)

app = Flask(__name__)

# set configuration options
for setting in dir(dev_settings):
    if setting.isupper():
        setting_val = getattr(dev_settings, setting)
        app.config.update({
            setting: setting_val
        })

# get config options from environment vars
#app.config.from_envvar('CODETA_SETTINGS', silent=True)

# login_manager config
login_manager = LoginManager()
login_manager.init_app(app)

# helper functions
def connect_db():
    """
        Connect to the database in the app.config
        returns a connection object on success
    """
    conn = psycopg2.connect(
            dbname = app.config['DATABASE'],
            user = app.config['DB_USER'],
            password = app.config['DB_PASSWORD']
    )

    return conn

def close_db():
    """
        Closes the database at the end of the request
    """
    if hasattr(g, 'pgsql_db'):
        g.pgsql_db.close()

def get_db():
    """
        Gets the current database cursor or creates one if not found
        the g object is a thread-safe storage object for database
        connections
    """
    if not hasattr(g, "pgsql_db"):
        g.pgsql_db = connect_db()
    return g.pgsql_db

def get_user(user_id):
    """
        checks the database for a user.
        returns a User object if found, otherwise None
    """
    user_id = int(user_id)

    db = get_db()
    cur = db.cursor()
    cur.execute("SELECT * FROM Users WHERE username like (%s)", (user_id, ))
    user = db.cursor().fetchone()

    if user:
        user = dict(zip(db.cursor().description, user))
        user = User(
                int(user['user_id']),
                user['username'],
                user['password'],
                user['email'])

    return user

def get_username(username):
    """
        Checks to see if a username already exists in the db.
        returns True if username is found, otherwise False
    """

    if username:
        db = get_db()
        cur = db.cursor()
        cur.execute("SELECT username FROM Users WHERE username like (%s)", (username, ))
        user = cur.fetchone()
        cur.close()

    return user

def login_user(user):
    pass

def init_db():
    """
        create the database tables in teh schema if not found
    """
    with app.app_context():
        db = get_db()
        with app.open_resource('sql/init_codeta.sql', mode='r') as f:
            db.cursor().execute(f.read())
        db.commit()

@login_manager.user_loader
def load_user(id):
    return get_user(id)

# views
@app.route('/')
def homepage():
    return render_template('home.html')

@app.route('/join', methods=['GET', 'POST'])
def join():
    """ Register the user for an account """
    error = None
    if request.method == 'POST':
        if not request.form['username']:
            error = 'You must enter a username.'
        elif not request.form['password']:
            error = 'You must enter a password.'
        elif not request.form['email'] or '@' not in request.form['email']:
            error = 'You must enter a valid email address.'
        elif request.form['password'] != request.form['password2']:
            error = 'Your passwords did not match.'
        elif get_username(request.form['username']):
            error = 'Sorry, that username is already taken.'
        elif not error:
            db = get_db()

            sql = "INSERT INTO Users (username, password, email, first_name, last_name) \
                VALUES (%s, %s, %s, %s, %s);"
            data = (
                request.form['username'],
                request.form['password'],
                request.form['email'],
                request.form['fname'],
                request.form['lname'],
            )

            db.cursor().execute(sql, data)
            db.commit()
            flash('You successfully joined, welcome!')
            return redirect(url_for('login'))
    return render_template('join.html', error=error)

@app.route('/login', methods=['GET', 'POST'])
def login():
    # login user
    return 'You successfully joined, welcome!'

class User(UserMixin):
    def __init__(self, id, username, password, email, active=True):
        self.id = id
        self.username = username
        self.password = password
        self.email = email
        self.active = active

    def is_authenticated(self):
        return True

    def is_active(self):
        return True

    def is_anonymous(self):
        return False

    def get_id(self):
        return id

    def __repr__(self):
        return '<User %r>' % (self.username)

if __name__ == "__main__":
    app.run()
