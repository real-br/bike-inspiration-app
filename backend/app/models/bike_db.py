from sqlalchemy import Column, Integer, String, ForeignKey
from app.db.session import Base
from sqlalchemy.orm import relationship


class BikeInfo(Base):
    __tablename__ = "info"

    id = Column(String, primary_key=True, index=True)
    type = Column(String)
    year = Column(Integer)
    price_range = Column(String)
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
    image_url = Column(String)
    saved_posts = relationship("SavedPosts", back_populates="post_info")
