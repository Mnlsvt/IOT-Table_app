// Local Server:

const express = require("express");
const bodyParser = require("body-parser");
const cors = require("cors");
const axios = require("axios");

const app = express();

app.use(bodyParser.urlencoded({ extended: true }));
app.use(bodyParser.json());
app.use(cors());

app.post("/sensor-data", async (req, res) => {
  const sensorData = req.body;

  // Check if the request body contains the "humidity" field
  if ("table_value" in sensorData) {
    // Process the "humidity" value here
    const table_value = sensorData.table_value;
    console.log(`Received table value: ${table_value}`);

    // Send data to MongoDB
    try {
      await axios.post("http://mnlsvtserver.ddns.net:4000/api/sensor-data", sensorData);
      res.send("Received table value");
    } catch (err) {
      console.error(err);
      res.status(500).send("Failed to save data to MongoDB");
    }
  } else {
    // Return an error response if "humidity" field is not present
    res.status(400).send("Missing or invalid table value");
  }
});

const port = 3000;

app.listen(port, () => {
  console.log(`Server running on port ${port}`);
});
