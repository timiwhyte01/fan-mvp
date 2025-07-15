import sys
import os
sys.path.append(os.path.join(os.path.dirname(__file__), 'fan_backend'))

from fan_backend.app.database import SessionLocal, create_tables
from fan_backend.app.models import PartnerStation

def seed_partner_stations():
    create_tables()
    db = SessionLocal()
    
    try:
        existing_stations = db.query(PartnerStation).count()
        if existing_stations > 0:
            print("Partner stations already exist, skipping seed.")
            return
        
        stations = [
            PartnerStation(
                name="Total Filling Station - Victoria Island",
                address="123 Ahmadu Bello Way, Victoria Island, Lagos",
                latitude=6.4281,
                longitude=3.4219,
                contact_phone="+2348012345678",
                operating_hours="24 Hours",
                status="active"
            ),
            PartnerStation(
                name="Mobil Filling Station - Ikoyi",
                address="45 Kingsway Road, Ikoyi, Lagos",
                latitude=6.4474,
                longitude=3.4553,
                contact_phone="+2348023456789",
                operating_hours="6:00 AM - 10:00 PM",
                status="active"
            ),
            PartnerStation(
                name="Oando Filling Station - Lekki",
                address="78 Lekki-Epe Expressway, Lekki, Lagos",
                latitude=6.4698,
                longitude=3.5852,
                contact_phone="+2348034567890",
                operating_hours="24 Hours",
                status="active"
            ),
            PartnerStation(
                name="Conoil Filling Station - Surulere",
                address="12 Adeniran Ogunsanya Street, Surulere, Lagos",
                latitude=6.5027,
                longitude=3.3588,
                contact_phone="+2348045678901",
                operating_hours="5:00 AM - 11:00 PM",
                status="active"
            ),
            PartnerStation(
                name="NNPC Mega Station - Ikeja",
                address="56 Obafemi Awolowo Way, Ikeja, Lagos",
                latitude=6.6018,
                longitude=3.3515,
                contact_phone="+2348056789012",
                operating_hours="24 Hours",
                status="active"
            )
        ]
        
        for station in stations:
            db.add(station)
        
        db.commit()
        print(f"Successfully seeded {len(stations)} partner stations.")
        
    except Exception as e:
        print(f"Error seeding data: {e}")
        db.rollback()
    finally:
        db.close()

if __name__ == "__main__":
    seed_partner_stations()
