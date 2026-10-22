from fastapi import FastAPI, Request
from fastapi.middleware.cors import CORSMiddleware
import time
from app.database import engine, Base
from app.api.v1.router import api_router
from app.core.logger import logger

# Création automatique des tables dans la base de données au démarrage
Base.metadata.create_all(bind=engine)

# Initialisation de l'application FastAPI pour le projet Lakana

app = FastAPI(
    title="Lakana Security API",
    description="API de protection numérique et de gestion des abonnements Mobile Money pour le Mali",
    version="1.0.0"
)

# Configuration du middleware CORS pour autoriser la communication avec l'application mobile Flutter
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# Middleware personnalisé et asynchrone pour logger chaque requête HTTP entrante et sortante
@app.middleware("http")
async def log_requests(request: Request, call_next):
    start_time = time.time()
    logger.info(f" Requête entrante: {request.method} {request.url.path}")
    
    # Exécution de la requête
    response = await call_next(request)  
    
    # Calcul du temps de traitement en millisecondes
    process_time = (time.time() - start_time) * 1000
    logger.info(f" Réponse: {request.method} {request.url.path} - Statut {response.status_code} ({process_time:.2f}ms)")
    return response

# Inclusion du routeur centralisé pour l'API Version 1
app.include_router(api_router, prefix="/api/v1")

@app.get("/")
def read_root():
    """
    Route racine de vérification de l'état de santé (Health Check) du serveur.
    """
    logger.info("Vérification de l'état de santé du serveur.")
    return {
        "status": "online",
        "app": "Lakana API",
        "message": "Bienvenue sur l'API de Lakana, prête à sécuriser le Mali !"
    }