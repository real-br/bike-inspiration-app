from pathlib import Path
from fastapi import APIRouter
from fastapi.responses import HTMLResponse

router = APIRouter()


@router.get("/privacy-policy", response_class=HTMLResponse)
async def get_privacy_policy():
    parent = Path.cwd() / "app" / "routes"
    file_path = parent / "privacy_policy.html"
    with open(file_path, "r", encoding="utf-8") as file:
        html_content = file.read()
    return html_content
