ENV_FILE = --env-file .env
BASE     = -f docker-compose.yml
DEV      = $(BASE) -f docker-compose.dev.yml
PROD     = $(BASE) -f docker-compose.prod.yml
RM_DISTRO = -f docker-compose.ulcheyev-rm-distro.yml

# ── Environments ────────────────────────────────────────────────

dev:
	docker compose $(DEV) $(ENV_FILE) up --build -d

dev-oauth:
	docker compose $(DEV) -f docker-compose.local-oauth.yml $(ENV_FILE) up --build -d

dev-rm:
	docker compose $(DEV) $(RM_DISTRO) $(ENV_FILE) up --build -d

prod:
	docker compose $(PROD) $(ENV_FILE) up --build -d


# ── Helpers ──────────────────────────────────────────────────────

down:
	docker compose $(BASE) down

logs:
	docker compose $(BASE) $(ENV_FILE) logs -f

ps:
	docker compose $(BASE) ps

help:
	@echo "Usage: make <target>"
	@echo ""
	@echo "  dev            Local dev stack (no auth)"
	@echo "  dev-oauth      Local dev with Keycloak on host"
	@echo "  dev-rm         Local dev with dev distro images"
	@echo "  prod           Production deployment"
	@echo "  down           Stop all services"
	@echo "  logs           Tail logs"
	@echo "  ps             Show running containers"