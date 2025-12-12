import psycopg2
from psycopg2.extras import RealDictCursor


class DatabaseConnection:
    _instance = None

    def __new__(cls):
        if cls._instance is None:
            cls._instance = super().__new__(cls)
            cls._instance._connect()
        return cls._instance

    def _connect(self):
        self.connection = psycopg2.connect(
            host="localhost",
            database="my_shop",
            user="postgres",
            password="postgres",
            cursor_factory=RealDictCursor
        )

    def get_cursor(self):
        return self.connection.cursor()

    def commit(self):
        self.connection.commit()

    def close(self):
        if self.connection:
            self.connection.close()

    def __del__(self):
        self.close()


def get_connection():
    return DatabaseConnection()