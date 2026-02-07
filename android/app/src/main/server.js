const express = require('express');
const app = express();
const PORT = 3000;

// Ye tumhara sample data hai jo Explore screen par dikhega
const locations = [
  {
    id: "1",
    name: "Amer Fort",
    lat: 26.9855,
    lng: 75.8513,
    capacity: 5000,
    current_crowd: 4200,
    description: "Beautiful historic fort with elephant rides.",
    status: "Crowded"
  },
  {
    id: "2",
    name: "Hawa Mahal",
    lat: 26.9239,
    lng: 75.8267,
    capacity: 2000,
    current_crowd: 850,
    description: "Palace of Winds with iconic windows.",
    status: "Peaceful"
  },
  {
    id: "3",
    name: "Jal Mahal",
    lat: 26.9539,
    lng: 75.8462,
    capacity: 1500,
    current_crowd: 1200,
    description: "Stunning palace in the middle of Man Sagar Lake.",
    status: "Moderate"
  }
];

app.get('/api/locations', (req, res) => {
  console.log("Flutter app is requesting data...");
  res.json(locations);
});

// 0.0.0.0 isliye taaki network ke devices connect ho sakein
app.listen(PORT, '0.0.0.0', () => {
  console.log(`✅ Server is running!`);
  console.log(`🔗 Local: http://localhost:${PORT}/api/locations`);
});