"""
    CodeTA tests
    ============

    CodeTA unit tests

"""

import os
import unittest
import psycopg2
import logging

from codeta import app, db
from codeta.conf.test import *
from codeta.models.database import Postgres

class CodetaTestCase(unittest.TestCase):

    # set up and tear down functions for tests
    def setUp(self):
        """ create tables in database for each test """
        self.app = app.test_client()
        db.init_db()

    def tearDown(self):
        """ drop all the tables and close connection """
        with app.app_context():
            db = app.db.get_db()
            cur = db.cursor()
            with app.open_resource('sql/drop_tests.sql', mode='r') as f:
                cur.execute(f.read())
            db.commit()
            cur.close()
            db.close()

    # unit test helper functions
    def register(self, username, password, password2=None,
            email=None, fname=None, lname=None):
        """ registers a test user """

        if password2 is None:
            password2 = password

        if email is None:
            email = "%s@codeta_test.com" % (username)

        if fname is None:
            fname = username

        if lname is None:
            lname = username

        return self.app.post('/join', data={
            'username': username,
            'password': password,
            'password2': password2,
            'email': email,
            'fname': fname,
            'lname': lname
            }, follow_redirects=True)

    def login(self, username, password):
        return self.app.post('/login', data=dict(
            username = username,
            password = password
            ), follow_redirects=True)

    def logout(self):
        return self.app.get('/logout', follow_redirects=True)

    # Unit tests
    def test_homepage(self):
        """
            Test the homepage for a user who has not logged in
        """
        rc = self.app.get('/')
        assert b'Welcome to Code TA' in rc.data
        assert b'Logout' not in rc.data

    def test_register(self):
        """ Test registering for a new account """
        rc = self.register(
                app.config['TEST_USER'],
                app.config['TEST_PW'])
        assert b'Login to Code TA' in rc.data

        rc = self.register(
                app.config['TEST_USER'],
                app.config['TEST_PW'])
        assert b'Sorry, that username is already taken.' in rc.data

        rc = self.register('', 'derp')
        assert b'You must enter a username.' in rc.data

        rc = self.register('derp', '')
        assert b'You must enter a password.' in rc.data

        rc = self.register('derp', 'pass', 'not same pass')
        assert b'Your passwords did not match.' in rc.data

        rc = self.register('derp', 'pass', 'pass', email='broke')
        assert b'You must enter a valid email address.' in rc.data

    def test_login_logout(self):
        self.register(
                app.config['TEST_USER'],
                app.config['TEST_PW'])

        rc = self.login(
                app.config['TEST_USER'],
                app.config['TEST_PW'])
        assert b'Logout' in rc.data

        rc = self.logout()
        assert b'You logged out.' in rc.data

        rc = self.login(
                app.config['TEST_USER'],
                'wrong password')
        assert b'Invalid username or password.' in rc.data

        rc = self.login(
                'user_doesnt_exist',
                'wrong password')
        assert b'Invalid username or password.' in rc.data


if __name__ == '__main__':
    # set config testing options
    app.config.from_pyfile('conf/test.py')

    logging.basicConfig(filename='test.log', level=logging.DEBUG)

    unittest.main()
