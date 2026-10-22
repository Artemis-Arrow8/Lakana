def test_read_root(client):
    """
    Teste la route racine (Health Check) pour s'assurer que l'API est en ligne.
    """
    response = client.get("/")
    assert response.status_code == 200
    data = response.json()
    assert data["status"] == "online"
    assert "Lakana API" in data["app"]