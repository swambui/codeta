from flask import g

import psycopg2
import psycopg2.extras

from codeta.models.user import User

class Postgres(object):
    """
        Provides functions to connect to the database,
        and to query various things from the db
    """

    def __init__(self, app=None):
        """
            Initialize and add to our flask app
            as app.db

        """

        app.db = self
        self.app = app

    def auth_user(self, username, password):
        """
            Authenticates a user and returns a User object
            if the correct credentials were provided
            otherwise, return None
        """
        db = self.get_db()
        cur = db.cursor(cursor_factory=psycopg2.extras.DictCursor)

        # hash the password and store it in the db
        cur.execute("SELECT * FROM Users WHERE username = (%s) \
                AND password = (%s)", (username, password, ))
        user = cur.fetchone()
        colnames = [desc[0] for desc in cur.description]

        if user:
            user = dict(zip(colnames, user))
            user = User(
                    int(user['user_id']),
                    user['username'],
                    user['password'],
                    user['email'])
        cur.close()
        return user

    def close_db(self):
        """
            Closes the database at the end of the request
        """
        if hasattr(g, 'pgsql_db'):
            g.pgsql_db.close()


    def connect_db(self):
        """
            Connect to the database in the app.config
            returns a connection object on success
        """
        conn = psycopg2.connect(
                dbname = self.app.config['DATABASE'],
                user = self.app.config['DB_USER'],
                password = self.app.config['DB_PASSWORD']
        )

        return conn

    def get_db(self):
        """
            Gets the current database cursor or creates one if not found
            the g object is a thread-safe storage object for database
            connections
        """
        if not hasattr(g, "pgsql_db"):
            g.pgsql_db = self.connect_db()
        return g.pgsql_db

    def get_user(self, user_id):
        """
            Creates a new User object from the database
            returns a User object if found, otherwise None
        """
        user_id = int(user_id)

        db = self.get_db()
        cur = db.cursor()
        cur.execute("SELECT * FROM Users WHERE user_id = (%s)", (user_id, ))
        user = cur.fetchone()
        colnames = [desc[0] for desc in cur.description]

        if user:
            user = dict(zip(colnames, user))
            user = User(
                    int(user['user_id']),
                    user['username'],
                    user['password'],
                    user['email'])

        cur.close()
        return user

    def get_username(self, username):
        """
            Checks to see if a username already exists in the db.
            returns True if username is found, otherwise False
        """

        with self.app.app_context():
            if username:
                db = self.get_db()
                cur = db.cursor()
                cur.execute("SELECT username FROM Users WHERE username like (%s)", (username, ))
                user = cur.fetchone()
                cur.close()

        return user

    def init_db(self):
        """
            create the database tables in teh schema if not found
        """
        with self.app.app_context():
            db = self.get_db()
            with self.app.open_resource('sql/init_codeta.sql', mode='r') as f:
                db.cursor().execute(f.read())
            db.commit()
