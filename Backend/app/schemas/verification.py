from pydantic import BaseModel, Field
from typing import Optional

class VerificationRequest(BaseModel):
    """
    Schéma de requête pour soumettre un texte ou un lien à analyser.
    """
    title: str = Field(..., description="Titre ou libellé de la vérification")
    content_text: Optional[str] = Field(None, description="Contenu textuel du message reçu")
    analyzed_url: Optional[str] = Field(None, description="Lien URL suspect à analyser")
    category: Optional[str] = Field("ARNAQUE_FINANCIERE", description="Catégorie présumée")

class VerificationResponse(BaseModel):
    """
    Schéma de réponse contenant le verdict de l'analyse de sécurité.
    """
    success: bool
    status: str = Field(..., description="Verdict (ex: SÉCURISÉ, SUSPECT, DANGEREUX)")
    explanation: str = Field(..., description="Explication détaillée des motifs du verdict")
    category: Optional[str] = None