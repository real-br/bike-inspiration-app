from sqlalchemy import Column, Integer, String, ForeignKey
from ..db.session import Base
from sqlalchemy.orm import relationship


class Info(Base):
    __tablename__ = "info"

    id = Column(Integer, primary_key=True, index=True)
    type = Column(String)
    year = Column(Integer)
    price_range = Column(String)
    nr_likes = Column(Integer)

    image_id = Column(Integer, ForeignKey("images.id"), unique=True)
    components_id = Column(Integer, ForeignKey("components.id"), unique=True)

    image = relationship("Image", back_populates="info", uselist=False)
    components = relationship("Components", back_populates="info", uselist=False)


class Image(Base):
    __tablename__ = "images"

    id = Column(Integer, primary_key=True, index=True, autoincrement=True)
    filename = Column(String, unique=True, nullable=False)
    filepath = Column(String, nullable=False)

    info = relationship("Info", back_populates="image", uselist=False)


class Components(Base):
    __tablename__ = "components"

    id = Column(Integer, primary_key=True, index=True)
    frame = Column(String)
    groupset = Column(String)
    wheels = Column(String)
    cassette = Column(String)
    chain = Column(String)
    crank = Column(String)
    handlebar = Column(String)
    pedals = Column(String)
    saddle = Column(String)
    stem = Column(String)
    tires = Column(String)

    info = relationship("Info", back_populates="components", uselist=False)
