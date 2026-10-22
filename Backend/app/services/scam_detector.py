from sqlalchemy.orm import Session
from app import models

class ScamDetectorService:
    """
    Service métier centralisant l'intelligence de détection des arnaques 
    et des tentatives de phishing adaptées au marché malien.
    """

    @staticmethod
    def analyze_content(db: Session, text: str = None, url: str = None, phone: str = None) -> dict:
        """
        Effectue une analyse multicritère d'un contenu suspect (numéro, lien ou texte) 
        et retourne un score de risque, un niveau d'alerte et des motifs détaillés.
        """
        score = 0
        reasons = []

        # 1. Vérification du numéro de téléphone par rapport aux signalements citoyens (Crowdsourcing)
        if phone:
            report_count = db.query(models.Report).filter(models.Report.phone_number_reported == phone).count()
            if report_count > 0:
                score += 50
                reasons.append(f"Numéro signalé {report_count} fois par la communauté Lakana.")

        # 2. Analyse de l'URL ou du lien Internet suspect
        if url:
            suspicious_domains = [
                "orange-mali-prime.ml", 
                "moov-cadeau.com", 
                "wave-bonus-gratuit.net", 
                "gagner-argent.site"
            ]
            url_lower = url.lower()
            
            # Détection de domaines connus ou de mots-clés pièges dans l'URL
            if any(domain in url_lower for domain in suspicious_domains) or any(term in url_lower for term in ["free", "bonus", "win", "cadeau"]):
                score += 45
                reasons.append("Lien suspect détecté : connu pour le phishing ou les fausses promesses de gains.")

        # 3. Analyse textuelle (mots-clés pièges en français adaptés au contexte local)
        if text:
            scam_keywords = [
                "gagner", "félicitations", "code secret", "transfert", "orange money", 
                "moov", "lotterie", "gros lot", "urgent", "frais de dédouanement", "activation"
            ]
            text_lower = text.lower()
            found_keywords = [kw for kw in scam_keywords if kw in text_lower]
            
            if found_keywords:
                # Incrémentation du score en fonction du nombre de mots-clés frauduleux trouvés
                score += len(found_keywords) * 20
                reasons.append(f"Présence de mots-clés suspects : {', '.join(found_keywords)}")

        # Plafonnement du score de risque à un maximum de 100
        score = min(score, 100)

        # Détermination du niveau de risque final selon le score calculé
        if score >= 70:
            risk_level = "DANGEREUX"
        elif score >= 35:
            risk_level = "SUSPECT"
        else:
            risk_level = "SÉCURISÉ"

        return {
            "score_risque": score,
            "niveau": risk_level,
            "motifs": reasons
        }