const WEATHER_API_KEY = 'your_api_key_here';
const BETHESDA_LAT = '38.9847';
const BETHESDA_LON = '-77.0947';

async function fetchWeather() {
    try {
        const response = await fetch('/weather');
        const data = await response.json();

        // Update DOM elements
        const temp = Math.round(data.main.temp);
        document.getElementById('weather-temp').textContent = `${temp}°F`;
        document.getElementById('weather-desc').textContent = data.weather[0].description;
        
        // Map weather codes to emoji icons
        const weatherIcons = {
            '01d': '☀️', // clear sky
            '02d': '⛅', // few clouds
            '03d': '☁️', // scattered clouds
            '04d': '☁️', // broken clouds
            '09d': '🌧️', // shower rain
            '10d': '🌦️', // rain
            '11d': '⛈️', // thunderstorm
            '13d': '🌨️', // snow
            '50d': '🌫️', // mist
        };
        
        const iconCode = data.weather[0].icon;
        document.getElementById('weather-icon').textContent = weatherIcons[iconCode] || '🌡️';
    } catch (error) {
        console.error('Error fetching weather:', error);
        document.getElementById('weather-temp').textContent = 'Weather unavailable';
        document.getElementById('weather-desc').textContent = 'Please try again later';
    }
}

// Fetch weather immediately and then every 30 minutes
fetchWeather();
setInterval(fetchWeather, 30 * 60 * 1000);