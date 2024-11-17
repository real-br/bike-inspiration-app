from sqlalchemy.ext.asyncio import AsyncSession
from ..models.user_db import User
from ..models.user import UserProfile
from sqlalchemy.future import select
from sqlalchemy.orm import selectinload


async def get_user_info(db: AsyncSession, user_name: str):

    stmt = (
        select(User)
        .filter_by(username=user_name)
        .options(
            selectinload(User.created_posts),
        )
    )

    result = await db.execute(stmt)

    user_info = result.scalars().one()

    return UserProfile.model_validate(user_info)


async def delete_user(db: AsyncSession, user_name: str):

    result = await db.execute(
        select(User).filter_by(
            username=user_name,
        )
    )

    user_to_delete = result.scalar_one_or_none()

    await db.delete(user_to_delete)
    await db.commit()

    return {"message": "User deleted succesfully"}
