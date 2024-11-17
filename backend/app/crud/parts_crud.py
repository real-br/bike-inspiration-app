from sqlalchemy.ext.asyncio import AsyncSession
from ..models.bike_db import BikeInfo
from ..models.bike import BikeBase
from sqlalchemy.future import select
from sqlalchemy.orm import selectinload


async def insert_bike_info(db: AsyncSession, bike_info: dict):

    info = BikeInfo(
        id=bike_info["id"],
        type=bike_info["type"],
        year=bike_info["year"],
        price_range=bike_info["pricerange"],
        image_url=bike_info["image_url"],
    )

    for field in bike_info["inputfields"]:
        if field in bike_info:
            setattr(info, field, bike_info[field])

    db.add(info)

    await db.commit()
    await db.refresh(info)

    return info


async def get_bikes_info(db: AsyncSession):

    stmt = select(BikeInfo).options(
        selectinload(BikeInfo.saved_posts), selectinload(BikeInfo.liked_posts)
    )

    result = await db.execute(stmt)

    bikes_info = result.scalars().all()

    return [BikeBase.model_validate(info) for info in bikes_info]
