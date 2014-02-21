"""
    CodeTA
    ======

    A simple webapp to grade source code

"""
import logging
import logging.config
#from logging.handlers import FileHandler

from flask import Flask, request, session, g, redirect, url_for, \
        abort, render_template, flash
from passlib.context import CryptContext
from flask.ext.login import (LoginManager, current_user, login_required,
        login_user, logout_user, UserMixin, AnonymousUserMixin, confirm_login,
        fresh_login_required)

from codeta.models.database import Postgres


app = Flask(__name__)

app.config.from_pyfile('conf/dev.py')

#app.config.from_envvar('CODETA_SETTINGS', silent=True)

# Logging
logging.config.fileConfig(app.config['LOGCONF_PATH'])

if app.config['TESTING'] == True:
    logger = logging.getLogger('codeta.logger.debug')

else:
    logger = logging.getLogger('codeta.logger.webapp')

db = Postgres(app)

# login_manager config
logger.debug('Test message')
login_manager = LoginManager()
login_manager.init_app(app)

@login_manager.user_loader
def load_user(user_id):
    return db.get_user(user_id)

# These rely on our app being intialized
from codeta.views.core import *
from codeta.models.user import User

if __name__ == "__main__":
    app.run()
