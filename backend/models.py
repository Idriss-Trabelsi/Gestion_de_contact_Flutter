from sqlalchemy import Column, Integer, String, ForeignKey
from sqlalchemy.orm import relationship
from database import Base

class User(Base):
    __tablename__ = "users"

    id = Column(Integer, primary_key=True, index=True)
    username = Column(String, unique=True, index=True) 
    password = Column(String)
    email = Column(String, unique=True)

    contacts = relationship("Contact", back_populates="owner")

class Contact(Base):
    __tablename__ = "contacts"

    id = Column(Integer, primary_key=True, index=True)
    name = Column(String, index=True)
    phone = Column(String , index=True)
    email = Column(String, nullable=True)
    address = Column(String, nullable=True)
    
    # CHANGE: Link to username instead of id
    owner_username = Column(String, ForeignKey("users.username"))
    
    owner = relationship("User", back_populates="contacts")