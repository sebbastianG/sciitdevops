from flask import Flask, request, render_template
import requests

app = Flask(__name__)

API_KEY = "8957568db7e84747c64e6d1de15f637b"
WEATHER_API_URL = "https://api.openweathermap.org/data/2.5/weather"

@app.route("/", methods=["GET"])
def home():
    return render_template("index.html")

@app.route("/weather", methods=["GET"])
def get_weather():
    city = request.args.get("city")
    if not city:
        return render_template("index.html", error="City is required.")

    params = {"q": city, "appid": API_KEY, "units": "metric"}
    response = requests.get(WEATHER_API_URL, params=params)

    if response.status_code == 200:
        weather_data = response.json()
        weather = {
            "temp": weather_data["main"]["temp"],
            "description": weather_data["weather"][0]["description"],
        }
        icon = weather_data["weather"][0]["icon"]
        return render_template("index.html", city=city, weather=weather, icon=icon)

    return render_template("index.html", error="City not found.")

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000)
