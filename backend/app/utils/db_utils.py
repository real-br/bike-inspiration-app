import sqlite3
from fastapi import UploadFile

DB_PATH = "database.db"


def insert_image(file: UploadFile, file_location):
    conn = sqlite3.connect(DB_PATH)
    cursor = conn.cursor()
    cursor.execute(
        "INSERT INTO images (filename, filepath) VALUES (?, ?)",
        (file.filename, file_location),
    )

    conn.commit()
    conn.close()


def insert_bike_info(bike_info: dict):
    conn = sqlite3.connect(DB_PATH)
    cursor = conn.cursor()

    inputfields = [
        "id",
        "type",
        "year",
        "pricerange",
    ] + bike_info["inputfields"]

    columns = f"({', '.join(inputfields)})"
    placeholders = "(" + ", ".join(["?"] * (len(inputfields))) + ")"

    cursor.execute(
        """INSERT INTO specs 
            {columns} VALUES {placeholders}""".format(
            columns=columns,
            placeholders=placeholders,
        ),
        (
            bike_info["id"],
            bike_info["type"],
            bike_info["year"],
            bike_info["pricerange"],
            *[bike_info[field] for field in bike_info["inputfields"]],
        ),
    )

    conn.commit()
    conn.close()


def get_image_id(filename):
    conn = sqlite3.connect(DB_PATH)
    cursor = conn.cursor()

    cursor.execute(
        "SELECT id FROM images WHERE filename='{filename}'".format(filename=filename)
    )

    id = cursor.fetchone()[0]
    conn.close()

    return id


def get_all_images_filenames():
    conn = sqlite3.connect(DB_PATH)
    cursor = conn.cursor()

    cursor.execute("SELECT filename FROM images")
    image = cursor.fetchall()

    conn.close()

    return image


def get_all_bikes_info():
    conn = sqlite3.connect(DB_PATH)
    cursor = conn.cursor()

    cursor.execute(
        """SELECT type,
                year,
                pricerange,
                frame,
                groupset,
                wheels,
                cassette,
                chain,
                crank,
                handlebar,
                pedals,
                saddle,
                stem,
                tires,
                filename,
                filepath 
            FROM images 
            INNER JOIN specs on specs.id = images.id"""
    )
    info = cursor.fetchall()

    conn.close()

    return info


if __name__ == "__main__":
    get_all_bikes_info()
