"""
    Codeta config for production
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
LOGCONF_PATH = '/srv/www/codeta/wsgi/codeta/conf/logging.conf'
LOGGER = 'codeta.logger.production'
