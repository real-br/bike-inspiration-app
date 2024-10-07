from fastapi import FastAPI, UploadFile, File, HTTPException
from fastapi.responses import FileResponse
import csv

import os

from sqlite_utils import (
    insert_image,
    get_image_id,
    get_all_images_filenames,
    insert_bike_info,
    get_all_bikes_info,
)

app = FastAPI()

images_directory = "/Users/freetime/dev/bike_inspiration_app/backend/uploads/"


@app.get("/dropdown_data/{file_name}")
async def get_dropdown_data(file_name: str):
    data = []
    with open(f"dropdown_data/{file_name}.csv", newline="") as csvfile:
        reader = csv.DictReader(csvfile)
        for row in reader:
            data.append(row)
    return data


@app.get("/images/")
def get_images_filenames():

    images = get_all_images_filenames()
    image_list = []
    for image in images:
        image_list.append(image[0])

    return {"images": image_list}


@app.get("/image/{filename}")
async def get_image(filename: str):
    file_path = os.path.join(images_directory, filename)

    if os.path.exists(file_path):
        return FileResponse(file_path)
    else:
        raise HTTPException(status_code=404, detail="Image not found")


@app.get("/bikesInfo/")
async def get_bikes_info():
    info = get_all_bikes_info()

    json_data = [
        {
            "type": item[0],
            "year": item[1],
            "pricerange": item[2],
            "frame": item[3],
            "groupset": item[4],
            "wheels": item[5],
            "cassette": item[6],
            "chain": item[7],
            "crank": item[8],
            "handlebar": item[9],
            "pedals": item[10],
            "saddle": item[11],
            "stem": item[12],
            "tires": item[13],
            "filename": item[14],
            "filepath": item[15],
        }
        for item in info
    ]

    return json_data


@app.post("/upload/")
async def upload_image(file: UploadFile = File(...)):

    upload_dir = "uploads"
    if not os.path.exists(upload_dir):
        os.makedirs(upload_dir)

    # Save the file to the directory
    file_location = f"{upload_dir}/{file.filename}"
    with open(file_location, "wb") as f:
        f.write(await file.read())

    insert_image(file, file_location)

    id = get_image_id(file.filename)

    return {
        "image_id": id,
        "filename": file.filename,
    }


@app.post("/uploadInfo/")
async def upload_info(info: dict):

    insert_bike_info(bike_info=info)

    return {"message": "Info uploaded successfully"}
