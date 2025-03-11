from fastapi import APIRouter, Depends, HTTPException
from ..crud.parts_crud import get_bikes_info, insert_bike_info
from ..db.session import get_db
from .protect import TokenData, get_current_user
from sqlalchemy.ext.asyncio import AsyncSession
from inference_sdk import InferenceHTTPClient
from fastapi import File, UploadFile
import base64
from io import BytesIO
from PIL import Image
import tempfile
import os
from dotenv import load_dotenv

load_dotenv()

router = APIRouter()

# Initialize Roboflow client
CLIENT = InferenceHTTPClient(
    api_url="https://detect.roboflow.com", api_key=os.getenv("ROBOFLOW_API_KEY")
)


@router.get("/bikesInfo/")
async def get_bikes(
    db: AsyncSession = Depends(get_db),
    current_user: TokenData = Depends(get_current_user),
):
    info = await get_bikes_info(db)
    return info


@router.post("/detect-bike/")
async def detect_bike(
    image_base64: str,
    current_user: TokenData = Depends(get_current_user),
):
    try:
        # Decode base64 image
        image_data = base64.b64decode(image_base64)
        image = Image.open(BytesIO(image_data))

        # Save image to temporary file
        with tempfile.NamedTemporaryFile(suffix=".jpg", delete=False) as temp_file:
            image.save(temp_file.name, format="JPEG")

            # Run inference using Roboflow
            result = CLIENT.infer(temp_file.name, model_id="bicycle-detection-lshuz/2")

            # Check if any bikes were detected
            has_bike = len(result.get("predictions", [])) > 0

            return {"has_bike": has_bike}

    except Exception as e:
        raise HTTPException(status_code=400, detail=f"Error processing image: {str(e)}")


@router.post("/uploadInfo/")
async def upload_info(
    info: dict,
    db: AsyncSession = Depends(get_db),
    current_user: TokenData = Depends(get_current_user),
):
    info = await insert_bike_info(db=db, bike_info=info)
    return {"message": "Info uploaded successfully"}
