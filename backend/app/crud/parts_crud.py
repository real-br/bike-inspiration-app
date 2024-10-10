from sqlalchemy.ext.asyncio import AsyncSession
from ..models.bike_db import Info, Components
from ..models.bike import AllInfo
from sqlalchemy.future import select
from sqlalchemy.orm import selectinload


async def insert_bike_info(db: AsyncSession, bike_info: dict):

    info = Info(
        id=bike_info["id"],
        type=bike_info["type"],
        year=bike_info["year"],
        price_range=bike_info["pricerange"],
        image_id=bike_info["id"],
        components_id=bike_info["id"],
    )

    components = Components(id=bike_info["id"])
    for field in bike_info["inputfields"]:
        if field in bike_info:
            setattr(components, field, bike_info[field])

    db.add(info)
    db.add(components)

    await db.commit()
    await db.refresh(info)
    await db.refresh(components)

    return info, components


async def get_bikes_info(db: AsyncSession):

    stmt = select(Info).options(selectinload(Info.components), selectinload(Info.image))

    result = await db.execute(stmt)

    bikes_info = result.scalars().all()

    return [AllInfo.model_validate(info) for info in bikes_info]
