from fastapi import FastAPI, Depends, HTTPException, status
from fastapi.middleware.cors import CORSMiddleware
from sqlalchemy.orm import Session
from datetime import timedelta
from typing import List

from .database import get_db, create_tables
from .models import User, Transaction, Payment, PartnerStation
from .schemas import (
    UserCreate, User as UserSchema, PhoneVerificationRequest, 
    OTPVerificationRequest, LoginRequest, Token, TransactionCreate,
    Transaction as TransactionSchema, PaymentCreate, Payment as PaymentSchema,
    PartnerStationCreate, PartnerStation as PartnerStationSchema, QRScanRequest
)
from .auth import create_access_token, get_current_user, ACCESS_TOKEN_EXPIRE_MINUTES
from .services import AuthService, TransactionService, PaymentService, StationService

app = FastAPI(title="Fuel Advance Network API", version="1.0.0")

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

@app.on_event("startup")
def startup_event():
    create_tables()

@app.get("/")
def read_root():
    return {"message": "Fuel Advance Network API", "version": "1.0.0"}

@app.post("/auth/send-otp")
def send_otp(request: PhoneVerificationRequest, db: Session = Depends(get_db)):
    success = AuthService.send_otp(request.phone, db)
    if success:
        return {"message": "OTP sent successfully"}
    raise HTTPException(status_code=400, detail="Failed to send OTP")

@app.post("/auth/verify-otp")
def verify_otp(request: OTPVerificationRequest, db: Session = Depends(get_db)):
    is_valid = AuthService.verify_otp(request.phone, request.otp_code, db)
    if is_valid:
        return {"message": "OTP verified successfully", "verified": True}
    raise HTTPException(status_code=400, detail="Invalid or expired OTP")

@app.post("/auth/register", response_model=Token)
def register_user(user: UserCreate, db: Session = Depends(get_db)):
    existing_user = db.query(User).filter(User.phone == user.phone).first()
    if existing_user:
        raise HTTPException(status_code=400, detail="Phone number already registered")
    
    new_user = AuthService.create_user(
        phone=user.phone,
        first_name=user.first_name,
        last_name=user.last_name,
        pin=user.pin,
        db=db
    )
    
    access_token_expires = timedelta(minutes=ACCESS_TOKEN_EXPIRE_MINUTES)
    access_token = create_access_token(
        data={"sub": new_user.phone}, expires_delta=access_token_expires
    )
    
    return {
        "access_token": access_token,
        "token_type": "bearer",
        "user": new_user
    }

@app.post("/auth/login", response_model=Token)
def login_user(login_data: LoginRequest, db: Session = Depends(get_db)):
    user = AuthService.authenticate_user(login_data.phone, login_data.pin, db)
    if not user:
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Incorrect phone number or PIN"
        )
    
    access_token_expires = timedelta(minutes=ACCESS_TOKEN_EXPIRE_MINUTES)
    access_token = create_access_token(
        data={"sub": user.phone}, expires_delta=access_token_expires
    )
    
    return {
        "access_token": access_token,
        "token_type": "bearer",
        "user": user
    }

@app.get("/auth/me", response_model=UserSchema)
def get_current_user_info(current_user: User = Depends(get_current_user)):
    return current_user

@app.post("/transactions/create", response_model=TransactionSchema)
def create_advance_request(
    transaction_data: TransactionCreate,
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db)
):
    if transaction_data.amount > current_user.credit_limit:
        raise HTTPException(status_code=400, detail="Amount exceeds credit limit")
    
    transaction = TransactionService.create_advance_request(
        user_id=current_user.id,
        amount=transaction_data.amount,
        station_id=transaction_data.station_id,
        db=db
    )
    
    return transaction

@app.get("/transactions/my", response_model=List[TransactionSchema])
def get_user_transactions(
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db)
):
    transactions = db.query(Transaction).filter(Transaction.user_id == current_user.id).all()
    return transactions

@app.post("/transactions/scan-qr")
def scan_qr_code(
    scan_data: QRScanRequest,
    db: Session = Depends(get_db)
):
    transaction = TransactionService.validate_qr_scan(
        qr_code=scan_data.qr_code,
        station_id=scan_data.station_id,
        db=db
    )
    
    if not transaction:
        raise HTTPException(status_code=404, detail="Invalid or expired QR code")
    
    return {"message": "QR code scanned successfully", "transaction": transaction}

@app.post("/payments/create", response_model=PaymentSchema)
def create_payment(
    payment_data: PaymentCreate,
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db)
):
    transaction = db.query(Transaction).filter(
        Transaction.id == payment_data.transaction_id,
        Transaction.user_id == current_user.id
    ).first()
    
    if not transaction:
        raise HTTPException(status_code=404, detail="Transaction not found")
    
    payment = PaymentService.process_payment(
        transaction_id=payment_data.transaction_id,
        user_id=current_user.id,
        amount=payment_data.amount,
        method=payment_data.method,
        db=db
    )
    
    return payment

@app.get("/payments/my", response_model=List[PaymentSchema])
def get_user_payments(
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db)
):
    payments = db.query(Payment).filter(Payment.user_id == current_user.id).all()
    return payments

@app.get("/stations", response_model=List[PartnerStationSchema])
def get_partner_stations(db: Session = Depends(get_db)):
    stations = db.query(PartnerStation).filter(PartnerStation.status == "active").all()
    return stations

@app.post("/stations/create", response_model=PartnerStationSchema)
def create_partner_station(
    station_data: PartnerStationCreate,
    db: Session = Depends(get_db)
):
    station = StationService.create_station(
        name=station_data.name,
        address=station_data.address,
        latitude=station_data.latitude,
        longitude=station_data.longitude,
        db=db,
        contact_phone=station_data.contact_phone,
        contact_email=station_data.contact_email,
        operating_hours=station_data.operating_hours
    )
    return station

@app.get("/stations/nearby")
def get_nearby_stations(
    latitude: float,
    longitude: float,
    radius: float = 10.0,
    db: Session = Depends(get_db)
):
    stations = StationService.find_nearby_stations(latitude, longitude, radius, db)
    return stations
