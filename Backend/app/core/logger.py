import logging
import sys
from pathlib import Path


LOG_DIR = Path("logs")
LOG_DIR.mkdir(exist_ok=True)
LOG_FILE = LOG_DIR / "lakana_app.log"

# Format structuré et professionnel des logs (Date/Heure | Niveau | Module:Fonction:Ligne - Message)
LOG_FORMAT = "%(asctime)s | %(levelname)-8s | %(name)s:%(funcName)s:%(lineno)d - %(message)s"

def setup_logger(name: str = "lakana") -> logging.Logger:
    """
    Configure et retourne un logger centralisé et réutilisable 
    dans tous les modules de l'application Lakana.
    """
    logger = logging.getLogger(name)
    logger.setLevel(logging.INFO)

    # Évite l'accumulation ou la duplication des handlers si le logger est initialisé plusieurs fois
    if logger.handlers:
        return logger

    # Handler 1 : Sortie standard sur la console (Terminal) pour le suivi en direct
    console_handler = logging.StreamHandler(sys.stdout)
    console_handler.setLevel(logging.INFO)
    console_formatter = logging.Formatter(LOG_FORMAT)
    console_handler.setFormatter(console_formatter)
    logger.addHandler(console_handler)

    # Handler 2 : Fichier de log persistant (logs/lakana_app.log) pour l'archivage et l'audit
    file_handler = logging.FileHandler(LOG_FILE, encoding="utf-8")
    file_handler.setLevel(logging.INFO)
    file_formatter = logging.Formatter(LOG_FORMAT)
    file_handler.setFormatter(file_formatter)
    logger.addHandler(file_handler)

    return logger

# Instance globale prête à être importée et utilisée dans toute l'application
logger = setup_logger()