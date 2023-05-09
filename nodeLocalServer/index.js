const express = require("express");
const bodyParser = require("body-parser");
const cors = require("cors");

const app = express();

app.use(bodyParser.urlencoded({ extended: true }));
app.use(bodyParser.json());
app.use(cors());

app.post("/sensor-data", (req, res) => {
  const sensorData = req.body;
  
  // Check if the request body contains the "humidity" field
  if ("humidity" in sensorData) {
    // Process the "humidity" value here
    const humidity = sensorData.humidity;
    console.log(`Received humidity value: ${humidity}`);
    res.send("Received humidity value");
  } else {
    // Return an error response if "humidity" field is not present
    res.status(400).send("Missing or invalid humidity value");
  }
});

const port = 3000;

app.listen(port, () => {
  console.log(`Server running on port ${port}`);
});