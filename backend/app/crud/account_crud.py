from sqlalchemy.ext.asyncio import AsyncSession
from ..models.user_db import User
from ..models.user import RegisterUser
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

    return RegisterUser.model_validate(user_info)
