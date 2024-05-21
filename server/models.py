from app import db


# just a dummy model
#
# can be created like this:
#
# user = User(name="foo")
# db.session.add(user)
# db.session.commit()
class User(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    name = db.Column(db.String(128))
