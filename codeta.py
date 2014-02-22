import os
os.environ['CODETA_MODE'] = 'development'

from codeta import app
app.run()
