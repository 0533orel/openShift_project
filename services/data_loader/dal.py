import os, pymysql

DB_HOST = os.getenv("DB_HOST", "mysql")
DB_PORT = int(os.getenv("DB_PORT", "3306"))
DB_NAME = os.getenv("DB_NAME", "appdb")
DB_USER = os.getenv("DB_USER", "appuser")
from .config import database_password

def get_conn():
    return pymysql.connect(
        host=DB_HOST, port=DB_PORT, user=DB_USER, password=database_password(),
        database=DB_NAME, cursorclass=pymysql.cursors.DictCursor, autocommit=True
    )

def print_data():
    with get_conn() as conn:
        with conn.cursor() as cur:
            cur.execute("SELECT id, first_name, last_name FROM data;")
            return cur.fetchall()
