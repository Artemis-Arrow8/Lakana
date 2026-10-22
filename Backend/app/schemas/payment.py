from pydantic import BaseModel, Field
from typing import Optional
import enum

class ProviderEnum(str, enum.Enum):
    """Énumération stricte des opérateurs autorisés."""
    ORANGE_MONEY = "ORANGE_MONEY"
    MOOV_MONEY = "MOOV_MONEY"
    WAVE = "WAVE"
    MOCK = "MOCK"

class PlanTypeEnum(str, enum.Enum):
    """Énumération stricte des types d'abonnement."""
    MONTHLY = "MONTHLY"
    YEARLY = "YEARLY"

class CheckoutRequest(BaseModel):
    """
    Schéma de validation pour l'initiation d'un paiement Mobile Money.
    Vérifie la conformité stricte du numéro de téléphone malien et des choix d'abonnement.
    """
    phone_number: str = Field(
        ..., 
        pattern=r"^(\+223)?(50|51|52|53|54|55|60|61|62|63|64|65|66|67|70|71|72|73|74|75|76|77|78|79|82|83|89|90|91|92|93|94|95|96|97|98|99)\d{6}$",
        description="Numéro de téléphone malien valide (ex: 76123456 ou +22376123456)"
    )
    provider: ProviderEnum = Field(..., description="Opérateur Mobile Money (ORANGE_MONEY, MOOV_MONEY, WAVE, MOCK)")
    plan_type: PlanTypeEnum = Field(..., description="Type d'abonnement (MONTHLY, YEARLY)")

class CheckoutResponse(BaseModel):
    """
    Schéma de réponse renvoyé après une tentative de paiement.
    """
    success: bool
    message: str
    transaction_reference: Optional[str] = None
    amount: Optional[float] = None
    currency: Optional[str] = "XOF"
    is_premium: Optional[bool] = False