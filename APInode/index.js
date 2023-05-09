const express = require('express');
const cors = require('cors');

const app = express();

app.use(cors());

const data = [
  { id: 1, name: 'John', age: 30 },
  { id: 2, name: 'Jane', age: 25 },
  { id: 3, name: 'Bob', age: 40 },
];

app.get('/api/data', (req, res) => {
  res.json(data);
});

const port = 4000;

app.listen(port, () => {
  console.log(`API server running on port ${port}`);
});
