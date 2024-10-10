from ..db.session import async_engine, Base
from ..models import bike


async def init_db():
    async with async_engine.begin() as conn:
        await conn.run_sync(Base.metadata.create_all)