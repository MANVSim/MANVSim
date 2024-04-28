CREATE TABLE IF NOT EXISTS scenario (
	id INTEGER NOT NULL UNIQUE,
	name TEXT,
	PRIMARY KEY(id)	
);

INSERT INTO scenario ( 
    id", "name 
) VALUES 
( 0, "Bus Crash" ),
( 1, "Train Crash" );

CREATE TABLE IF NOT EXISTS execution (
	tan TEXT NOT NULL UNIQUE,
	scenario_id INTEGER NOT NULL REFERENCES scenario(id),
	start TEXT,
	PRIMARY KEY(tan),
);

INSERT INTO execution (
    tan, scenario_id, start
) VALUES 
( "XYZ123", 0, "1714314018" )
( "ABC456", 1, "1719577218" );

CREATE TABLE IF NOT EXISTS player (
	tan TEXT NOT NULL UNIQUE,
	execution_id TEXT NOT NULL REFERENCES execution(tan),
	PRIMARY KEY(tan),
);

INSERT INTO player (
    tan, execution_id
) VALUES 
( "QWERTZ", "XYZ123" ),
( "WASD42", "XYZ123" ),
( "1337OP", "ABC456" );

CREATE TABLE IF NOT EXISTS patients (
	id INTEGER NOT NULL UNIQUE,
	injuries BLOB,
	activity_diagram BLOB,
	PRIMARY KEY(id)	
);

CREATE TABLE IF NOT EXISTS takes_part_in (
	id INTEGER NOT NULL UNIQUE,
	scenario_id INTEGER NOT NULL REFERENCES scenario(id),
	patient_id INTEGER NOT NULL REFERENCES patients(id),
	PRIMARY KEY(id),
);

CREATE TABLE IF NOT EXISTS action (
	id INTEGER NOT NULL UNIQUE,
	name TEXT,
	picture BLOB,
	results BLOB,
	time TEXT,
	PRIMARY KEY(id)	
);

CREATE TABLE IF NOT EXISTS performed_actions (
	id INTEGER NOT NULL UNIQUE,
	time TEXT,
	execution_id TEXT NOT NULL REFERENCES execution(tan),
	patient_id INTEGER NOT NULL REFERENCES patients(id),
	action_id INTEGER NOT NULL REFERENCES action(id),
	PRIMARY KEY(id),
);
