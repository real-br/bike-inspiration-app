from fastapi import APIRouter, UploadFile, File, Depends
from ..crud.image_crud import (
    get_image_id,
    get_all_images_filenames,
    create_image,
)
from ..db.session import get_db
from sqlalchemy.ext.asyncio import AsyncSession
import os


router = APIRouter()


@router.get("/images/")
async def get_images_filenames(db: AsyncSession = Depends(get_db)):
    images = await get_all_images_filenames(db)
    return {"images": [image[0] for image in images]}


@router.post("/upload/")
async def upload_image(
    db: AsyncSession = Depends(get_db), file: UploadFile = File(...)
):
    upload_dir = "uploads"
    if not os.path.exists(upload_dir):
        os.makedirs(upload_dir)

    file_location = f"{upload_dir}/{file.filename}"
    with open(file_location, "wb") as f:
        f.write(await file.read())

    create_image(db, file, file_location)
    id = await get_image_id(db, file.filename)
    return {"image_id": id, "filename": file.filename}
