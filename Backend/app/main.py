import uuid
from fastapi import FastAPI, Depends, HTTPException, status
from sqlalchemy.orm import Session
from pydantic import BaseModel
from database import get_db
import models

# ==========================================
# 1. INITIALISATION DE L'APPLICATION FASTAPI
# ==========================================
app = FastAPI(
    title="Lakana Security API",
    description="API de protection numérique et gestion des abonnements Mobile Money pour le Mali",
    version="1.0.0"
)

# Mode Simulation activé pour le concours (permet de valider les paiements instantanément)
USE_MOCK_PAYMENT = True


# ==========================================
# 2. SCHÉMAS DE VALIDATION (Pydantic)
# Ces classes définissent la structure des données 
# que l'application mobile (Flutter) doit envoyer à l'API.
# ==========================================

class CheckoutRequest(BaseModel):
    phone_number: str  # Numéro de téléphone de l'utilisateur (ex: +223...)
    provider: str      # Opérateur Mobile Money (ORANGE_MONEY, MOOV_MONEY, WAVE)
    plan_type: str     # Type d'abonnement (MONTHLY ou ANNUAL)

class VerificationRequest(BaseModel):
    title: str                    # Titre ou sujet du signalement
    content_text: str | None = None  # Le texte suspect reçu (ex: message WhatsApp)
    analyzed_url: str | None = None  # Un lien suspect à analyser (optionnel)
    category: str | None = "ARNAQUE_FINANCIERE" # Catégorie de la fraude


# ==========================================
# 3. ROUTES DE BASE ET TEST DE SANTÉ
# ==========================================

@app.get("/")
def read_root():
    """Route racine pour vérifier si l'API est en ligne."""
    return {
        "status": "online", 
        "app": "Lakana API", 
        "message": "Bienvenue sur l'API de Lakana, prête à sécuriser le Mali !"
    }


# ==========================================
# 4. GESTION DES PAIEMENTS MOBILE MONEY
# ==========================================

@app.post("/api/v1/payments/checkout")
def initiate_payment(payload: CheckoutRequest, db: Session = Depends(get_db)):
    """
    Initie un paiement Mobile Money pour passer en version Premium.
    En mode simulation (concours), la transaction est validée instantanément.
    """
    
    # Étape 1 : Vérifier si l'utilisateur existe déjà dans PostgreSQL via son numéro
    user = db.query(models.User).filter(models.User.phone_number == payload.phone_number).first()
    
    # Si l'utilisateur n'existe pas, on le crée automatiquement
    if not user:
        user = models.User(phone_number=payload.phone_number)
        db.add(user)
        db.commit()
        db.refresh(user)

    # Étape 2 : Générer une référence de transaction unique (ex: LK-AB12CD34)
    tx_ref = f"LK-{uuid.uuid4().hex[:8].upper()}"
    
    # Définir le montant selon l'abonnement (1000 FCFA pour un mois, 10000 FCFA pour un an)
    amount = 1000.00 if payload.plan_type == "MONTHLY" else 10000.00 

    # Étape 3 : Mode Simulation (Idéal pour rassurer le jury lors de la démo)
    if USE_MOCK_PAYMENT:
        new_tx = models.Transaction(
            user_id=user.id,
            reference=tx_ref,
            amount=amount,
            provider=models.PaymentProvider.MOCK,
            status=models.PaymentStatus.SUCCESS,
            plan_type=payload.plan_type
        )
        
        # Mettre à jour le statut de l'utilisateur en mode Premium
        user.is_premium = True
        
        db.add(new_tx)
        db.commit()

        return {
            "success": True,
            "message": "[MODE SIMULATION] Paiement Mobile Money validé avec succès !",
            "transaction_reference": tx_ref,
            "amount": amount,
            "currency": "XOF",
            "is_premium": True
        }

    return {"success": False, "message": "Passerelle de paiement réelle non configurée"}


# ==========================================
# 5. MODULE DE DÉTECTION DES ARNAQUES
# ==========================================

@app.post("/api/v1/verifications/check")
def check_content(payload: VerificationRequest, db: Session = Depends(get_db)):
    """
    Analyse un message ou un contenu suspect soumis par l'utilisateur 
    pour détecter s'il s'agit d'une tentative d'arnaque.
    """
    
    # Liste de mots-clés fréquents dans les arnaques au Mali (pour le prototype)
    scam_keywords = ["gain", "gratuit", "gagné", "orange money", "moov", "transfert", "code", "urgent", "concours"]
    
    # Vérifier si le texte contient l'un des mots-clés suspects (en minuscules pour éviter les erreurs)
    is_suspicious = any(word in payload.content_text.lower() for word in scam_keywords) if payload.content_text else False
    
    # Attribuer le statut de sécurité correspondant
    status_result = models.VerificationStatus.VERIFIED_SCAM if is_suspicious else models.VerificationStatus.VERIFIED_SAFE
    
    # Rédiger l'explication pédagogique pour l'utilisateur
    explanation = (
        "⚠️ Attention ! Ce message présente des indices caractéristiques d'une arnaque (sentiment d'urgence, promesse de gains)." 
        if is_suspicious 
        else "✅ Ce contenu semble sûr. Aucun piège majeur n'a été détecté pour le moment."
    )

    # Étape : Enregistrer le rapport de vérification dans la base de données PostgreSQL
    new_verification = models.Verification(
        title=payload.title,
        content_text=payload.content_text,
        analyzed_url=payload.analyzed_url,
        status=status_result,
        explanation=explanation,
        category=payload.category
    )
    db.add(new_verification)
    db.commit()
    db.refresh(new_verification)

    # Retourner le résultat de l'analyse à l'application mobile
    return {
        "success": True,
        "status": status_result,
        "explanation": explanation,
        "category": new_verification.category
    }