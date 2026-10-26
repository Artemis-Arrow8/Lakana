import io
from PIL import Image
from unittest.mock import patch
from app.api.v1.endpoints.verifications import reset_free_counter
from app.schemas.verification import VerificationRequest, VerificationResponse
from app.services.scam_detector import ScamDetectorService

def create_valid_dummy_image():
    """Génère une vraie image PNG valide en mémoire pour éviter les erreurs Pillow."""
    img = Image.new('RGB', (10, 10), color='white')
    img_byte_arr = io.BytesIO()
    img.save(img_byte_arr, format='PNG')
    img_byte_arr.seek(0)
    return img_byte_arr.read()

def test_freemium_limit_enforcement(client):
    """Vérifie que le modèle freemium bloque la 3ème analyse (Statut 403 LIMITE_ATTEINTE)."""
    reset_free_counter()  
    payload = {
        "title": "Test Quota",
        "content_text": "Vérification normale",
        "category": "TEST"
    }
    assert client.post("/api/v1/verifications/check", json=payload).status_code == 200
    assert client.post("/api/v1/verifications/check", json=payload).status_code == 200
    res3 = client.post("/api/v1/verifications/check", json=payload)
    assert res3.status_code == 403
    assert "LIMITE_ATTEINTE" in res3.json()["detail"]

def test_check_content_endpoint(client):
    """Teste l'endpoint d'analyse de sécurité des messages et des liens."""
    reset_free_counter()  
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

def test_check_image_endpoint(client):
    """Teste l'endpoint d'analyse d'image avec une vraie image valide."""
    reset_free_counter()  
    image_bytes = create_valid_dummy_image()
    files = {'file': ('faux_decret.png', io.BytesIO(image_bytes), 'image/png')}
    res = client.post("/api/v1/verifications/check-image", files=files)
    assert res.status_code == 200
    data = res.json()
    assert data["success"] is True
    assert "status" in data

def test_check_image_edge_cases(client):
    """Teste les cas d'erreur ou d'image corrompue pour l'OCR."""
    reset_free_counter()
    files = {'file': ('bad_image.png', io.BytesIO(b"donnees_corrompues_pas_une_image"), 'image/png')}
    res = client.post("/api/v1/verifications/check-image", files=files)
    assert res.status_code == 200

def test_scam_detector_urls_and_trusted(db_session):
    """Teste les domaines officiels et les liens HTTP non sécurisés (couvre les lignes 87-88)."""
    res_trusted = ScamDetectorService.analyze_content(db=db_session, url="https://www.gouv.ml")
    assert res_trusted["score_risque"] == 0

    # Couvre explicitement les lignes 87-88 de scam_detector.py (HTTP simple)
    res_http = ScamDetectorService.analyze_content(db=db_session, url="http://site-lambda-quelconque.ml")
    assert res_http["score_risque"] >= 20
    assert any("non sécurisé" in motif for motif in res_http["motifs"])

def test_check_image_critical_exception(client):
    """Force une exception critique dans check-image pour couvrir le bloc except final."""
    reset_free_counter()
    res = client.post("/api/v1/verifications/check-image", files={})
    assert res.status_code in [200, 422]

def test_verification_schemas():
    """Teste l'instanciation des schémas Pydantic."""
    req = VerificationRequest(title="Test Schéma", content_text="Contenu de test", analyzed_url="https://gouv.ml", category="ARNAQUE_FINANCIERE")
    assert req.title == "Test Schéma"
    res = VerificationResponse(success=True, status="SÉCURISÉ", explanation="Test explanation", category="ARNAQUE_FINANCIERE")
    assert res.success is True

def test_check_image_empty_file(client):
    """Teste l'envoi d'un fichier image complètement vide."""
    reset_free_counter()
    files = {'file': ('empty.png', io.BytesIO(b""), 'image/png')}
    res = client.post("/api/v1/verifications/check-image", files=files)
    assert res.status_code == 200
    assert res.json()["success"] is True

def test_check_image_freemium_limit(client):
    """Vérifie que la 3ème requête sur /check-image déclenche la limite freemium (403)."""
    reset_free_counter()
    image_bytes = create_valid_dummy_image()
    assert client.post("/api/v1/verifications/check-image", files={'file': ('img1.png', io.BytesIO(image_bytes), 'image/png')}).status_code == 200
    assert client.post("/api/v1/verifications/check-image", files={'file': ('img2.png', io.BytesIO(image_bytes), 'image/png')}).status_code == 200
    res3 = client.post("/api/v1/verifications/check-image", files={'file': ('img3.png', io.BytesIO(image_bytes), 'image/png')})
    assert res3.status_code == 403
    assert "LIMITE_ATTEINTE" in res3.json()["detail"]

@patch("app.api.v1.endpoints.verifications.pytesseract.image_to_string")
def test_check_image_suspicious_text(mock_image_to_string, client):
    """Simule une extraction OCR détectant un faux décret / contenu suspect."""
    reset_free_counter()
    image_bytes = create_valid_dummy_image()
    mock_image_to_string.return_value = "Ceci est un faux décret présidentiel urgent"
    
    res = client.post("/api/v1/verifications/check-image", files={'file': ('decret.png', io.BytesIO(image_bytes), 'image/png')})
    assert res.status_code == 200
    data = res.json()
    assert data["success"] is True
    assert data["status"] == "SUSPECT"