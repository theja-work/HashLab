
import sqlite3

conn = sqlite3.connect("users.db")

cursor = conn.cursor()

cursor.execute("""
CREATE TABLE IF NOT EXISTS users (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    username TEXT UNIQUE NOT NULL,
    password_hash INTEGER,
    is_admin INTEGER DEFAULT 0
)
""")

conn.commit()
conn.close()

print("DB Created")
