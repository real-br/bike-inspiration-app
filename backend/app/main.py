from collections.abc import AsyncGenerator
from typing import Any

from fastapi import FastAPI
from .routes import bikes, dropdown_data, auth_routes, activity, account, privacy_policy
from contextlib import asynccontextmanager
from .db import init_db
import uvicorn


@asynccontextmanager
async def lifespan(app: FastAPI) -> AsyncGenerator[Any, None]:
    await init_db()
    yield


app = FastAPI(lifespan=lifespan)

app.include_router(bikes.router)
app.include_router(dropdown_data.router)
app.include_router(auth_routes.router, prefix="/auth")
app.include_router(activity.router)
app.include_router(account.router)
app.include_router(privacy_policy.router)


@app.get("/")
def hello():
    return {"Hello": "World!"}


if __name__ == "__main__":
    uvicorn.run(app, host="10.0.2.2", port=8000)
