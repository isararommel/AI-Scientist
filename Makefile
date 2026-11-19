PYTHON ?= python3

.PHONY: test
# Rauchtest: prüft nur, ob der Code fehlerfrei kompiliert (ohne API-Schlüssel, ohne GPU).
test:
	$(PYTHON) -m compileall -q ai_scientist launch_scientist.py templates review_ai_scientist review_iclr_bench experimental > /dev/null
	@echo "make test: ok"
