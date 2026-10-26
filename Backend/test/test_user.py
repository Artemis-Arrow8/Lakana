from app.schemas.user import UserCreate

def test_user_schema_validation():
    """
    Teste la validation Pydantic du schéma UserCreate pour s'assurer 
    que les numéros maliens sont correctement validés[cite: 11].
    """
    # Cas valide avec indicatif +223
    user_valid = UserCreate(phone_number="+22376123456")
    assert user_valid.phone_number == "+22376123456"

    # Cas valide sans indicatif (commençant par un opérateur malien)
    user_valid_local = UserCreate(phone_number="76123456")
    assert user_valid_local.phone_number == "76123456"

    # Cas invalide avec indicatif incorrect
    try:
        UserCreate(phone_number="+1234567890")
    except Exception as e:
        assert "phone_number" in str(e)
    else:
        assert False, "Expected an exception for invalid phone number"