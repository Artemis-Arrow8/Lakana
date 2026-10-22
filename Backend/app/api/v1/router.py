from fastapi import APIRouter
from app.api.v1.endpoints import payments, verifications, history, reports

# Initialisation du routeur central pour l'API Version 1 de Lakana
api_router = APIRouter()

# Enregistrement du module de gestion des abonnements et paiements Mobile Money
api_router.include_router(payments.router)

# Enregistrement du module de vérification et d'analyse anti-arnaque
api_router.include_router(verifications.router)

# Enregistrement du module de consultation de l'historique des utilisateurs
api_router.include_router(history.router)

# Enregistrement du module de signalement citoyen (Crowdsourcing)
api_router.include_router(reports.router)