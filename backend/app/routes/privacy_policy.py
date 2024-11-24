from fastapi import APIRouter
from fastapi.responses import HTMLResponse

router = APIRouter()


@router.get("/privacy-policy", response_class=HTMLResponse)
async def get_privacy_policy():
    with open("privacy_policy.html", "r", encoding="utf-8") as file:
        html_content = file.read()
    return html_content
