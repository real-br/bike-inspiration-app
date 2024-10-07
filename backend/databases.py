import sqlite3


def get_db_connection():
    conn = sqlite3.connect("database.db")
    conn.row_factory = sqlite3.Row
    return conn


def create_tables():
    conn = get_db_connection()
    cursor = conn.cursor()

    # Create the images table if it doesn't exist
    cursor.execute(
        """
        CREATE TABLE IF NOT EXISTS images (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            filename TEXT,
            filepath TEXT
        )
    """
    )

    cursor.execute(
        """
        CREATE TABLE IF NOT EXISTS specs (
            id INTEGER PRIMARY KEY,
            type TEXT,
            year INTEGER,
            pricerange TEXT,
            frame TEXT,
            groupset TEXT,
            wheels TEXT,
            cassette TEXT,
            chain TEXT,
            crank TEXT,
            handlebar TEXT,
            pedals TEXT,
            saddle TEXT,       
            stem TEXT,
            tires TEXT,
            FOREIGN KEY(id) REFERENCES images(id)
        )
    """
    )

    conn.commit()
    conn.close()


# Call create_tables() when the app starts
create_tables()
