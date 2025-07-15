from sqlalchemy import Column, Integer, String, Float, DateTime, Boolean, Text, ForeignKey
from sqlalchemy.ext.declarative import declarative_base
from sqlalchemy.orm import relationship
from datetime import datetime

Base = declarative_base()

class User(Base):
    __tablename__ = "users"
    
    id = Column(Integer, primary_key=True, index=True)
    phone = Column(String(15), unique=True, index=True, nullable=False)
    email = Column(String(100), unique=True, index=True)
    first_name = Column(String(50), nullable=False)
    last_name = Column(String(50), nullable=False)
    bvn = Column(String(11), unique=True, index=True)
    nin = Column(String(11), unique=True, index=True)
    date_of_birth = Column(DateTime)
    address = Column(Text)
    kyc_level = Column(Integer, default=1)
    credit_limit = Column(Float, default=5000.0)
    pin_hash = Column(String(255))
    status = Column(String(20), default="active")
    user_type = Column(String(20), default="consumer")
    created_at = Column(DateTime, default=datetime.utcnow)
    updated_at = Column(DateTime, default=datetime.utcnow, onupdate=datetime.utcnow)
    
    transactions = relationship("Transaction", back_populates="user")
    payments = relationship("Payment", back_populates="user")

class PartnerStation(Base):
    __tablename__ = "partner_stations"
    
    id = Column(Integer, primary_key=True, index=True)
    name = Column(String(100), nullable=False)
    address = Column(Text, nullable=False)
    latitude = Column(Float, nullable=False)
    longitude = Column(Float, nullable=False)
    contact_phone = Column(String(15))
    contact_email = Column(String(100))
    operating_hours = Column(String(100))
    status = Column(String(20), default="active")
    created_at = Column(DateTime, default=datetime.utcnow)
    updated_at = Column(DateTime, default=datetime.utcnow, onupdate=datetime.utcnow)
    
    transactions = relationship("Transaction", back_populates="station")

class Transaction(Base):
    __tablename__ = "transactions"
    
    id = Column(Integer, primary_key=True, index=True)
    user_id = Column(Integer, ForeignKey("users.id"), nullable=False)
    station_id = Column(Integer, ForeignKey("partner_stations.id"))
    amount = Column(Float, nullable=False)
    qr_code = Column(String(255), unique=True, nullable=False)
    status = Column(String(20), default="pending")
    expires_at = Column(DateTime, nullable=False)
    created_at = Column(DateTime, default=datetime.utcnow)
    completed_at = Column(DateTime)
    
    user = relationship("User", back_populates="transactions")
    station = relationship("PartnerStation", back_populates="transactions")
    payments = relationship("Payment", back_populates="transaction")

class Payment(Base):
    __tablename__ = "payments"
    
    id = Column(Integer, primary_key=True, index=True)
    transaction_id = Column(Integer, ForeignKey("transactions.id"), nullable=False)
    user_id = Column(Integer, ForeignKey("users.id"), nullable=False)
    amount = Column(Float, nullable=False)
    method = Column(String(50), nullable=False)
    reference = Column(String(100), unique=True, nullable=False)
    status = Column(String(20), default="pending")
    processed_at = Column(DateTime)
    created_at = Column(DateTime, default=datetime.utcnow)
    
    transaction = relationship("Transaction", back_populates="payments")
    user = relationship("User", back_populates="payments")

class OTPVerification(Base):
    __tablename__ = "otp_verifications"
    
    id = Column(Integer, primary_key=True, index=True)
    phone = Column(String(15), nullable=False)
    otp_code = Column(String(6), nullable=False)
    purpose = Column(String(50), nullable=False)
    verified = Column(Boolean, default=False)
    expires_at = Column(DateTime, nullable=False)
    created_at = Column(DateTime, default=datetime.utcnow)
