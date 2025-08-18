from fastapi import FastAPI
import os

from services.data_loader.dal import print_data

DB_PATH = os.getenv("SQLITE_PATH", "/tmp/data.db")

app = FastAPI(title="Data Loader API (SQLite)")

@app.get("/data")
def get_data():
    return print_data()


