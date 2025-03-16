from flask import Flask, request, render_template
import requests

app = Flask(__name__)

API_KEY = "8957568db7e84747c64e6d1de15f637b"
WEATHER_API_URL = "https://api.openweathermap.org/data/2.5/weather"

@app.route("/", methods=["GET", "POST"])
def home():
    weather = None
    city = None

    if request.method == "POST":
        city = request.form.get("city")
        if city:
            params = {"q": city, "appid": API_KEY, "units": "metric"}
            response = requests.get(WEATHER_API_URL, params=params)

            if response.status_code == 200:
                weather = response.json()
            else:
                weather = {"error": "City not found"}

    return render_template("index.html", weather=weather, city=city)

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000)
