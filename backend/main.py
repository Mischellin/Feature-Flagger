from fastapi import FastAPI


def create_app() -> FastAPI:
    app = FastAPI(title="Flagger", version="0.1.0")

    @app.get("/health", tags=["health"])
    async def health() -> dict[str, str]:
        return {"status": "ok"}

    return app
