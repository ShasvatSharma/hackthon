const express = require('express');
const app = express();
const PORT = 3000;

const locations = [
  {
    id: "1",
    name: "Amer Fort",
    lat: 26.9855,
    lng: 75.8513,
    capacity: 5000,
    current_crowd: 4200,
    description: "Historic fort.",
    status: "Crowded"
  },
  {
    id: "2",
    name: "Hawa Mahal",
    lat: 26.9239,
    lng: 75.8267,
    capacity: 2000,
    current_crowd: 800,
    description: "Palace of Winds.",
    status: "Peaceful"
  }
];

app.get('/api/locations', (req, res) => {
  console.log("Flutter app is asking for data...");
  res.json(locations);
});

app.listen(PORT, '0.0.0.0', () => {
  console.log(`✅ Server is running on port ${PORT}`);
});