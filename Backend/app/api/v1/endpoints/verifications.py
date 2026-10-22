from fastapi import APIRouter, Depends
from sqlalchemy.orm import Session
from app.database import get_db
from app import models
from app.schemas.verification import VerificationRequest, VerificationResponse
from app.services.scam_detector import ScamDetectorService

# Initialisation du routeur pour l'analyse de sécurité et anti-arnaque
router = APIRouter(prefix="/verifications", tags=["Sécurité & Arnaques"])

@router.post("/check", response_model=VerificationResponse)
def check_content(payload: VerificationRequest, db: Session = Depends(get_db)):
    """
    Analyse un contenu suspect (message textuel ou lien) soumis par l'utilisateur 
    et stocke le résultat de l'analyse en base de données.
    """
    # Appel de la méthode statique du service métier de détection
    analysis_result = ScamDetectorService.analyze_content(
        db=db, 
        text=payload.content_text, 
        url=payload.analyzed_url
    )

    # Mapping du résultat de l'analyse vers le format attendu par le modèle de base de données
    status_map = {
        "SÉCURISÉ": models.VerificationStatus.VERIFIED_SAFE,
        "SUSPECT": models.VerificationStatus.SUSPICIOUS,
        "DANGEREUX": models.VerificationStatus.VERIFIED_SCAM
    }
    status_result = status_map.get(analysis_result["niveau"], models.VerificationStatus.SUSPICIOUS)
    explanation = " | ".join(analysis_result["motifs"]) if analysis_result["motifs"] else "Aucun élément suspect détecté. Contenu sûr."

    # Sauvegarde de la vérification dans la base PostgreSQL
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

    return VerificationResponse(
        success=True,
        status=str(status_result.value),
        explanation=explanation,
        category=new_verification.category
    )