from sqlalchemy.ext.asyncio import AsyncSession
from app.models.activity import SavedPost
from app.models.activity_db import SavedPosts
from app.models.bike import BikeBase
from sqlalchemy.future import select
from sqlalchemy.orm import selectinload
from datetime import datetime


async def save_post(db: AsyncSession, save_info: SavedPost):

    saved_post = SavedPosts(
        post_id=save_info.post_id,
        user_name=save_info.user_name,
        saved_at=datetime.strptime(save_info.saved_at, "%Y-%m-%d %H:%M:%S.%f"),
    )

    db.add(saved_post)

    await db.commit()
    await db.refresh(saved_post)

    return saved_post


async def unsave_post(db: AsyncSession, save_info: SavedPost):

    result = await db.execute(
        select(SavedPosts).filter_by(
            post_id=save_info.post_id,
            user_id=save_info.user_name,
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

    breakpoint()

    return [BikeBase.model_validate(post) for post in saved_posts]
