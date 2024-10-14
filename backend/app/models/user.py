from pydantic import BaseModel, ConfigDict, Field
from typing import Optional


class RegisterUser(BaseModel):
    username: str
    first_name: str
    last_name: str
    email: str
    password: str

    model_config = ConfigDict(from_attributes=True)
