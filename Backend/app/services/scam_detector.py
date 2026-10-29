from sqlalchemy.orm import Session
from app import models

class ScamDetectorService:
    """
    Service métier centralisant l'intelligence de détection des arnaques,
    des tentatives de phishing et de la désinformation adaptées à l'espace AES
    (Mali, Burkina Faso, Niger).
    """

    # 1. Domaines officiels de confiance (Whitelisting institutionnel)
    TRUSTED_DOMAINS = [
        "gouv.ml", "primature.ml", "sante.gouv.ml", "education.gouv.ml", "ortm.ml", "maliweb.net", "malijet.com", # Mali
        "sig.gov.bf", "gouvernement.gov.bf", "rtb.bf", # Burkina Faso
        "gouv.ne", "presidence.ne", "anp.ne" # Niger
    ]

    # 2. Domaines de phishing connus ou simulés pour les démos
    SUSPICIOUS_DOMAINS = [
        "orange-mali-prime.ml", "moov-cadeau.com", 
        "wave-bonus-gratuit.net", "gagner-argent.site", "bit.ly/"
    ]

    # 3. Mots-clés forts d'arnaques Mobile Money (Indicateurs de fraude financière directe)
    PHONE_SCAM_KEYWORDS = [
        "erreur de transfert", "renvoyer l'argent", "compte bloque", "code otp",
        "gagne un lot", "loterie", "frais de dossier", "agent orange money",
        "agent moov", "wave validation", "bloquer votre puce", "numero gagnant",
        "felicitations", "gros lot"
    ]

    # 4. Mots-clés de fausses informations / Faux décrets (Nécessitent un contexte piégeux)
    FAKE_NEWS_KEYWORDS = [
        "communique officiel", "decret presidentiel", "concours exceptionnel",
        "recrutement massif de l'armee", "subvention accordee", "communique urgent",
        "visa gratuit", "bourse d'etude offerte", "decision du gouvernement"
    ]

    @staticmethod
    def analyze_content(db: Session, text: str = None, url: str = None, phone: str = None) -> dict:
        """
        Effectue une analyse multicritère intelligente d'un contenu suspect (numéro, lien, texte)
        en évitant les faux positifs sur les messages professionnels ou administratifs légitimes.
        """
        score = 0
        reasons = []
        is_officially_trusted = False

        # -------------------------------------------------------------------------
        # ÉTAPE 0 : Analyse préalable de l'URL pour la whitelist (Protection des sources officielles)
        # -------------------------------------------------------------------------
        if url:
            url_lower = url.lower()
            is_officially_trusted = any(domain in url_lower for domain in ScamDetectorService.TRUSTED_DOMAINS)

        # Si le lien provient d'une source officielle reconnue, on court-circuite le risque
        if is_officially_trusted:
            return {
                "score_risque": 0,
                "niveau": "SÉCURISÉ",
                "motifs": ["Source institutionnelle certifiée de l'espace AES."]
            }

        # -------------------------------------------------------------------------
        # ÉTAPE 1 : Vérification du numéro de téléphone (Signalements citoyens / Crowdsourcing)
        # -------------------------------------------------------------------------
        if phone:
            report_count = db.query(models.Report).filter(models.Report.phone_number_reported == phone).count()
            if report_count > 0:
                score += 60 
                reasons.append(f"Numéro signalé {report_count} fois par la communauté citoyenne de l'AES.")

        # -------------------------------------------------------------------------
        # ÉTAPE 2 : Analyse approfondie de l'URL ou du lien Internet fourni
        # -------------------------------------------------------------------------
        if url:
            url_lower = url.lower()
            
            # Détection de domaines malveillants connus ou de pièges marketing/phishing
            has_suspicious_domain = any(domain in url_lower for domain in ScamDetectorService.SUSPICIOUS_DOMAINS)
            has_phishing_terms = any(term in url_lower for term in ["free", "bonus", "win", "cadeau", "login", "update", "verify"])
            
            if has_suspicious_domain or has_phishing_terms:
                score += 50
                reasons.append("Lien suspect détecté : connu pour le phishing ou l'hameçonnage.")
            elif not url_lower.startswith("https://"):
                score += 15
                reasons.append("Lien non sécurisé (protocole HTTP simple détecté).")

        # -------------------------------------------------------------------------
        # ÉTAPE 3 : Analyse textuelle intelligente (SMS, messages ou OCR) avec gestion du contexte
        # -------------------------------------------------------------------------
        if text:
            text_lower = text.lower()
            
            # A. Détection des arnaques financières / Mobile Money (Tolérance zéro)
            found_phone_scams = [kw for kw in ScamDetectorService.PHONE_SCAM_KEYWORDS if kw in text_lower]
            if found_phone_scams:
                score += 50  # Un seul mot-clé fort suffit à alerter sérieusement
                reasons.append(f"Suspicion d'arnaque financière / Mobile Money (Indicateur : {found_phone_scams[0]}).")

            # B. Détection des faux décrets / Fake news (Condition stricte : couplé à un appel à l'action ou lien douteux)
            found_fake_news = [kw for kw in ScamDetectorService.FAKE_NEWS_KEYWORDS if kw in text_lower]
            
            if found_fake_news:
                # Le piège classique : un faux décret s'accompagne souvent d'une URL louche ou d'une urgence feinte
                has_call_to_action = any(action in text_lower for action in ["cliquez", "ici", "lien", "immédiatement", "partager"])
                
                if url or has_call_to_action:
                    score += 45
                    reasons.append(f"Formule de désinformation / Faux décret associée à un lien ou un appel à l'action suspect.")
                else:
                    # Si c'est juste le mot mentionné sans lien ni piège (ex: message de coordination interne), le risque est minime
                    score += 10
                    reasons.append("Mention administrative sensible détectée (contexte à vérifier).")

        # -------------------------------------------------------------------------
        # ÉTAPE 4 : Plafonnement et classification finale du niveau de risque
        # -------------------------------------------------------------------------
        score = min(score, 100)

        # Seuils ajustés pour éviter les faux positifs lors de la démo
        if score >= 60:
            risk_level = "DANGEREUX"
        elif score >= 25:
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