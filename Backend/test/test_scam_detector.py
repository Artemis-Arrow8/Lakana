from app.services.scam_detector import ScamDetectorService
from app import models

def test_scam_detector_safe(db_session):
    """
    Teste un contenu totalement sûr (aucun signalement, pas de mots-clés suspects, domaine légitime).
    """
    result = ScamDetectorService.analyze_content(
        db=db_session,
        text="Bonjour, comment vas-tu ?",
        url="https://google.com",
        phone="+22370000000"
    )
    assert result["niveau"] == "SÉCURISÉ"
    assert result["score_risque"] == 0

def test_scam_detector_dangerous_phishing(db_session):
    """
    Teste la détection d'une URL de phishing connue et malveillante.
    """
    result = ScamDetectorService.analyze_content(
        db=db_session,
        url="http://orange-mali-prime.ml/free-bonus"
    )
    assert result["niveau"] in ["SUSPECT", "DANGEREUX"]
    assert len(result["motifs"]) > 0

def test_scam_detector_keywords_and_reported_phone(db_session):
    """
    Teste la détection combinée de mots-clés frauduleux et d'un numéro déjà signalé par la communauté.
    """
    # Enregistrement préalable d'un signalement d'arnaque
    report = models.Report(
        phone_number_reported="+22376999999",
        description="Faux agent Orange",
        category="ARNAQUE_FINANCIERE"
    )
    db_session.add(report)
    db_session.commit()

    # Analyse d'un texte suspect provenant de ce même numéro
    result = ScamDetectorService.analyze_content(
        db=db_session,
        text="Félicitations ! Vous avez gagné un lot Orange Money. Code secret urgent !",
        phone="+22376999999"
    )
    assert result["niveau"] == "DANGEREUX"
    assert result["score_risque"] >= 70