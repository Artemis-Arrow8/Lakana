import uuid
import enum
from sqlalchemy import Column, String, Boolean, DateTime, ForeignKey, Numeric, Enum, Text
from sqlalchemy.dialects.postgresql import UUID
from sqlalchemy.sql import func
from database import Base

class PaymentStatus(str, enum.Enum):
    PENDING = "PENDING"
    SUCCESS = "SUCCESS"
    FAILED = "FAILED"
    CANCELLED = "CANCELLED"

class PaymentProvider(str, enum.Enum):
    ORANGE_MONEY = "ORANGE_MONEY"
    MOOV_MONEY = "MOOV_MONEY"
    WAVE = "WAVE"
    SAMA = "SAMA"
    MOCK = "MOCK"

class VerificationStatus(str, enum.Enum):
    VERIFIED_SAFE = "VERIFIED_SAFE"
    SUSPECT = "SUSPECT"
    VERIFIED_SCAM = "VERIFIED_SCAM"
    UNVERIFIED = "UNVERIFIED"

# Table Utilisateur
class User(Base):
    __tablename__ = "users"

    id = Column(UUID(as_uuid=True), primary_key=True, default=uuid.uuid4)
    phone_number = Column(String(20), unique=True, nullable=False)
    email = Column(String(255), unique=True, nullable=True)
    full_name = Column(String(100), nullable=True)
    preferred_language = Column(String(5), default="fr")
    is_premium = Column(Boolean, default=False)
    premium_expires_at = Column(DateTime(timezone=True), nullable=True)
    created_at = Column(DateTime(timezone=True), server_default=func.now())
    updated_at = Column(DateTime(timezone=True), server_default=func.now(), onupdate=func.now())

# Table Transaction (Mobile Money)
class Transaction(Base):
    __tablename__ = "transactions"

    id = Column(UUID(as_uuid=True), primary_key=True, default=uuid.uuid4)
    user_id = Column(UUID(as_uuid=True), ForeignKey("users.id", ondelete="CASCADE"), nullable=False)
    reference = Column(String(100), unique=True, nullable=False)
    aggregator_reference = Column(String(100), nullable=True)
    amount = Column(Numeric(10, 2), nullable=False)
    currency = Column(String(5), default="XOF")
    provider = Column(Enum(PaymentProvider, name="payment_provider_enum"), nullable=False)
    status = Column(Enum(PaymentStatus, name="payment_status_enum"), default=PaymentStatus.PENDING)
    plan_type = Column(String(20), nullable=False)
    created_at = Column(DateTime(timezone=True), server_default=func.now())

# Table Verifications / Signalements
class Verification(Base):
    __tablename__ = "verifications"

    id = Column(UUID(as_uuid=True), primary_key=True, default=uuid.uuid4)
    title = Column(String(255), nullable=False)
    content_text = Column(Text, nullable=True)
    analyzed_url = Column(Text, nullable=True)
    status = Column(Enum(VerificationStatus, name="verification_status_enum"), default=VerificationStatus.UNVERIFIED)
    explanation = Column(Text, nullable=True)
    official_source_url = Column(Text, nullable=True)
    category = Column(String(50), nullable=True)
    created_at = Column(DateTime(timezone=True), server_default=func.now())