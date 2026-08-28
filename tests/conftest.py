import pytest

import server


@pytest.fixture(autouse=True)
def _reset_module_caches():
    """server.py caches heavy singletons in module globals; reset them
    around every test so nothing leaks between tests and no test
    accidentally loads a real multi-hundred-MB model from disk."""
    server._model_cache = None
    server._meta_min_cache = None
    server._index_cache = None
    server._scopus_cache = None
    server._lid_model_cache = None
    server._ce_cache = None
    yield
    server._model_cache = None
    server._meta_min_cache = None
    server._index_cache = None
    server._scopus_cache = None
    server._lid_model_cache = None
    server._ce_cache = None
