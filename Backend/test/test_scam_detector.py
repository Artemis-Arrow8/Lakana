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
    Teste la détection combinée de mots-clés frauduleux et d'un numéro signalé.
    """
    report = models.Report(
        phone_number_reported="+22376999999",
        description="Faux agent Orange",
        category="ARNAQUE_FINANCIERE"
    )
    db_session.add(report)
    db_session.commit()

    result = ScamDetectorService.analyze_content(
        db=db_session,
        text="Félicitations ! Vous avez gagné un lot Orange Money. Code secret urgent !",
        phone="+22376999999"
    )
    assert result["niveau"] in ["SUSPECT", "DANGEREUX"]
    assert result["score_risque"] >= 50

def test_scam_detector_plain_http_url(db_session):
    """
    Teste une URL en HTTP simple (sans termes piégés) pour couvrir 
    spécifiquement les lignes 87-88 du service ScamDetector.
    """
    result = ScamDetectorService.analyze_content(
        db=db_session,
        url="http://site-neutre-ordinaire.com"
    )
    assert result["score_risque"] >= 20
    assert any("non sécurisé" in motif for motif in result["motifs"])

def test_scam_detector_http_plain_url_strict(db_session):
    """
    Force l'évaluation exacte de la branche HTTP non sécurisée (lignes 87-88)
    en s'assurant qu'aucun autre filtre ne s'intercale.
    """
    result = ScamDetectorService.analyze_content(
        db=db_session,
        url="http://192.168.1.1/index"
    )
    assert result["score_risque"] >= 20
    assert any("non sécurisé" in motif for motif in result["motifs"])