import uuid
from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session
from app.database import get_db
from app import models
from app.schemas.payment import CheckoutRequest, CheckoutResponse
from app.core.logger import logger

# Initialisation du routeur pour les paiements Mobile Money
router = APIRouter(prefix="/payments", tags=["Paiements Mobile Money"])

@router.post("/checkout", response_model=CheckoutResponse)
def initiate_payment(payload: CheckoutRequest, db: Session = Depends(get_db)):
    """
    Simule l'initiation d'un paiement Mobile Money (Orange, Moov, Wave) 
    pour basculer le compte utilisateur au statut Premium.
    """
    logger.info(f"Demande de paiement reçue pour le numéro {payload.phone_number} - Formule: {payload.plan_type}")

    try:
        # Vérification si l'utilisateur existe déjà en base
        user = db.query(models.User).filter(models.User.phone_number == payload.phone_number).first()
        if not user:
            logger.info(f"Création d'un nouvel utilisateur avec le numéro {payload.phone_number}")
            user = models.User(phone_number=payload.phone_number)
            db.add(user)
            db.commit()
            db.refresh(user)

        # Génération d'une référence de transaction unique et sécurisée
        tx_ref = f"LK-{uuid.uuid4().hex[:8].upper()}"
        amount = 1000.00 if payload.plan_type == "MONTHLY" else 10000.00

        # Enregistrement de la transaction
        new_tx = models.Transaction(
            user_id=user.id,
            reference=tx_ref,
            amount=amount,
            provider=models.PaymentProvider.MOCK,
            status=models.PaymentStatus.SUCCESS,
            plan_type=payload.plan_type
        )
        
        # Passage du compte au statut Premium
        user.is_premium = True
        db.add(new_tx)
        db.commit()

        logger.info(f"Paiement validé avec succès ! Réf: {tx_ref} | Utilisateur Premium activé.")

        return CheckoutResponse(
            success=True,
            message="[SIMULATION] Paiement validé avec succès !",
            transaction_reference=tx_ref,
            amount=amount,
            currency="XOF",
            is_premium=True
        )
    except Exception as e:
        logger.error(f"Échec du traitement du paiement pour {payload.phone_number} : {str(e)}")
        raise HTTPException(status_code=500, detail="Erreur interne lors du traitement du paiement.")