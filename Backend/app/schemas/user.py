from pydantic import BaseModel, Field, ConfigDict
from typing import Optional
from datetime import datetime

class UserCreate(BaseModel):
    """
    Schéma pour la création ou l'identification d'un utilisateur par son numéro[cite: 13].
    """
    phone_number: str = Field(
        ..., 
        pattern=r"^(\+223)?(50|51|52|53|54|55|60|61|62|63|64|65|66|67|70|71|72|73|74|75|76|77|78|79|82|83|89|90|91|92|93|94|95|96|97|98|99)\d{6}$",
        description="Numéro de téléphone malien obligatoire pour l'authentification[cite: 13]"
    )

class UserResponse(BaseModel):
    """
    Schéma représentant le profil d'un utilisateur retourné par l'API[cite: 13].
    """
    id: int
    phone_number: str
    is_premium: bool
    created_at: Optional[datetime] = None

    model_config = ConfigDict(from_attributes=True)