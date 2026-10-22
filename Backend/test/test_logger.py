from app.core.logger import setup_logger

def test_setup_logger_already_initialized():
    """
    Teste le second appel de setup_logger pour couvrir la condition 
    qui évite la duplication des handlers (if logger.handlers: return logger).
    """
    logger_first = setup_logger("test_logger_unique")
    logger_second = setup_logger("test_logger_unique")
    
    assert logger_first is logger_second
    