import os
from sqlalchemy import create_engine
from sqlalchemy.ext.declarative import declarative_base
from sqlalchemy.orm import sessionmaker
from dotenv import load_dotenv
from sqlalchemy.orm import declarative_base

# Chargement sécurisé des variables d'environnement depuis le fichier .env
load_dotenv()
DATABASE_URL = os.getenv("DATABASE_URL")

# Création du moteur de connexion SQLAlchemy pour PostgreSQL
engine = create_engine(DATABASE_URL)

# Configuration de la fabrique de sessions pour interagir avec la base de données
SessionLocal = sessionmaker(autocommit=False, autoflush=False, bind=engine)

# Base déclarative de référence pour définir les modèles ORM de tables
Base = declarative_base()

def get_db():
    """
    Dépendance FastAPI : Ouvre une session de base de données dédiée pour chaque requête 
    HTTP entrante et garantit sa fermeture automatique et propre à la fin du traitement.
    """
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()