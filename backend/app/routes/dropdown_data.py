from fastapi import APIRouter
import csv
from pathlib import Path
import aiofiles

router = APIRouter()


@router.get("/dropdown_data/{file_name}")
async def get_dropdown_data(
    file_name: str,
):
    parent = Path.cwd() / "app"
    file_path = parent / "dropdown_data/{file_name}.csv".format(file_name=file_name)
    data = []
    async with aiofiles.open(file_path, mode="r") as csvfile:
        contents = await csvfile.read()
        reader = csv.DictReader(contents.splitlines())
        data = [row for row in reader]
    return data
