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

CREATE TABLE IF NOT EXISTS "auth_user" (
	"id" INTEGER NOT NULL UNIQUE,
	"username" TEXT NOT NULL UNIQUE,
	"password" TEXT NOT NULL,
	"email" TEXT NOT NULL,
	"is_superuser" INTEGER NOT NULL DEFAULT false,
	"first_name" TEXT NOT NULL,
	"last_name" TEXT NOT NULL,
	"is_staff" INTEGER NOT NULL DEFAULT false,
	"is_active" INTEGER NOT NULL DEFAULT true,
	"date_joined" TEXT NOT NULL,
	"last_login" TEXT,
	PRIMARY KEY("id")	
);

CREATE TABLE IF NOT EXISTS "auth_group" (
	"id" INTEGER NOT NULL UNIQUE,
	"name" TEXT NOT NULL UNIQUE,
	PRIMARY KEY("id")	
);

CREATE TABLE IF NOT EXISTS "auth_user_groups" (
	"id" INTEGER NOT NULL UNIQUE,
	"user_id" INTEGER NOT NULL,
	"auth_group" INTEGER NOT NULL,
	PRIMARY KEY("id"),
	FOREIGN KEY ("user_id") REFERENCES "auth_user"("id")
	ON UPDATE NO ACTION ON DELETE NO ACTION
);
