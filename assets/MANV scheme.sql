CREATE TABLE IF NOT EXISTS "scenario" (
	"id" INTEGER NOT NULL UNIQUE,
	"name" TEXT,
	PRIMARY KEY("id")	
);

CREATE TABLE IF NOT EXISTS "execution" (
	"tan" TEXT NOT NULL UNIQUE,
	"scenario_id" INTEGER,
	"start" TEXT,
	PRIMARY KEY("tan"),
	FOREIGN KEY ("scenario_id") REFERENCES "scenario"("id")
	ON UPDATE NO ACTION ON DELETE NO ACTION
);

CREATE TABLE IF NOT EXISTS "player" (
	"tan" TEXT NOT NULL UNIQUE,
	"execution_id" TEXT,
	PRIMARY KEY("tan"),
	FOREIGN KEY ("execution_id") REFERENCES "execution"("tan")
	ON UPDATE NO ACTION ON DELETE NO ACTION
);

CREATE TABLE IF NOT EXISTS "patients" (
	"id" INTEGER NOT NULL UNIQUE,
	"injuries" BLOB,
	"activity_diagram" BLOB,
	PRIMARY KEY("id")	
);

CREATE TABLE IF NOT EXISTS "takes_part_in" (
	"id" INTEGER NOT NULL UNIQUE,
	"scenario_id" INTEGER,
	"patient_id" INTEGER,
	PRIMARY KEY("id"),
	FOREIGN KEY ("scenario_id") REFERENCES "scenario"("id")
	ON UPDATE NO ACTION ON DELETE NO ACTION
);

CREATE TABLE IF NOT EXISTS "action" (
	"id" INTEGER NOT NULL UNIQUE,
	"name" TEXT,
	"picture" BLOB,
	"results" BLOB,
	"time" TEXT,
	PRIMARY KEY("id")	
);

CREATE TABLE IF NOT EXISTS "performed_actions" (
	"id" INTEGER NOT NULL UNIQUE,
	"time" TEXT,
	"execution_id" TEXT,
	"patient_id" INTEGER,
	"action_id" INTEGER,
	PRIMARY KEY("id"),
	FOREIGN KEY ("execution_id") REFERENCES "execution"("tan")
	ON UPDATE NO ACTION ON DELETE NO ACTION
);
