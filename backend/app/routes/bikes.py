from fastapi import APIRouter, Depends
from ..crud.parts_crud import get_bikes_info, insert_bike_info
from ..db.session import get_db
from sqlalchemy.ext.asyncio import AsyncSession


router = APIRouter()


@router.get("/bikesInfo/")
async def get_bikes(db: AsyncSession = Depends(get_db)):
    info = await get_bikes_info(db)
    return info


@router.post("/uploadInfo/")
async def upload_info(info: dict, db: AsyncSession = Depends(get_db)):
    info, components = await insert_bike_info(db=db, bike_info=info)
    return {"message": "Info uploaded successfully"}
