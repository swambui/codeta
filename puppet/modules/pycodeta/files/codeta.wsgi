import os, sys, logging
logging.basicConfig(stream=sys.stderr)

PROJECT_DIR = '/srv/www/codeta/wsgi/'
activate_this = PROJECT_DIR + 'codeta/bin/activate_this.py'
execfile(activate_this, dict(__file__=activate_this))

sys.path.append(PROJECT_DIR)

from codeta import app as application
