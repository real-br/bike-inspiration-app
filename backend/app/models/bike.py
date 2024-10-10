from pydantic import BaseModel, ConfigDict, Field
from typing import Optional


class ComponentBase(BaseModel):
    id: int
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

    model_config = ConfigDict(from_attributes=True)


class ImageBase(BaseModel):
    id: int
    filename: str
    filepath: str

    model_config = ConfigDict(from_attributes=True)


class AllInfo(BaseModel):
    id: int
    type: str
    year: int
    price_range: str
    components: ComponentBase
    image: ImageBase

    model_config = ConfigDict(from_attributes=True)
