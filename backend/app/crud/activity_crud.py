from sqlalchemy.ext.asyncio import AsyncSession
from ..models.activity import SavedPost, LikedPost
from ..models.activity_db import SavedPosts, LikedPosts
from ..models.bike import SavedBike
from sqlalchemy.future import select
from sqlalchemy import func
from sqlalchemy.orm import selectinload


async def save_post(db: AsyncSession, save_info: SavedPost):

    saved_post = SavedPosts(
        post_id=save_info.post_id,
        user_name=save_info.user_name,
        saved_at=save_info.saved_at,
    )

    db.add(saved_post)

    await db.commit()
    await db.refresh(saved_post)

    return saved_post


async def unsave_post(db: AsyncSession, save_info: SavedPost):

    result = await db.execute(
        select(SavedPosts).filter_by(
            post_id=save_info.post_id,
            user_name=save_info.user_name,
        )
    )

    unsaved_post = result.scalar_one_or_none()

    await db.delete(unsaved_post)
    await db.commit()

    return {"message": "Post unsaved successfully"}


async def get_saved_posts(db: AsyncSession, user_id: str):

    result = await db.execute(
        select(SavedPosts)
        .filter(SavedPosts.user_name == user_id)
        .options(selectinload(SavedPosts.post_info))
    )

    saved_posts = result.scalars().all()

    return [SavedBike.model_validate(post.post_info) for post in saved_posts]


async def like_post(db: AsyncSession, like_info: LikedPost):

    liked_post = LikedPosts(
        post_id=like_info.post_id,
        user_name=like_info.user_name,
        liked_at=like_info.liked_at,
    )

    db.add(liked_post)

    await db.commit()
    await db.refresh(liked_post)

    return liked_post


async def unlike_post(db: AsyncSession, like_info: LikedPost):

    result = await db.execute(
        select(LikedPosts).filter_by(
            post_id=like_info.post_id,
            user_name=like_info.user_name,
        )
    )

    unliked_post = result.scalar_one_or_none()

    await db.delete(unliked_post)
    await db.commit()

    return {"message": "Post unliked successfully"}


async def get_nr_likes(db: AsyncSession, post_id: str):

    stmt = (
        select(func.count(LikedPosts.post_id))
        .where(LikedPosts.post_id == post_id)
        .group_by(LikedPosts.post_id)
    )
    result = await db.execute(stmt)
    nr_likes = result.scalar()
    return nr_likes
