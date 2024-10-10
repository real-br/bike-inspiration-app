from fastapi import APIRouter
import csv
from pathlib import Path

router = APIRouter()


@router.get("/dropdown_data/{file_name}")
async def get_dropdown_data(
    file_name: str,
):
    parent = Path.cwd()
    file_path = parent / "dropdown_data/{file_name}.csv".format(file_name=file_name)
    data = []
    with open(file_path, newline="") as csvfile:
        reader = csv.DictReader(csvfile)
        data = [row for row in reader]
    return data
