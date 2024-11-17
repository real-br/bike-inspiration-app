from pydantic import BaseModel, ConfigDict, Field
from typing import Optional, List
from .bike import SavedBike


class RegisterUser(BaseModel):
    username: str
    first_name: str
    last_name: str
    email: str
    password: str

    model_config = ConfigDict(from_attributes=True)


class UserProfile(BaseModel):
    username: str
    first_name: str
    last_name: str
    email: str
    created_posts: Optional[List[SavedBike]]

    model_config = ConfigDict(from_attributes=True)
