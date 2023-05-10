// API:

const express = require("express");
const bodyParser = require("body-parser");
const cors = require("cors");
const mongoose = require("mongoose");

const app = express();

app.use(bodyParser.urlencoded({ extended: true }));
app.use(bodyParser.json());
app.use(cors());

// Connect to MongoDB
mongoose.connect("mongodb://mnlsvtserver.ddns.net:27017/IOT-TABLES", { useNewUrlParser: true });

// Create a schema for the sensor data
const sensorDataSchemaTABLES = new mongoose.Schema({
  table_value: String,
  timestamp: {
    type: Date,
    default: Date.now,
  },
});

// Create a model for the sensor data
const SensorData = mongoose.model("SensorData", sensorDataSchemaTABLES);

// API endpoint for receiving sensor data
app.post("/api/sensor-data", (req, res) => {
  const sensorData = req.body;

  // Check if the request body contains the required fields
  if ("table_value" in sensorData) {
    // Check if a SensorData object already exists for the given table_value
    SensorData.findOne({ table_value: sensorData.table_value }, (err, existingData) => {
      if (err) {
        console.error(err);
        res.status(500).send("Error checking for existing sensor data");
      } else {
        if (!existingData) {
          // If no existing SensorData object found, create a new one
          const newData = new SensorData({
            table_value: sensorData.table_value
          });
          newData.save((err, data) => {
            if (err) {
              console.error(err);
              res.status(500).send("Error saving sensor data");
            } else {
              console.log("New sensor data saved to database");
              res.send("New sensor data received and saved");
            }
          });
        } else if (existingData.table_value !== sensorData.table_value) {
          // If an existing SensorData object found and the value is different, update its values
          existingData.table_value = sensorData.table_value;
          existingData.save((err, data) => {
            if (err) {
              console.error(err);
              res.status(500).send("Error updating sensor data");
            } else {
              console.log("Sensor data updated in database");
              res.send("Sensor data received and updated");
            }
          });
        } else {
          // If the value is the same, do nothing
          console.log("Sensor data already up-to-date");
          res.send("Sensor data already up-to-date");
        }
      }
    });
    
    
    } else {
      res.status(400).send("Invalid sensor data");
  }
});



// API endpoint for retrieving the latest sensor data
app.get("/api/sensor-data", (req, res) => {
  // Find the latest SensorData object in the database
  SensorData.findOne({}, {}, { sort: { 'createdAt' : -1 } }, (err, data) => {
    if (err) {
      console.error(err);
      res.status(500).send("Error retrieving sensor data");
    } else if (!data) {
      res.status(404).send("Sensor data not found");
    } else {
      res.json(data);
    }
  });
});




/*
// API endpoint for retrieving sensor data
app.get("/api/sensor-data", (req, res) => {
  // Find all SensorData objects in the database and return them as a JSON response
  SensorData.find((err, data) => {
    if (err) {
      console.error(err);
      res.status(500).send("Error retrieving sensor data");
    } else {
      res.json(data);
    }
  });
});
*/
const port = 4000;

app.listen(port, () => {
  console.log(`API server running on port ${port}`);
});
