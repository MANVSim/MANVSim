from app import db


# just a dummy model
#
# can be created like this:
#
# user = User(name="foo")
# db.session.add(user)
# db.session.commit()


class Scenario(db.Model):
    id = db.Column(db.Integer, primary_key=True, autoincrement=True)
    name = db.Column(db.String(128), nullable=False)


class Execution(db.Model):
    id = db.Column(db.Integer, primary_key=True, autoincrement=True)
    scenario_id = db.Column(db.ForeignKey(Scenario.id), nullable=False)


class Location(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    name = db.Column(db.VARCHAR(255), nullable=False)
    picture_ref = db.Column(db.VARCHAR(255), nullable=False)
    location_id = db.Column(db.Integer, nullable=True)


class Role(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    name = db.Column(db.VARCHAR(255), nullable=False)
    short_name = db.Column(db.VARCHAR(255), nullable=True)
    power = db.Column(db.Integer, nullable=False)


class Player(db.Model):
    tan = db.Column(db.VARCHAR(6), primary_key=True)
    execution_id = db.Column(db.ForeignKey(Execution.id), nullable=False)
    location_id = db.Column(db.ForeignKey(Location.id), nullable=False)
    role_id = db.Column(db.ForeignKey(Role.id), nullable=False)
    alerted = db.Column(db.Boolean, nullable=False)
    activation_delay_sec = db.Column(db.Integer, nullable=False)


class Patient(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    name = db.Column(db.VARCHAR(255), nullable=False)
    injuries = db.Column(db.JSON(), nullable=False)
    activity_diagram = db.Column(db.JSON(), nullable=False)
    location = db.Column(db.ForeignKey(Location.id), nullable=True)


class TakesPartIn(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    scenario_id = db.Column(db.ForeignKey(Scenario.id), nullable=False)
    patient_id = db.Column(db.ForeignKey(Patient.id), nullable=False)


class Resource(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    name = db.Column(db.VARCHAR(255), nullable=False)
    picture_ref = db.Column(db.VARCHAR(255), nullable=False)
    quantity = db.Column(db.Integer, nullable=False)
    location_id = db.Column(db.ForeignKey(Location.id))


class Action(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    name = db.Column(db.VARCHAR(255), nullable=False)
    required_power = db.Column(db.Integer, nullable=False)
    picture_ref = db.Column(db.VARCHAR(255), nullable=False)
    results = db.Column(db.JSON(), nullable=False)
    duration_secs = db.Column(db.Integer, nullable=False)


class ResourcesNeeded(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    action_id = db.Column(db.ForeignKey(Action.id), nullable=False)
    resource_id = db.Column(db.ForeignKey(Resource.id), nullable=False)
