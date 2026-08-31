import logging

from fastapi import APIRouter
from fastapi.responses import JSONResponse

from app.services.language import _get_lid_model
from app.services.retrieval import load_faiss, load_pkl_and_model, load_scopus_csv

router = APIRouter()
logger = logging.getLogger(__name__)


@router.get("/health", include_in_schema=False)
def health():
    try:
        # Artefactos de RAG
        _ = load_pkl_and_model()
        _ = load_faiss()
        _ = load_scopus_csv()
        # Modelo de idioma (obligatorio, sin fallback)
        _ = _get_lid_model()
        return {"status": "ok"}
    except Exception:
        logger.exception("Health check failed")
        return JSONResponse(status_code=503, content={"status": "error"})
