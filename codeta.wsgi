import os, sys, logging
logging.basicConfig(stream=sys.stderr)

PROJECT_DIR = '/srv/www/codeta/wsgi/codeta'

sys.path.append(PROJECT_DIR)

from codeta import app as application
