# Flagger

Feature flag / A/B-testing сервис на FastAPI.  
Цель проекта — дать простой, самостоятельный сервис для управления фичами и экспериментами (A/B/n) поверх существующих продуктов.

---

## Стек

Runtime:

- Python 3.13
- [FastAPI](https://fastapi.tiangolo.com/) — HTTP API
- [Uvicorn](https://www.uvicorn.org/) — ASGI-сервер
- [SQLAlchemy 2.x](https://docs.sqlalchemy.org/) — ORM/ядро работы с БД
- [asyncpg](https://github.com/MagicStack/asyncpg) — драйвер PostgreSQL (async)
- [Alembic](https://alembic.sqlalchemy.org/) — миграции
- [Pydantic v2](https://docs.pydantic.dev/) + `pydantic-settings` — схемы и конфиг
- `python-dotenv` — подхват `.env` в dev

Dev / качество кода:

- [uv](https://github.com/astral-sh/uv) — менеджер окружения и зависимостей
- [pytest](https://docs.pytest.org/)
- [pytest-asyncio](https://github.com/pytest-dev/pytest-asyncio)
- [httpx](https://www.python-httpx.org/) — клиент для API-тестов
- [pytest-cov](https://github.com/pytest-dev/pytest-cov) — покрытие
- [ruff](https://github.com/astral-sh/ruff) — линтер
- [black](https://black.readthedocs.io/) — форматтер
- [mypy](https://mypy-lang.org/) — статическая типизация
- [pre-commit](https://pre-commit.com/) — хуки

---

## Структура проекта

```text
.
├── app/
│   ├── api/            # HTTP-эндпоинты (v1, routers, deps и т.п.)
│   ├── cli/            # CLI-команды (опционально)
│   ├── core/           # конфигурация, логирование, безопасность
│   ├── db/             # session, Base, init_db
│   ├── models/         # SQLAlchemy-модели (users, projects, flags и т.д.)
│   ├── schemas/        # Pydantic-схемы (DTO)
│   ├── repositories/   # слой доступа к данным (DAO)
│   ├── services/       # бизнес-логика (evaluation, управление фичами)
│   ├── workers/        # фоновые задачи (по мере надобности)
│   ├── __init__.py
│   └── main.py         # create_app() и регистрация маршрутов (в т.ч. /health)
│
├── deploy/
│   ├── dev/prod/       # docker-compose + env.example для dev окружения
│   ├── local/prod/     # docker-compose + env.example для локального prod
│   └── prod/           # docker-compose + env.example для боевого prod
│
├── main.py             # точка входа для uvicorn: app = create_app()
├── migrations/         # Alembic миграции
├── tests/
│   ├── api/            # тесты HTTP-слоя (FastAPI + httpx)
│   └── unit/           # юнит-тесты сервисов/утилит
├── pyproject.toml      # зависимости, конфиги pytest/ruff/black
├── mypy.ini            # конфиг mypy
├── uv.lock             # lock-файл uv
├── README.md
└── Makefile            # make check / make test / make lint / make format
````

Сейчас уже есть минимальный health-check эндпоинт:

* `GET /health` → `{"status": "ok"}`

---

## Быстрый старт (dev)

### Требования

* Python 3.13
* установленный `uv`
* Docker (если планируешь запускать Postgres через `docker-compose` из `deploy/`)

### Клонирование и установка зависимостей

```bash
git clone <repo-url> flagger
cd flagger

# Установить runtime + dev зависимости и создать .venv
uv sync --all-groups
```

`uv` создаст виртуальное окружение `.venv` в корне проекта.

---

## Запуск приложения

Локальный запуск через uvicorn:

```bash
uv run uvicorn main:app --reload
```

По умолчанию сервер будет доступен по адресу:

* Swagger UI: [http://127.0.0.1:8000/docs](http://127.0.0.1:8000/docs)
* Health-check: `GET http://127.0.0.1:8000/health`

Структура `main.py` (корень):

```python
from app.main import create_app

app = create_app()
```

`app/main.py` возвращает FastAPI-приложение и регистрирует маршруты (в т.ч. `/health`).

---

## Тесты и качество кода

Все основные инструменты уже привязаны к `uv` и `Makefile`.

### Pytest (в т.ч. async + coverage)

Pytest настроен через `pyproject.toml`:

```toml
[tool.pytest.ini_options]
testpaths = ["tests"]
addopts = "-ra --strict-markers --cov=app --cov-report=term-missing"
asyncio_mode = "auto"
xfail_strict = true
```

Запуск:

```bash
uv run pytest
```

или с `Makefile`:

```bash
make test
```

### Ruff, Black, mypy — по отдельности

```bash
uv run ruff check .
uv run black --check .
uv run mypy .
```

---

## Makefile: одна команда для всех проверок

В корне есть `Makefile` со стандартными таргетами:

```makefile
.PHONY: lint typecheck test check format pre-commit

# Полная проверка: стиль + типы + тесты
check: lint typecheck test

lint:
	uv run ruff check .
	uv run black --check .

typecheck:
	uv run mypy .

test:
	uv run pytest

format:
	uv run black .
	uv run ruff check . --fix

pre-commit:
	uv run pre-commit run --all-files
```

Основные команды:

```bash
make check      # ruff + black --check + mypy + pytest
make lint       # только линтеры (ruff + black --check)
make typecheck  # только mypy
make test       # только pytest
make format     # автоформат (black + ruff --fix)
make pre-commit # прогнать все pre-commit хуки
```

---

## Pre-commit

Хуки описаны в `.pre-commit-config.yaml` (ruff, black, mypy, базовые проверки).

Первичная установка:

```bash
uv run pre-commit install
```

Разовый прогон по всем файлам:

```bash
make pre-commit
# или
uv run pre-commit run --all-files
```

Дальше хуки будут автоматически запускаться при `git commit`.

---

## Дальнейшее развитие (доменная логика)

Функциональность feature-flags / A/B-тестов планируется и проектируется вокруг следующих сущностей:

* `users` — пользователи админки/сервиса
* `projects` — проекты/продукты
* `environments` (`dev`, `stage`, `prod`) — окружения внутри проекта
* `feature_groups` — логические группы фич
* `feature_flags` — сами фичи (boolean / multi-variant)
* `feature_flag_env_settings` — состояние фичи по окружениям (enabled, rollout %)
* `flag_variants` — варианты для A/B/n (control, variant_a, …)
* `audit_log` — журнал изменений

План по feature-функционалу:

* CRUD пользователей, проектов, окружений, групп и фич
* A/B-тестирование на базе вариантов фич:

  * stable bucketing по `user_id`
  * процентный rollout
* API для SDK:

  * `/evaluate` для одной фичи
  * `/flags` (bulk) для проекта
* audit-лог всех изменений флагов и конфигурации
* позже: эксперименты как отдельная сущность, логи показов вариантов, kill-switch, расширенный RBAC, метрики сервиса.

---

