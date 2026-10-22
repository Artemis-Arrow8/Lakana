from fastapi import APIRouter, Depends
from sqlalchemy.orm import Session
from typing import List
from app.database import get_db
from app import models
# CORRECTION : Import depuis 'report' (au singulier) au lieu de 'reports'
from app.schemas.reports import ReportCreateRequest, ReportResponse

# Initialisation du routeur pour le module de crowdsourcing citoyen
router = APIRouter(prefix="/reports", tags=["Signalements Citoyens (Crowdsourcing)"])

@router.post("/", response_model=ReportResponse)
def create_citizen_report(payload: ReportCreateRequest, db: Session = Depends(get_db)):
    """
    Permet à un citoyen de signaler en temps réel une tentative d'arnaque 
    (faux numéro, lien suspect) pour renforcer la sécurité collective au Mali.
    """
    new_report = models.Report(
        phone_number_reported=payload.phone_number_reported,
        scam_url=payload.scam_url,
        description=payload.description,
        category=payload.category
    )
    db.add(new_report)
    db.commit()
    db.refresh(new_report)

    return new_report

@router.get("/", response_model=List[ReportResponse])
def get_all_reports(db: Session = Depends(get_db)):
    """
    Récupère la liste de tous les signalements citoyens récents 
    pour alimenter le fil de prévention de l'application mobile.
    """
    reports = db.query(models.Report).order_by(models.Report.created_at.desc()).all()
    return reports