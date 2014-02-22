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
DB_PASSWORD = 'default'

# User
TEST_USER = 'test_instructor'
TEST_PW = 'test_password'

# Logging
LOGGER = 'testing'
DEBUG_LOGGING = True
DEBUG_LOG_PATH = '/tmp/codeta-debug.log'
