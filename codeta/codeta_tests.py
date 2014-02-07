"""
    CodeTA tests
    ============

    CodeTA unit tests

"""

import os
import codeta
import unittest
import psycopg2

class CodetaTestCase(unittest.TestCase):

    # set up and tear down functions for tests
    def setUp(self):
        """ set up a test database for each test """
        # Connect to postgres database and add our database
        codeta.app.config['DATABASE'] = 'postgres'
        codeta.app.config['TESTING'] = True
        self.app = codeta.app.test_client()
        codeta.init_db()

    def tearDown(self):
        """ drop the database and close connection """
        db = codeta.get_db()
        cur = db.cursor()

        cur.execute("DROP DATABASE %s", (codeta.app.config['DATABASE']))
        cur.commit()

        cur.close()
        db.close()

    def login(self, username, password):
        return self.app.post('/login', data=dict(
            username = username,
            password = password
            ), follow_redirects=True)

    def logout(self):
        return self.app.get('/logout', follow_redirects=True)

    # Unit tests

    def test_unauth_homepage(self):
        """
            Test the homepage for a user who has not logged in
        """
        rc = self.app.get('/')
        assert b'Welcome to Code TA' in rc.data

if __name__ == '__main__':
    unittest.main()
