from pydantic import BaseModel, Field, ConfigDict
from typing import Optional
from datetime import datetime

class ReportCreateRequest(BaseModel):
    """
    Schéma pour la soumission d'un nouveau signalement d'arnaque par un citoyen[cite: 12].
    """
    phone_number_reported: Optional[str] = Field(
        None, 
        description="Numéro de téléphone de l'arnaqueur signalé (optionnel)[cite: 12]"
    )
    scam_url: Optional[str] = Field(
        None, 
        description="Lien Internet suspect ou malveillant (optionnel)[cite: 12]"
    )
    description: str = Field(
        ..., 
        description="Description détaillée de l'arnaque vécue[cite: 12]"
    )
    category: Optional[str] = Field(
        "ARNAQUE_FINANCIERE", 
        description="Catégorie de l'arnaque[cite: 12]"
    )

class ReportResponse(BaseModel):
    """
    Schéma de réponse renvoyant les détails d'un signalement enregistré[cite: 12].
    """
    id: int
    phone_number_reported: Optional[str] = None
    scam_url: Optional[str] = None
    description: str
    category: str
    created_at: Optional[datetime] = None

    model_config = ConfigDict(from_attributes=True)