from pydantic import BaseModel, EmailStr
from datetime import datetime
from typing import Optional, List

class UserBase(BaseModel):
    phone: str
    email: Optional[EmailStr] = None
    first_name: str
    last_name: str
    user_type: str = "consumer"

class UserCreate(UserBase):
    pin: str

class UserUpdate(BaseModel):
    first_name: Optional[str] = None
    last_name: Optional[str] = None
    email: Optional[EmailStr] = None
    bvn: Optional[str] = None
    nin: Optional[str] = None
    date_of_birth: Optional[datetime] = None
    address: Optional[str] = None

class User(UserBase):
    id: int
    kyc_level: int
    credit_limit: float
    status: str
    created_at: datetime
    
    class Config:
        from_attributes = True

class PhoneVerificationRequest(BaseModel):
    phone: str

class OTPVerificationRequest(BaseModel):
    phone: str
    otp_code: str

class LoginRequest(BaseModel):
    phone: str
    pin: str

class TransactionCreate(BaseModel):
    amount: float
    station_id: Optional[int] = None

class Transaction(BaseModel):
    id: int
    user_id: int
    station_id: Optional[int]
    amount: float
    qr_code: str
    status: str
    expires_at: datetime
    created_at: datetime
    completed_at: Optional[datetime]
    
    class Config:
        from_attributes = True

class PaymentCreate(BaseModel):
    transaction_id: int
    amount: float
    method: str

class Payment(BaseModel):
    id: int
    transaction_id: int
    user_id: int
    amount: float
    method: str
    reference: str
    status: str
    created_at: datetime
    processed_at: Optional[datetime]
    
    class Config:
        from_attributes = True

class PartnerStationCreate(BaseModel):
    name: str
    address: str
    latitude: float
    longitude: float
    contact_phone: Optional[str] = None
    contact_email: Optional[EmailStr] = None
    operating_hours: Optional[str] = None

class PartnerStation(BaseModel):
    id: int
    name: str
    address: str
    latitude: float
    longitude: float
    contact_phone: Optional[str]
    contact_email: Optional[str]
    operating_hours: Optional[str]
    status: str
    created_at: datetime
    
    class Config:
        from_attributes = True

class Token(BaseModel):
    access_token: str
    token_type: str
    user: User

class QRScanRequest(BaseModel):
    qr_code: str
    station_id: int
