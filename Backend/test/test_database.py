from app.database import get_db

def test_get_db_generator():
    """
    Teste le générateur get_db pour garantir l'ouverture de la session
    et son exécution complète (couvrant le bloc finally).
    """
    # 1. Récupération du générateur de session
    db_generator = get_db()
    
    # 2. Obtention de la session active (exécute le code avant le yield)
    session = next(db_generator)
    assert session is not None

    # 3. Tentative de faire avancer le générateur pour déclencher le bloc 'finally' (db.close())
    try:
        next(db_generator)
    except StopIteration:
        # StopIteration est le comportement normal d'un générateur qui se termine
        pass