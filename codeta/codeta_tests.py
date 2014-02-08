"""
    CodeTA tests
    ============

    CodeTA unit tests

"""

# System imports
import os

# App imports
import codeta
from conf import test_settings

# Other
import unittest
import psycopg2
import logging

class CodetaTestCase(unittest.TestCase):

    # set up and tear down functions for tests
    def setUp(self):
        """ create tables in database for each test """
        self.app = codeta.app.test_client()
        codeta.init_db()

    def tearDown(self):
        """ drop all the tables and close connection """
        with codeta.app.app_context():
            conn = codeta.get_db()
            cur = conn.cursor()
            with codeta.app.open_resource('sql/drop_tests.sql', mode='r') as f:
                cur.execute(f.read())
            conn.commit()

        cur.close()
        conn.close()

    # Unit tests
    def test_unauth_homepage(self):
        """
            Test the homepage for a user who has not logged in
        """
        rc = self.app.get('/')
        assert b'Welcome to Code TA' in rc.data


if __name__ == '__main__':
    # set config testing options
    for setting in dir(test_settings):
        if setting.isupper():
            setting_val = getattr(test_settings, setting)
            codeta.app.config.update({
                setting: setting_val
            })

    logging.basicConfig(filename=test_settings.LOG_PATH, level=logging.DEBUG)

    unittest.main()
