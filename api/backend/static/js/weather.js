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
        
        // Map weather codes to emoji icons (adding night variants)
        const weatherIcons = {
            '01d': '☀️', '01n': '🌙', // clear sky
            '02d': '⛅', '02n': '☁️', // few clouds
            '03d': '☁️', '03n': '☁️', // scattered clouds
            '04d': '☁️', '04n': '☁️', // broken clouds
            '09d': '🌧️', '09n': '🌧️', // shower rain
            '10d': '🌦️', '10n': '🌧️', // rain
            '11d': '⛈️', '11n': '⛈️', // thunderstorm
            '13d': '🌨️', '13n': '🌨️', // snow
            '50d': '🌫️', '50n': '🌫️', // mist
        };
        
        const iconCode = data.weather[0].icon;
        document.getElementById('weather-icon').textContent = weatherIcons[iconCode] || '🌡️';

        // Add feels like temperature
        // document.getElementById('weather-feels-like').textContent = 
        //     `Feels like ${Math.round(data.main.feels_like)}°F`;
    } catch (error) {
        console.error('Error fetching weather:', error);
        document.getElementById('weather-container').innerHTML = `
            <p id="weather-temp">Weather unavailable</p>
            <p id="weather-desc">Please try again later</p>
        `;
    }
}

// Fetch weather immediately and then every 30 minutes
fetchWeather();
setInterval(fetchWeather, 30 * 60 * 1000);