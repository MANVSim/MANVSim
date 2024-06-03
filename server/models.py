from app import db


# just a dummy model
#
# can be created like this:
#
# user = User(name="foo")
# db.session.add(user)
# db.session.commit()


class Scenario(db.Model):
    id = db.Column(db.Integer, primary_key=True, nullable=False)
    name = db.Column(db.String(128), nullable=False)


class Execution(db.Model):
    tan = db.Column(db.VARCHAR(255), primary_key=True, nullable=False)
    scenario_id = db.Column(db.ForeignKey(Scenario.id), nullable=False)


class Location(db.Model):
    id = db.Column(db.Integer, primary_key=True, nullable=False)
    name = db.Column(db.VARCHAR(255), nullable=False)
    location_id = db.Column(db.Integer, nullable=True)


class Player(db.Model):
    tan = db.Column(db.VARCHAR(6), primary_key=True, nullable=False)
    execution_id = db.Column(db.ForeignKey(Execution.tan), nullable=False)
    location_id = db.Column(db.ForeignKey(Location.id), nullable=False)


class Patient(db.Model):
    id = db.Column(db.Integer, primary_key=True, nullable=False)
    injuries = db.Column(db.JSON(), nullable=False)
    activity_diagram = db.Column(db.JSON(), nullable=False)
    location = db.Column(db.ForeignKey(Location.id), nullable=False)


class TakesPartIn(db.Model):
    id = db.Column(db.Integer, primary_key=True, nullable=False)
    scenario_id = db.Column(db.ForeignKey(Scenario.id), nullable=False)
    patient_id = db.Column(db.ForeignKey(Patient.id), nullable=False)


class Ressource(db.Model):
    id = db.Column(db.Integer, primary_key=True, nullable=False)
    name = db.Column(db.VARCHAR(255), nullable=False)
    location = db.Column(db.ForeignKey(Location.id))


class Action(db.Model):
    id = db.Column(db.Integer, primary_key=True, nullable=False)
    name = db.Column(db.VARCHAR(255), nullable=False)
    picture_ref = db.Column(db.VARCHAR(255), nullable=False)
    results = db.Column(db.JSON(), nullable=False)
    duration_secs = db.Column(db.Integer, nullable=False)


class RessourcesNeeded(db.Model):
    id = db.Column(db.Integer, primary_key=True, nullable=False)
    action_id = db.Column(db.ForeignKey(Action.id), nullable=False)
    ressource_id = db.Column(db.ForeignKey(Ressource.id), nullable=False)
