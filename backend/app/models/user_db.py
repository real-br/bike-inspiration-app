from sqlalchemy import Column, String, Boolean
from sqlalchemy.orm import relationship
from ..db.session import Base


class User(Base):
    __tablename__ = "users"

    username = Column(
        String,
        primary_key=True,
        unique=True,
    )
    first_name = Column(String, nullable=False)
    last_name = Column(String, nullable=False)
    email = Column(String, unique=True, nullable=True)
    hashed_password = Column(String, nullable=False)
    is_active = Column(Boolean, default=True)

    saved_posts = relationship("SavedPosts", back_populates="user")
    liked_posts = relationship("LikedPosts", back_populates="user")
    created_posts = relationship("BikeInfo", back_populates="creator")
