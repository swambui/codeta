"""
    Default config options for automated tests
"""

# Core
DEBUG = True
TESTING = True

# Database
DATABASE = 'codeta_test'
SECRET_KEY = 'test key'
DB_USER = 'pguser'
DB_PASS = 'default'


# User
TEST_USER = 'test_instructor'
TEST_PW = 'test_password'

# Logging
LOG_PATH = '../../log/codeta-test.log'
