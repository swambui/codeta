"""
    CodeTA tests
    ============

    CodeTA unit tests

"""

import os
import codeta
import unittest
import psycopg2
import logging

class CodetaTestCase(unittest.TestCase):

    # set up and tear down functions for tests
    def setUp(self):
        """ create tables in database for each test """
        codeta.app.config['DATABASE'] = 'codeta_test'
        codeta.app.config['TESTING'] = True
        codeta.app.config['TEST_USER'] = 'test_instructor'
        codeta.app.config['TEST_PW'] = 'test_password'
        logging.debug('app.config = %s' % (codeta.app.config))
        self.app = codeta.app.test_client()
        logging.debug('Attempting to init_db()')
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
    # configure logging
    logging.basicConfig(filename='../../log/codeta-debug.log', filemode='w', level=logging.DEBUG)

    unittest.main()
