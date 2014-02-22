"""
    Codeta config for production
"""

# Core
DEBUG = False
TESTING = False

# Database
DATABASE = 'codeta'
SECRET_KEY = 'development key'
DB_USER = 'pguser'
DB_PASSWORD = 'default'

# Logging
LOGGER = 'production'
DEBUG_LOGGING = True
DEBUG_LOG_PATH = '/srv/www/codeta/log/codeta-debug.log'
