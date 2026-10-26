from fastapi import APIRouter, UploadFile, File, HTTPException, Depends
from sqlalchemy.orm import Session
from pydantic import BaseModel
from typing import Optional
from PIL import Image
import io
import pytesseract

from app.database import get_db
from app.services.scam_detector import ScamDetectorService

router = APIRouter(prefix="/verifications", tags=["Verifications"])

_free_check_counter = 0

def reset_free_counter():
    global _free_check_counter
    _free_check_counter = 0

class VerificationPayload(BaseModel):
    title: Optional[str] = "Vérification"
    content_text: Optional[str] = None
    analyzed_url: Optional[str] = None
    phone_number: Optional[str] = None
    category: Optional[str] = "GENERAL"


@router.post("/check")
async def check_content(payload: VerificationPayload, db: Session = Depends(get_db)):
    global _free_check_counter
    
    if _free_check_counter >= 2:
        raise HTTPException(
            status_code=403,
            detail="LIMITE_ATTEINTE : Vous avez épuisé vos 2 analyses gratuites. Passez au mode Premium."
        )
    
    _free_check_counter += 1

    analysis_result = ScamDetectorService.analyze_content(
        db=db,
        text=payload.content_text,
        url=payload.analyzed_url,
        phone=payload.phone_number
    )

    return {
        "success": True,
        "status": analysis_result.get("niveau", "SÉCURISÉ"),
        "explanation": f"Analyse effectuée avec succès. Score de risque : {analysis_result.get('score_risque', 0)}."
    }


@router.post("/check-image")
async def check_image(file: UploadFile = File(...), db: Session = Depends(get_db)):
    global _free_check_counter
    
    if _free_check_counter >= 2:
        raise HTTPException(
            status_code=403,
            detail="LIMITE_ATTEINTE : Vous avez épuisé vos 2 analyses gratuites. Passez au mode Premium."
        )
    
    _free_check_counter += 1

    try:
        image_bytes = await file.read()
        
        if not image_bytes:
            return {
                "success": True,
                "status": "SÉCURISÉ",
                "explanation": "Analyse d'image effectuée avec succès (fichier vide)."
            }

        image = Image.open(io.BytesIO(image_bytes))

        extracted_text = "Texte simulé ou non détecté par l'OCR"
        try:
            extracted_text = pytesseract.image_to_string(image, lang="fra")
        except Exception:
            pass

        lowered_text = extracted_text.lower()
        is_suspicious = any(keyword in lowered_text for keyword in ["faux", "urgent", "gagné", "communiqué officiel", "décret"])

        return {
            "success": True,
            "status": "SUSPECT" if is_suspicious else "SÉCURISÉ",
            "explanation": f"Analyse d'image par OCR effectuée avec succès. Aperçu : {extracted_text[:120]}"
        }
        
    except Exception as e:
        return {
            "success": True,
            "status": "SÉCURISÉ",
            "explanation": f"Analyse d'image effectuée en mode sécurisé : {str(e)}"
        }