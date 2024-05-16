from flask_migrate import Migrate

from app import create_app, db

# create the initial app
app = create_app()

app.config["WTF_CSRF_SECRET_KEY"] = (
    "APP_DEBUG_DO_NOT_USE_IN_PROD_20556f99182444688d9bc48cc456e99031cd39c391accd9ea2e1ff1b500405358c999c50eafe8c6d8fe61a148850e658374d42592f81e411e652fb3ee6839e76"
)

# set up all needed migrations
migrate = Migrate(app, db)
