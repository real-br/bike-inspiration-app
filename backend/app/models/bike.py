from pydantic import BaseModel, ConfigDict, Field
from typing import Optional
from ..models.activity import SavedPost
from typing import List


class BikeBase(BaseModel):
    id: str
    type: str
    year: int
    price_range: str
    frame: Optional[str] = Field(None)
    groupset: Optional[str] = Field(None)
    wheels: Optional[str] = Field(None)
    cassette: Optional[str] = Field(None)
    chain: Optional[str] = Field(None)
    crank: Optional[str] = Field(None)
    handlebar: Optional[str] = Field(None)
    pedals: Optional[str] = Field(None)
    saddle: Optional[str] = Field(None)
    stem: Optional[str] = Field(None)
    tires: Optional[str] = Field(None)
    image_url: str
    saved_posts: Optional[List[SavedPost]]

    model_config = ConfigDict(from_attributes=True)


class SavedBike(BaseModel):
    id: str
    type: str
    year: int
    price_range: str
    frame: Optional[str] = Field(None)
    groupset: Optional[str] = Field(None)
    wheels: Optional[str] = Field(None)
    cassette: Optional[str] = Field(None)
    chain: Optional[str] = Field(None)
    crank: Optional[str] = Field(None)
    handlebar: Optional[str] = Field(None)
    pedals: Optional[str] = Field(None)
    saddle: Optional[str] = Field(None)
    stem: Optional[str] = Field(None)
    tires: Optional[str] = Field(None)
    image_url: str
    model_config = ConfigDict(from_attributes=True)
