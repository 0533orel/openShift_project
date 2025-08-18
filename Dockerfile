# בסיס קליל
FROM python:3.11-slim

# משתני סביבה
ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1 \
    PYTHONPATH=/app/services

# תיקיית עבודה
WORKDIR /app

# תלויות
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# העתקת הקוד
COPY services ./services

# פורט לאפליקציה
EXPOSE 8000

# הפעלת uvicorn על הקובץ app.py שבתוך services/data_loader
CMD ["uvicorn", "data_loader.app:app", "--host", "0.0.0.0", "--port", "8000", "--proxy-headers"]
