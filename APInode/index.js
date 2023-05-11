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
mongoose.connect("mongodb://mnlsvtserver.ddns.net:27017/IOT-FREE", { useNewUrlParser: true });

// Create a schema for the sensor data
const sensorDataSchemaTABLES = new mongoose.Schema({
  storeId: {
    type: Number,
    required: true,
  },
  tableId: {
    type: Number,
    required: true,
  },
  isFree: {
    type: String,
    enum: ['yes', 'no'],
    default: 'yes',
  },
});

// Create a model for the sensor data
const SensorData = mongoose.model("SensorData", sensorDataSchemaTABLES);

// API endpoint for receiving sensor data
app.post("/api/sensor-data", (req, res) => {
  const sensorData = req.body;

  // Check if the request body contains the required fields
  if ("isFree" in sensorData && "storeId" in sensorData && "tableId" in sensorData) {
    // Find the existing SensorData object in the database with matching storeId and tableId
    SensorData.findOne({ storeId: sensorData.storeId, tableId: sensorData.tableId }, (err, existingData) => {
      if (err) {
        console.error(err);
        res.status(500).send("Error checking for existing sensor data");
      } else {
        if (!existingData) {
          // If no existing SensorData object found, create a new one
          const newData = new SensorData({
            storeId: sensorData.storeId,
            tableId: sensorData.tableId,
            isFree: sensorData.isFree
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
        } else if (existingData.isFree !== sensorData.isFree) {
          // If an existing SensorData object found and the value is different, update its values
          existingData.isFree = sensorData.isFree;
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




// API endpoint for retrieving the sensor data for a specific table
app.get("/api/sensor-data/:storeId/:tableId", (req, res) => {
  const { storeId, tableId } = req.params;
  
  // Find the SensorData object for the given storeId and tableId
  SensorData.findOne({ storeId, tableId }, (err, data) => {
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




const port = 4000;

app.listen(port, () => {
  console.log(`API server running on port ${port}`);
});
