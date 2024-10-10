from sqlalchemy.future import select
from ..models.bike import Image
from fastapi import UploadFile
from sqlalchemy.ext.asyncio import AsyncSession


def create_image(db: AsyncSession, file: UploadFile, file_location: str):
    new_image = Image(filename=file.filename, filepath=file_location)
    db.add(new_image)
    return new_image


async def get_all_images(db: AsyncSession):
    result = await db.execute(select(Image)).all()
    return result


async def get_image_id(db: AsyncSession, filename: str):
    image = await db.execute(select(Image).filter(Image.filename == filename))

    return image.scalars().one().id if image else None


async def get_all_images_filenames(db: AsyncSession):
    image_filenames = await db.execute(select(Image.filename))
    return [filename[0] for filename in image_filenames]
