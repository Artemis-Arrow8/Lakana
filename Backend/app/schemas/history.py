from pydantic import BaseModel, ConfigDict
from typing import Optional, List
from datetime import datetime

class VerificationHistoryItem(BaseModel):
    """
    Schéma représentant un élément de l'historique des vérifications de sécurité[cite: 10].
    """
    id: int
    title: str
    content_text: Optional[str] = None
    analyzed_url: Optional[str] = None
    status: str
    explanation: str
    category: str
    created_at: Optional[datetime] = None

    model_config = ConfigDict(from_attributes=True)


class TransactionHistoryItem(BaseModel):
    """
    Schéma représentant un élément de l'historique des transactions Mobile Money[cite: 10].
    """
    id: int
    reference: str
    amount: float
    provider: str
    status: str
    plan_type: str
    created_at: Optional[datetime] = None

    model_config = ConfigDict(from_attributes=True)