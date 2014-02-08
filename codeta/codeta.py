"""
    CodeTA
    ======

    A simple webapp to grade source code

"""

from flask import Flask, request, session, g, redirect, url_for, \
        abort, render_template, flash

import psycopg2

app = Flask(__name__)

# configuration options
app.config.update(dict(
    DATABASE = 'codeta',
    DEBUG = True,
    USERNAME = 'pguser',
    PASSWORD = 'default'
))

# get config options from environment vars
app.config.from_envvar('CODETA_SETTINGS', silent=True)

# helper functions
def connect_db():
    """
        Connect to the database in the app.config
        returns a connection object on success
    """
    conn = psycopg2.connect(
            dbname = app.config['DATABASE'],
            user = app.config['USERNAME'],
            password = app.config['PASSWORD']
    )

    return conn

def get_db():
    """
        Gets the current database cursor or creates one if not found
        the g object is a thread-safe storage object for database
        connections
    """
    if not hasattr(g, "pgsql_db"):
        g.pgsql_db = connect_db()
    return g.pgsql_db

def init_db():
    """
        create the database tables in teh schema if not found
    """
    with app.app_context():
        db = get_db()
        with app.open_resource('sql/init_codeta.sql', mode='r') as f:
            db.cursor().execute(f.read())
        db.commit()

@app.route("/")
def homepage():
    return render_template('home.html')


if __name__ == "__main__":
    app.run()
