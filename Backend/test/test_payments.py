from unittest.mock import patch

def test_successful_payment(client):
    """
    Teste l'initiation d'un paiement valide (Orange Money) et l'activation du statut Premium[cite: 8].
    """
    payload = {
        "phone_number": "+22376123456",
        "provider": "ORANGE_MONEY",
        "plan_type": "MONTHLY"
    }
    res = client.post("/api/v1/payments/checkout", json=payload)
    assert res.status_code == 200
    data = res.json()
    assert data["success"] is True
    assert data["is_premium"] is True
    assert "LK-" in data["transaction_reference"]

def test_invalid_phone_payment(client):
    """
    Teste le rejet automatique d'un numéro malien incorrect grâce à la Regex Pydantic (Erreur 422)[cite: 8].
    """
    payload = {
        "phone_number": "00000000",  # Numéro non conforme
        "provider": "WAVE",
        "plan_type": "MONTHLY"
    }
    res = client.post("/api/v1/payments/checkout", json=payload)
    assert res.status_code == 422

def test_yearly_payment(client):
    """
    Teste l'initiation d'un paiement avec un plan annuel (YEARLY) et vérifie le montant appliqué (10000.00)[cite: 8].
    """
    payload = {
        "phone_number": "+22370123456",
        "provider": "ORANGE_MONEY",
        "plan_type": "YEARLY"
    }
    res = client.post("/api/v1/payments/checkout", json=payload)
    assert res.status_code == 200
    data = res.json()
    assert data["success"] is True
    assert data["amount"] == 10000.00

def test_payment_internal_error(client):
    """
    Simule une erreur de base de données pour valider la gestion de l'exception (Erreur 500)[cite: 8].
    """
    payload = {
        "phone_number": "+22376123456",
        "provider": "ORANGE_MONEY",
        "plan_type": "MONTHLY"
    }
    with patch("sqlalchemy.orm.Session.commit", side_effect=Exception("Erreur DB simulée")):
        res = client.post("/api/v1/payments/checkout", json=payload)
        assert res.status_code == 500
        assert "Erreur interne" in res.json()["detail"]