from pydantic import BaseModel, ConfigDict


class SavedPost(BaseModel):
    post_id: str
    user_name: str
    saved_at: str

    model_config = ConfigDict(from_attributes=True)
