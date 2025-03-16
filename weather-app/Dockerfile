FROM python:3.9
WORKDIR /app

# Copy application files
COPY weather-app.py /app/
COPY templates /app/templates/
COPY static /app/static/

# Install dependencies
RUN pip install flask requests

CMD ["python", "weather-app.py"]
