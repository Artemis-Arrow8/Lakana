import enum
from sqlalchemy import Column, Integer, String, Float, Boolean, Enum, DateTime, ForeignKey
from sqlalchemy.sql import func
from app.database import Base

class PaymentProvider(str, enum.Enum):
    """Énumération des opérateurs de paiement pris en charge ou simulés."""
    ORANGE_MONEY = "ORANGE_MONEY"
    MOOV_MONEY = "MOOV_MONEY"
    WAVE = "WAVE"
    MOCK = "MOCK"

class PaymentStatus(str, enum.Enum):
    """Énumération des états possibles d'une transaction financière."""
    PENDING = "PENDING"
    SUCCESS = "SUCCESS"
    FAILED = "FAILED"

class VerificationStatus(str, enum.Enum):
    """Énumération des verdicts d'analyse de sécurité d'un contenu."""
    VERIFIED_SAFE = "VERIFIED_SAFE"
    VERIFIED_SCAM = "VERIFIED_SCAM"
    SUSPICIOUS = "SUSPICIOUS"

class User(Base):
    """Modèle ORM représentant un utilisateur de l'application Lakana."""
    __tablename__ = "users"

    id = Column(Integer, primary_key=True, index=True)
    phone_number = Column(String, unique=True, index=True, nullable=False)
    is_premium = Column(Boolean, default=False)
    created_at = Column(DateTime(timezone=True), server_default=func.now())

class Transaction(Base):
    """Modèle ORM représentant une transaction Mobile Money (abonnement Premium)."""
    __tablename__ = "transactions"

    id = Column(Integer, primary_key=True, index=True)
    user_id = Column(Integer, ForeignKey("users.id"), nullable=False)
    reference = Column(String, unique=True, index=True, nullable=False)
    amount = Column(Float, nullable=False)
    provider = Column(Enum(PaymentProvider), nullable=False)
    status = Column(Enum(PaymentStatus), default=PaymentStatus.PENDING)
    plan_type = Column(String, nullable=False)  # Type d'abonnement : "MONTHLY" ou "ANNUAL"
    created_at = Column(DateTime(timezone=True), server_default=func.now())

class Verification(Base):
    """Modèle ORM représentant l'historique des analyses de sécurité effectuées."""
    __tablename__ = "verifications"

    id = Column(Integer, primary_key=True, index=True)
    title = Column(String, nullable=False)
    content_text = Column(String, nullable=True)
    analyzed_url = Column(String, nullable=True)
    status = Column(Enum(VerificationStatus), default=VerificationStatus.VERIFIED_SAFE)
    explanation = Column(String, nullable=False)
    category = Column(String, default="ARNAQUE_FINANCIERE")
    created_at = Column(DateTime(timezone=True), server_default=func.now())

class Report(Base):
    """Modèle ORM représentant les signalements d'arnaques par les citoyens (Crowdsourcing)."""
    __tablename__ = "reports"

    id = Column(Integer, primary_key=True, index=True)
    phone_number_reported = Column(String, index=True, nullable=True)  # Numéro de l'arnaqueur signalé
    scam_url = Column(String, nullable=True)                           # Lien suspect signalé
    description = Column(String, nullable=False)                        # Description de l'arnaque par le citoyen
    category = Column(String, default="ARNAQUE_FINANCIERE")             # Catégorie (ex: Faux concours, Phishing...)
    created_at = Column(DateTime(timezone=True), server_default=func.now())