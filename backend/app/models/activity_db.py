from sqlalchemy import Column, String, ForeignKey, DateTime
from app.db.session import Base
from sqlalchemy.orm import relationship


class SavedPosts(Base):
    __tablename__ = "saves"

    post_id = Column(String, ForeignKey("info.id"), primary_key=True)
    post_info = relationship("BikeInfo", back_populates="saved_posts", uselist=False)

    user_name = Column(String, ForeignKey("users.username"), primary_key=True)
    user = relationship("User", back_populates="saved_posts")

    saved_at = Column(DateTime)