from flask import Flask, request, jsonify
import requests

app = Flask(__name__)

API_KEY = "8957568db7e84747c64e6d1de15f637b"  # Replace with a valid OpenWeatherMap API Key
WEATHER_API_URL = "https://api.openweathermap.org/data/2.5/weather"

@app.route("/", methods=["GET"])
def home():
    return """
        <h2>Enter City Name</h2>
        <form action='/weather' method='get'>
            <input type='text' name='city' placeholder='City'>
            <button type='submit'>Get Weather</button>
        </form>
    """

@app.route("/weather", methods=["GET"])
def get_weather():
    city = request.args.get("city")
    if not city:
        return jsonify({"error": "City parameter is required"}), 400

    params = {"q": city, "appid": API_KEY, "units": "metric"}
    response = requests.get(WEATHER_API_URL, params=params)

    if response.status_code == 200:
        weather = response.json()
        return f"""
            <h3>Weather in {city}:</h3>
            <p>Temperature: {weather['main']['temp']}°C</p>
            <p>Condition: {weather['weather'][0]['description']}</p>
            <a href="/">Back</a>
        """
    else:
        return "<h3>City not found</h3><a href='/'>Back</a>"

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000)
