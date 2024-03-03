const express = require('express');
const bodyParser = require('body-parser');
const cors = require('cors');

const app = express();
const port = 3000;

app.use(bodyParser.json());
app.use(cors());

let dataList = [];

// Create
app.post('/api/create', (req, res) => {
  const data = req.body.data;
  console.log(data)
  dataList.push(data);
  res.status(201).json({ message: 'Data created successfully' });
});

// Read
app.get('/api/read', (req, res) => {
  res.json(dataList);
});

// Update
app.put('/api/update/:id', (req, res) => {
  // Implementation for updating data
  const id = req.params.id;
  // Your update logic goes here
  res.json({ message: 'Data updated successfully' });
});

// Delete
app.delete('/api/delete/:id', (req, res) => {
  // Implementation for deleting data
  const id = req.params.id;
  // Your delete logic goes here
  res.json({ message: 'Data deleted successfully' });
});

app.listen(port, () => {
  console.log(`Server is running on port ${port}`);
});


