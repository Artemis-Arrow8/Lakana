def test_create_and_get_reports(client):
    """
    Teste la création d'un signalement citoyen (Crowdsourcing) et sa récupération.
    """
    payload = {
        "phone_number_reported": "+22376112233",
        "scam_url": "http://arnaque-mali.com",
        "description": "Tentative de vol de code secret",
        "category": "PHISHING"
    }
    
    # Test de l'insertion (POST)
    post_res = client.post("/api/v1/reports/", json=payload)
    assert post_res.status_code == 200
    data = post_res.json()
    assert data["phone_number_reported"] == "+22376112233"
    assert "id" in data

    # Test de la récupération de la liste (GET)
    get_res = client.get("/api/v1/reports/")
    assert get_res.status_code == 200
    reports = get_res.json()
    assert len(reports) >= 1