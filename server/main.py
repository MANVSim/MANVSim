from flask_migrate import Migrate

from app import create_app, db

# create the initial app
app = create_app()

# set up all needed migrations
migrate = Migrate(app, db)
