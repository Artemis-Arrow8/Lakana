from sqlalchemy.orm import Session
from app import models

class ScamDetectorService:
    """
    Service métier centralisant l'intelligence de détection des arnaques,
    des tentatives de phishing et de la désinformation adaptées à l'espace AES
    (Mali, Burkina Faso, Niger).
    """

    # 1. Domaines officiels de confiance (Ministères, Présidences, Médias publics et de référence de l'AES)
    TRUSTED_DOMAINS = [
        "gouv.ml", "primature.ml", "sante.gouv.ml", "education.gouv.ml", "ortm.ml", "maliweb.net", "malijet.com", # Mali
        "sig.gov.bf", "gouvernement.gov.bf", "rtb.bf", # Burkina Faso
        "gouv.ne", "presidence.ne", "anp.ne" # Niger
    ]

    # 2. Mots-clés caractéristiques des arnaques téléphoniques et SMS (Mobile Money)
    PHONE_SCAM_KEYWORDS = [
        "erreur de transfert", "renvoyer l'argent", "compte bloque", "code otp",
        "gagne un lot", "loterie", "frais de dossier", "agent orange money",
        "agent moov", "wave validation", "bloquer votre puce", "numero gagnant",
        "felicitations", "gros lot"
    ]

    # 3. Mots-clés caractéristiques des faux décrets, communiqués et fake news
    FAKE_NEWS_KEYWORDS = [
        "communique officiel", "decret presidentiel", "concours exceptionnel",
        "recrutement massif de l'armee", "subvention accordee", "communique urgent",
        "visa gratuit", "bourse d'etude offerte", "decision du gouvernement"
    ]

    @staticmethod
    def analyze_content(db: Session, text: str = None, url: str = None, phone: str = None) -> dict:
        """
        Effectue une analyse multicritère d'un contenu suspect (numéro, lien, texte ou image OCR) 
        en croisant les signalements citoyens, les sources officielles de l'AES et les mots-clés de fraude.
        """
        score = 0
        reasons = []

        # 1. Vérification du numéro de téléphone par rapport aux signalements citoyens (Crowdsourcing)
        if phone:
            report_count = db.query(models.Report).filter(models.Report.phone_number_reported == phone).count()
            if report_count > 0:
                score += 50
                reasons.append(f"Numéro signalé {report_count} fois par la communauté de l'AES.")

        # 2. Analyse de l'URL ou du lien Internet
        if url:
            url_lower = url.lower()
            
            # Vérification si le lien appartient à une source officielle de l'AES
            is_trusted = any(domain in url_lower for domain in ScamDetectorService.TRUSTED_DOMAINS)
            
            if is_trusted:
                reasons.append("Source officielle certifiée de l'espace AES.")
                # Le score reste bas ou à 0 car le domaine est sûr
            else:
                suspicious_domains = [
                    "orange-mali-prime.ml", 
                    "moov-cadeau.com", 
                    "wave-bonus-gratuit.net", 
                    "gagner-argent.site"
                ]
                # Détection de domaines connus ou de mots-clés pièges dans l'URL
                if any(domain in url_lower for domain in suspicious_domains) or any(term in url_lower for term in ["free", "bonus", "win", "cadeau", "login", "update", "verify"]):
                    score += 50
                    reasons.append("Lien suspect détecté : connu pour le phishing ou les fausses promesses.")
                elif not url_lower.startswith("https://"):
                    score += 20
                    reasons.append("Lien non sécurisé (HTTP simple).")

        # 3. Analyse textuelle (SMS, messages ou texte extrait par OCR d'une image/décret)
        if text:
            text_lower = text.lower()
            
            # Recherche de mots-clés d'arnaques Mobile Money / Téléphoniques
            found_phone_scams = [kw for kw in ScamDetectorService.PHONE_SCAM_KEYWORDS if kw in text_lower]
            if found_phone_scams:
                score += len(found_phone_scams) * 25
                reasons.append(f"Suspicion d'arnaque Mobile Money (Termes : {', '.join(found_phone_scams)}).")

            # Recherche de mots-clés de faux décrets / Fake news institutionnelles
            found_fake_news = [kw for kw in ScamDetectorService.FAKE_NEWS_KEYWORDS if kw in text_lower]
            if found_fake_news:
                score += len(found_fake_news) * 25
                reasons.append(f"Formules caractéristiques de désinformation ou de faux décrets (Termes : {', '.join(found_fake_news)}).")

        # Plafonnement du score de risque à un maximum de 100
        score = min(score, 100)

        # Détermination du niveau de risque final selon le score calculé
        if score >= 70:
            risk_level = "DANGEREUX"
        elif score >= 35:
            risk_level = "SUSPECT"
        else:
            risk_level = "SÉCURISÉ"

        if not reasons:
            reasons.append("Aucun élément suspect détecté dans les bases de référence de l'AES.")

        return {
            "score_risque": score,
            "niveau": risk_level,
            "motifs": reasons
        }