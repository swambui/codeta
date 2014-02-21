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
LOGCONF_PATH = '/home/scoob/github/codeta/codeta/conf/dev_logging.conf'
