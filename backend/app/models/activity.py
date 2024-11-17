from pydantic import BaseModel, ConfigDict
from datetime import datetime
from typing import Optional


class SavedPost(BaseModel):
    post_id: str
    user_name: str
    saved_at: Optional[datetime]

    model_config = ConfigDict(from_attributes=True)


class LikedPost(BaseModel):
    post_id: str
    user_name: str
    liked_at: Optional[datetime]

    model_config = ConfigDict(from_attributes=True)
