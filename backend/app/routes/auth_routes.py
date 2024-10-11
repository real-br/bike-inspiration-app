from fastapi import APIRouter, Depends, HTTPException, status
from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy.future import select
from fastapi.security import OAuth2PasswordBearer, OAuth2PasswordRequestForm
from jose import jwt, JWTError
from ..db.session import get_db
from ..models.user_db import User
from ..models.user import RegisterUser
from ..auth import verify_password, get_password_hash, create_access_token

from dotenv import load_dotenv
import os

load_dotenv()

SECRET_KEY = os.getenv("SECRET_KEY")
ALGORITHM = os.getenv("ALGORITHM")
ACCESS_TOKEN_EXPIRE_MINUTES = os.getenv("ACCESS_TOKEN_EXPIRE_MINUTES")

router = APIRouter()

oauth2_scheme = OAuth2PasswordBearer(tokenUrl="token")


@router.post("/register")
async def register_user(
    register_user: RegisterUser,
    db: AsyncSession = Depends(get_db),
):
    user = await db.execute(select(User).filter(User.email == register_user.email))
    result = user.scalars().one_or_none()
    if result:
        raise HTTPException(status_code=400, detail="Email already registered")
    hashed_password = get_password_hash(register_user.password)
    new_user = User(
        id=register_user.id,
        first_name=register_user.first_name,
        last_name=register_user.last_name,
        username=register_user.username,
        email=register_user.email,
        hashed_password=hashed_password,
        is_active=True,
    )
    db.add(new_user)
    await db.commit()
    await db.refresh()

    access_token = create_access_token(data={"sub": result.username})
    return {"access_token": access_token, "token_type": "bearer"}


@router.post("/token")
async def login_for_access_token(
    form_data: OAuth2PasswordRequestForm = Depends(), db: AsyncSession = Depends(get_db)
):
    user = await db.execute(select(User).filter(User.username == form_data.username))
    result = user.scalars().one_or_none()
    if not result:
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Incorrect username or password",
            headers={"WWW-Authenticate": "Bearer"},
        )

    elif not verify_password(form_data.password, result.hashed_password):
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Incorrect username or password",
            headers={"WWW-Authenticate": "Bearer"},
        )

    access_token = create_access_token(data={"sub": result.username})
    return {"access_token": access_token, "token_type": "bearer"}


@router.get("/users/me")
async def read_users_me(
    token: str = Depends(oauth2_scheme), db: AsyncSession = Depends(get_db)
):
    credentials_exception = HTTPException(
        status_code=status.HTTP_401_UNAUTHORIZED,
        detail="Could not validate credentials",
        headers={"WWW-Authenticate": "Bearer"},
    )
    try:
        payload = jwt.decode(token, SECRET_KEY, algorithms=[ALGORITHM])
        username: str = payload.get("sub")
        if username is None:
            raise credentials_exception
    except JWTError:
        raise credentials_exception
    user = await db.execute(select(User).filter(User.username == username))
    if user is None:
        raise credentials_exception
    return user
