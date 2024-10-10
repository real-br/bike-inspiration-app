from sqlalchemy.ext.asyncio import AsyncSession
from ..models.bike import Info, Components, Image
from sqlalchemy.future import select


async def insert_bike_info(db: AsyncSession, bike_info: dict):
    # Create a new Spec instance
    info = Info(
        id=bike_info["id"],
        type=bike_info["type"],
        year=bike_info["year"],
        price_range=bike_info["pricerange"],
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

    return


async def get_bikes_info(db: AsyncSession):

    stmt = (
        select(Info)
        .join(Components, Info.id == Components.id)
        .join(Image, Info.image_id == Image.id)
    )

    result = await db.execute(stmt)

    bikes_info = result.scalars().all()

    return bikes_info
