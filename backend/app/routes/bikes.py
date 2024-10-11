from fastapi import APIRouter, Depends
from app.crud.parts_crud import get_bikes_info, insert_bike_info
from app.db.session import get_db
from app.routes.protect import TokenData, get_current_user
from sqlalchemy.ext.asyncio import AsyncSession


router = APIRouter()


@router.get("/bikesInfo/")
async def get_bikes(
    db: AsyncSession = Depends(get_db),
    current_user: TokenData = Depends(get_current_user),
):
    info = await get_bikes_info(db)
    return info


@router.post("/uploadInfo/")
async def upload_info(
    info: dict,
    db: AsyncSession = Depends(get_db),
    current_user: TokenData = Depends(get_current_user),
):
    info = await insert_bike_info(db=db, bike_info=info)
    return {"message": "Info uploaded successfully"}
