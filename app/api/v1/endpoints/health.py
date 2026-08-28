from fastapi import APIRouter

from app.services.language import _get_lid_model
from app.services.retrieval import load_faiss, load_pkl_and_model, load_scopus_csv

router = APIRouter()


@router.get("/health")
def health():
    try:
        # Artefactos de RAG
        _ = load_pkl_and_model()
        _ = load_faiss()
        _ = load_scopus_csv()
        # Modelo de idioma (obligatorio, sin fallback)
        _ = _get_lid_model()
        return {"ok": True}
    except Exception as e:
        return {"ok": False, "error": str(e)}
