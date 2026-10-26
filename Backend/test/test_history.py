
def test_get_verification_and_transaction_history(client):
    """
    Teste la consultation de l'historique des vérifications et des transactions par numéro de téléphone[cite: 5].
    """
    # 1. Création préalable d'une transaction pour générer un utilisateur et son historique
    client.post("/api/v1/payments/checkout", json={
        "phone_number": "+22376123456",
        "provider": "MOOV_MONEY",
        "plan_type": "MONTHLY"
    })

    # 2. Récupération de l'historique global des vérifications
    res_verif = client.get("/api/v1/history/verifications")
    assert res_verif.status_code == 200

    # 3. Récupération des transactions de l'utilisateur via son numéro
    res_tx = client.get("/api/v1/history/transactions/+22376123456")
    assert res_tx.status_code == 200
    assert len(res_tx.json()) >= 1

    # 4. Test d'erreur : recherche d'un utilisateur valide par sa Regex mais absent en base (doit retourner 404)[cite: 5]
    res_not_found = client.get("/api/v1/history/transactions/+22370000000")
    assert res_not_found.status_code == 404