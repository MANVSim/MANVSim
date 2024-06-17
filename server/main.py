from flask_migrate import Migrate
from app import create_app
from app_config import csrf, db

# -- create the initial app
app = create_app(csrf=csrf, db=db)

# -- set up all needed migrations
migrate = Migrate(app, db, render_as_batch=True)
