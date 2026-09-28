import os


def database_password():
    value = os.getenv("DB_PASSWORD", "")
    if not value.strip():
        raise ValueError("DB_PASSWORD must be set")
    return value
