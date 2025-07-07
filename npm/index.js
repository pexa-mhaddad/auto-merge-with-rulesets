const express = require('express');
const _ = require('lodash');

const app = express();
app.get('/', (req, res) => {
  console.log('Something Something Dark Side');
  res.send('Hello World');
});

module.exports = app;