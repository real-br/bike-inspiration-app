from fastapi import APIRouter, Depends
from ..db.session import get_db

from ..crud.activity_crud import (
    save_post,
    unsave_post,
    get_saved_posts,
    like_post,
    unlike_post,
    get_nr_likes,
)
from ..routes.protect import TokenData, get_current_user
from sqlalchemy.ext.asyncio import AsyncSession
from ..models.activity import LikedPost, SavedPost

router = APIRouter()


@router.post("/savePost/")
async def save_post_db(
    post_info: SavedPost,
    db: AsyncSession = Depends(get_db),
    current_user: TokenData = Depends(get_current_user),
):
    info = await save_post(db, post_info)
    return {"message": "Info uploaded successfully"}


@router.post("/unsavePost/")
async def unsave_post_db(
    post_info: SavedPost,
    db: AsyncSession = Depends(get_db),
    current_user: TokenData = Depends(get_current_user),
):
    info = await unsave_post(db, post_info)
    return {"message": "Info uploaded successfully"}


@router.get("/savedPosts/{user_id}")
async def get_saved_posts_user(
    user_id: str,
    db: AsyncSession = Depends(get_db),
    current_user: TokenData = Depends(get_current_user),
):
    info = await get_saved_posts(db=db, user_id=user_id)
    return info


@router.post("/likePost/")
async def like_post_db(
    post_info: LikedPost,
    db: AsyncSession = Depends(get_db),
    current_user: TokenData = Depends(get_current_user),
):
    info = await like_post(db, post_info)
    return {"message": "Info uploaded successfully"}


@router.post("/unlikePost/")
async def unlike_post_db(
    post_info: LikedPost,
    db: AsyncSession = Depends(get_db),
    current_user: TokenData = Depends(get_current_user),
):
    info = await unlike_post(db, post_info)
    return {"message": "Info uploaded successfully"}


@router.get("/likedPosts/{post_id}")
async def get_nr_likes_db(
    post_id: str,
    db: AsyncSession = Depends(get_db),
    current_user: TokenData = Depends(get_current_user),
):
    info = await get_nr_likes(db=db, post_id=post_id)
    return info
