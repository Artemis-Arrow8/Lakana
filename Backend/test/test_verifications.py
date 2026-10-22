def test_check_content_endpoint(client):
    """
    Teste l'endpoint d'analyse de sécurité des messages et des liens.
    """
    payload = {
        "title": "Vérification SMS suspect",
        "content_text": "Félicitations vous avez gagné un gros lot",
        "analyzed_url": "http://gagner-argent.site",
        "category": "ARNAQUE_FINANCIERE"
    }
    res = client.post("/api/v1/verifications/check", json=payload)
    assert res.status_code == 200
    data = res.json()
    assert data["success"] is True
    assert "status" in data
    assert "explanation" in data