import qrcode
import io
import base64
import random
import string
from datetime import datetime, timedelta
from typing import Optional
from sqlalchemy.orm import Session
from .models import User, Transaction, Payment, PartnerStation, OTPVerification
from .auth import get_password_hash, verify_password

class AuthService:
    @staticmethod
    def generate_otp() -> str:
        return ''.join(random.choices(string.digits, k=6))
    
    @staticmethod
    def send_otp(phone: str, db: Session) -> bool:
        otp_code = AuthService.generate_otp()
        expires_at = datetime.utcnow() + timedelta(minutes=5)
        
        otp_verification = OTPVerification(
            phone=phone,
            otp_code=otp_code,
            purpose="phone_verification",
            expires_at=expires_at
        )
        db.add(otp_verification)
        db.commit()
        
        print(f"OTP for {phone}: {otp_code}")
        return True
    
    @staticmethod
    def verify_otp(phone: str, otp_code: str, db: Session) -> bool:
        otp_record = db.query(OTPVerification).filter(
            OTPVerification.phone == phone,
            OTPVerification.otp_code == otp_code,
            OTPVerification.verified == False,
            OTPVerification.expires_at > datetime.utcnow()
        ).first()
        
        if otp_record:
            otp_record.verified = True
            db.commit()
            return True
        return False
    
    @staticmethod
    def create_user(phone: str, first_name: str, last_name: str, pin: str, db: Session) -> User:
        pin_hash = get_password_hash(pin)
        user = User(
            phone=phone,
            first_name=first_name,
            last_name=last_name,
            pin_hash=pin_hash
        )
        db.add(user)
        db.commit()
        db.refresh(user)
        return user
    
    @staticmethod
    def authenticate_user(phone: str, pin: str, db: Session) -> Optional[User]:
        user = db.query(User).filter(User.phone == phone).first()
        if not user or not verify_password(pin, user.pin_hash):
            return None
        return user

class TransactionService:
    @staticmethod
    def generate_qr_code(transaction_id: int, amount: float) -> str:
        qr_data = f"FAN:{transaction_id}:{amount}:{datetime.utcnow().isoformat()}"
        qr = qrcode.QRCode(version=1, box_size=10, border=5)
        qr.add_data(qr_data)
        qr.make(fit=True)
        
        img = qr.make_image(fill_color="black", back_color="white")
        buffer = io.BytesIO()
        img.save(buffer, format='PNG')
        img_str = base64.b64encode(buffer.getvalue()).decode()
        return img_str
    
    @staticmethod
    def create_advance_request(user_id: int, amount: float, station_id: Optional[int], db: Session) -> Transaction:
        qr_code = ''.join(random.choices(string.ascii_uppercase + string.digits, k=12))
        expires_at = datetime.utcnow() + timedelta(hours=24)
        
        transaction = Transaction(
            user_id=user_id,
            station_id=station_id,
            amount=amount,
            qr_code=qr_code,
            expires_at=expires_at
        )
        db.add(transaction)
        db.commit()
        db.refresh(transaction)
        return transaction
    
    @staticmethod
    def validate_qr_scan(qr_code: str, station_id: int, db: Session) -> Optional[Transaction]:
        transaction = db.query(Transaction).filter(
            Transaction.qr_code == qr_code,
            Transaction.status == "pending",
            Transaction.expires_at > datetime.utcnow()
        ).first()
        
        if transaction:
            transaction.station_id = station_id
            transaction.status = "completed"
            transaction.completed_at = datetime.utcnow()
            db.commit()
            db.refresh(transaction)
        
        return transaction

class PaymentService:
    @staticmethod
    def generate_payment_reference() -> str:
        return 'PAY_' + ''.join(random.choices(string.ascii_uppercase + string.digits, k=10))
    
    @staticmethod
    def process_payment(transaction_id: int, user_id: int, amount: float, method: str, db: Session) -> Payment:
        reference = PaymentService.generate_payment_reference()
        
        payment = Payment(
            transaction_id=transaction_id,
            user_id=user_id,
            amount=amount,
            method=method,
            reference=reference,
            status="completed",
            processed_at=datetime.utcnow()
        )
        db.add(payment)
        db.commit()
        db.refresh(payment)
        return payment

class StationService:
    @staticmethod
    def find_nearby_stations(latitude: float, longitude: float, radius_km: float, db: Session) -> list[PartnerStation]:
        stations = db.query(PartnerStation).filter(PartnerStation.status == "active").all()
        return stations[:10]
    
    @staticmethod
    def create_station(name: str, address: str, latitude: float, longitude: float, db: Session, **kwargs) -> PartnerStation:
        station = PartnerStation(
            name=name,
            address=address,
            latitude=latitude,
            longitude=longitude,
            **kwargs
        )
        db.add(station)
        db.commit()
        db.refresh(station)
        return station
