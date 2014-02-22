"""
    Default app config for development
"""

# Core
DEBUG = True
TESTING = False

# Database
DATABASE = 'codeta'
SECRET_KEY = 'development key'
DB_USER = 'pguser'
DB_PASSWORD = 'default'

# Logging
LOGGER = 'development'
DEBUG_LOGGING = True
DEBUG_LOG_PATH = '/tmp/codeta-debug.log'
