from fastapi import APIRouter, Depends, HTTPException, Path
from sqlalchemy.orm import Session
from typing import List
from app.database import get_db
from app import models
from app.schemas.history import VerificationHistoryItem, TransactionHistoryItem

# Initialisation du routeur pour l'historique et les données utilisateur
router = APIRouter(prefix="/history", tags=["Historique & Utilisateur"])

@router.get("/verifications", response_model=List[VerificationHistoryItem])
def get_verification_history(db: Session = Depends(get_db)):
    """
    Récupère l'historique complet de toutes les vérifications de sécurité 
    effectuées sur la plateforme Lakana.
    """
    verifications = db.query(models.Verification).order_by(models.Verification.created_at.desc()).all()
    return verifications

@router.get("/transactions/{phone_number}", response_model=List[TransactionHistoryItem])
def get_user_transactions(
    phone_number: str = Path(
        ...,
        pattern=r"^(\+223)?(50|51|52|53|54|55|60|61|62|63|64|65|66|67|70|71|72|73|74|75|76|77|78|79|82|83|89|90|91|92|93|94|95|96|97|98|99)\d{6}$",
        description="Numéro de téléphone malien valide pour filtrer les transactions"
    ),
    db: Session = Depends(get_db)
):
    """
    Récupère l'historique des transactions Mobile Money d'un utilisateur 
    spécifique en validant strictement son numéro malien.
    """
    # Recherche de l'utilisateur associé au numéro validé par la Regex
    user = db.query(models.User).filter(models.User.phone_number == phone_number).first()
    
    if not user:
        raise HTTPException(status_code=404, detail="Utilisateur introuvable.")
    
    # Récupération des transactions triées de la plus récente à la plus ancienne
    transactions = db.query(models.Transaction).filter(models.Transaction.user_id == user.id).order_by(models.Transaction.created_at.desc()).all()
    return transactions