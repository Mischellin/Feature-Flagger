.PHONY: lint typecheck test check format fix pre-commit

# Полная проверка: стиль + типы + тесты
check: lint typecheck test

# Статический анализ стиля
lint:
	uv run ruff check .
	uv run black --check .

# Статическая типизация
typecheck:
	uv run mypy .

# Тесты (с pytest-cov, если настроено в pyproject.toml)
test:
	uv run pytest

# Автоформатирование кода (если нужно править, а не только проверять)
format:
	uv run black .
	uv run ruff check . --fix

# Запуск pre-commit-хуков по всем файлам (опционально)
pre-commit:
	uv run pre-commit run --all-files
