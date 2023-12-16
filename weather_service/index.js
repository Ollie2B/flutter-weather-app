const express = require('express');
const axios = require('axios');

const app = express();
const port = 3000;

app.use(express.json());

app.get('/', (_, res) => {
  res.send('Welcome to weather service API')
});

app.get('/weather', async (req, res) => {
  const { city } = req.query;

  if (!city) {
    return res.status(400).json({ error: 'City name is required' });
  }

  try {
    // Api config
    const apiKey = 'API Key';
    const apiUrl = `http://api.openweathermap.org/data/2.5/weather?q=${city}&appid=${apiKey}&units=metric`;

    const response = await axios.get(apiUrl);
    const weatherData = response.data;

    const isDay = (weatherData.dt > weatherData.sys.sunrise && weatherData.dt < weatherData.sys.sunset) 

    // Extract key weather details
    const simplifiedResponse = {
      temperature: weatherData.main.temp,
      tempMin: weatherData.main.temp_min,
      tempMax: weatherData.main.temp_max,
      isDay: isDay,
      condition: weatherData.weather[0].main,
      description: weatherData.weather[0].description,
      iconCode: weatherData.weather[0].icon,
    };

    res.status(200).json(simplifiedResponse);
  } catch (error) {
    console.error('Error fetching weather data:', error.message);
    res.status(500).json({ error: 'Internal server error' });
  }
});

app.listen(port, () => {
  console.log(`Server started on http://localhost:${port}`);
});