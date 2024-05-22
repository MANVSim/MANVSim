import sqlite3


class Database:
    """ Database wrapper class that provides abstractions and utility methods. """

    def __init__(self, db_path: str):
        """ Creates (a connection to) the database at the given path. """
        self.db_path = db_path
        self.connection = sqlite3.connect(db_path)
        self.cursor = self.connection.cursor()

    def __enter__(self):
        return self

    def __exit__(self, exc_type, exc_value, traceback):
        self.close()

    def close(self):
        """ Closes the current database connection and commits all uncommitted changes. """
        self.connection.commit()
        self.cursor.close()
        self.connection.close()

    def create_table(self, table_name: str, schema: tuple[str, ...]):
        """
        Creates a table (if it does not exist) with the schema given as tuple of strings.

        Example: db.create_table("example", ("id INTEGER", "name TEXT", "age INTEGER"))
        """
        self.cursor.execute(f"CREATE TABLE IF NOT EXISTS {table_name} {schema};")

    def drop_table(self, table_name: str):
        """ Drops the specified table from the database. """
        self.cursor.execute(f"DROP TABLE IF EXISTS {table_name};")

    def add(self, table_name: str, values: tuple[str, ...]):
        """
        Adds the values given as tuple to the given table.

        Example: db.add("example", ("1", "name", "69"))
        """
        self.cursor.execute(f"INSERT INTO {table_name} VALUES {values};")
        self.connection.commit()

    def execute(self, query: str) -> list[tuple]:
        """
        Executes a given query and returns a list of results.

        Example: db.execute("SELECT * FROM example;")
        """
        self.cursor.execute(query)
        return self.cursor.fetchall()
