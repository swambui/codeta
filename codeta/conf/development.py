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
LOGCONF_PATH = '/home/dsr/github/codeta/codeta/conf/logging.conf'
LOGGER = 'codeta.logger.development'
