from app.services.scam_detector import ScamDetectorService

def test_scam_detector_empty_inputs(db_session):
    """
    Vérifie le comportement du service lorsque les entrées sont vides.
    """
    result = ScamDetectorService.analyze_content(db=db_session)
    assert result["niveau"] == "SÉCURISÉ"
    assert result["score_risque"] <= 1  
    # Le service retourne le message par défaut de l'AES, donc la longueur est 1
    assert len(result["motifs"]) == 1
    assert "Aucun élément suspect" in result["motifs"][0]


def test_scam_detector_unknown_phone(db_session):
    """
    Vérifie l'analyse d'un numéro de téléphone non présent dans la base de signalements.
    """
    result = ScamDetectorService.analyze_content(
        db=db_session,
        phone="+22300000000"
    )
    assert result["niveau"] == "SÉCURISÉ"
    assert result["score_risque"] == 0