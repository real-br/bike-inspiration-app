from fastapi import APIRouter, Depends
from ..crud.account_crud import get_user_info, delete_user
from ..db.session import get_db
from .protect import TokenData, get_current_user
from sqlalchemy.ext.asyncio import AsyncSession


router = APIRouter()


@router.get("/accountInfo/{user_name}")
async def get_user(
    user_name: str,
    db: AsyncSession = Depends(get_db),
    current_user: TokenData = Depends(get_current_user),
):
    info = await get_user_info(db, user_name)
    return info


@router.post("/deleteAccount/{user_name}")
async def get_user(
    user_name: str,
    db: AsyncSession = Depends(get_db),
    current_user: TokenData = Depends(get_current_user),
):
    await delete_user(db, user_name)
    return "User Deleted"
