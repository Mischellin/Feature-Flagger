<div align="center">

# 🚩 Feature-Flagger

### **Lightweight, High-Performance Feature Flagging & A/B/n Testing Microservice**

[![Python 3.13+](https://img.shields.io/badge/python-3.13+-blue.svg?style=flat-square&logo=python&logoColor=white)](https://www.python.org/)
[![FastAPI](https://img.shields.io/badge/FastAPI-0.115+-009688.svg?style=flat-square&logo=fastapi&logoColor=white)](https://fastapi.tiangolo.com/)
[![SQLAlchemy 2.0](https://img.shields.io/badge/SQLAlchemy-2.0_(asyncpg)-red.svg?style=flat-square)](https://docs.sqlalchemy.org/)
[![Pydantic v2](https://img.shields.io/badge/Pydantic-v2-E92063.svg?style=flat-square&logo=pydantic&logoColor=white)](https://docs.pydantic.dev/)
[![Linter: Ruff](https://img.shields.io/badge/linter-ruff-black.svg?style=flat-square)](https://github.com/astral-sh/ruff)
[![Tests: Pytest](https://img.shields.io/badge/coverage-100%25-brightgreen.svg?style=flat-square)](https://pytest.org/)
[![Package Manager: uv](https://img.shields.io/badge/package_manager-uv-purple.svg?style=flat-square)](https://github.com/astral-sh/uv)
[![License: MIT](https://img.shields.io/badge/license-MIT-green.svg?style=flat-square)](LICENSE)

---

</div>

Feature-Flagger is a production-grade, standalone microservice designed for low-latency feature toggling, progressive percentage rollouts, and multi-variant (A/B/n) experiments across distributed architectures.

---

## ⚡ Architecture & Tech Stack

* **Runtime:** Python 3.13, FastAPI (ASGI via Uvicorn), async I/O.
* **Database & Persistence:** PostgreSQL via asynchronous driver (`asyncpg`) and SQLAlchemy 2.0 async session core.
* **Migrations:** Alembic.
* **Configuration & Validation:** Pydantic v2 and `pydantic-settings`.
* **Developer Experience & Tooling:** `uv` environment sync, `ruff` linting, `black` formatting, `mypy` static typing, and `pytest-asyncio` test suite.

---

## 📁 Project Structure

```text
.
├── backend/
│   ├── api/            # HTTP routers, v1 endpoints, dependencies
│   ├── cli/            # Administrative CLI commands
│   ├── core/           # Configuration, security, logging
│   ├── db/             # Async session engine, Base metadata
│   ├── models/         # SQLAlchemy 2.0 declarative models
│   ├── schemas/        # Pydantic v2 validation DTOs
│   ├── repositories/   # DAO / database access layer
│   ├── services/       # Feature evaluation engine & rollout logic
│   ├── workers/        # Asynchronous background tasks
│   ├── __init__.py
│   └── main.py         # Application factory: create_app() & routes
│
├── deploy/
│   ├── dev/            # Docker-compose & env setup for local development
│   └── prod/           # Production container orchestration
│
├── migrations/         # Alembic database migration revisions
├── tests/
│   ├── api/            # HTTP endpoints integration tests (FastAPI + httpx)
│   └── unit/           # Unit tests for evaluation logic
│
├── main.py             # Server entry point: app = create_app()
├── pyproject.toml      # Project manifest, dependencies, tool configurations
├── mypy.ini            # Mypy strict type checking rules
├── uv.lock             # Deterministic dependency lockfile
└── Makefile            # Developer workflow shortcuts
```

---

## 🚀 Quickstart (Local Development)

### Prerequisites
* Python >= 3.13
* [uv](https://github.com/astral-sh/uv) installed
* Docker (for PostgreSQL container)

### 1. Clone & Setup Environment
```bash
git clone https://github.com/Mischellin/Feature-Flagger.git
cd Feature-Flagger

# Sync dependencies into local .venv using uv
uv sync --all-groups
```

### 2. Start Application
```bash
# Run local dev server with auto-reload
uv run uvicorn main:app --reload
```

* **Interactive API Documentation:** [http://127.0.0.1:8000/docs](http://127.0.0.1:8000/docs) (Swagger UI)
* **Health Check Endpoint:**
  ```bash
  curl http://127.0.0.1:8000/health
  # {"status": "ok"}
  ```

---

## 🧪 Testing & Code Quality

Feature-Flagger enforces strict code formatting, type checking, and automated test coverage.

```bash
# Run test suite with async coverage report
uv run pytest

# Check code formatting and linting
uv run ruff check .
uv run black --check .

# Run static type analysis
uv run mypy .
```

### Makefile Shortcuts
```bash
make check      # ruff + black + mypy + pytest in one command
make test       # run pytest with coverage
make format     # auto-format with black & ruff --fix
```

---

## 🗺️ Roadmap & Domain Features

* **Entities:** Users, Projects, Environments (`dev`, `stage`, `prod`), Feature Groups, Multi-Variant Flags.
* **Evaluation Engine:**
  * Consistent hashing / stable bucketing by `user_id` for deterministic percentage rollouts.
  * Instant emergency kill-switch per environment.
  * Bulk SDK evaluation endpoint: `/api/v1/flags/eval` with sub-5ms target response time.
* **Audit Trail:** Immutable append-only logging of all flag state mutations.

---

## 📄 License

MIT © [Mikhail Sidorkin](https://github.com/Mischellin)
