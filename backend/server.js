// server.js

const express = require("express");
const bodyParser = require("body-parser");
const mongoose = require("mongoose");

const app = express();
const PORT = 3000;

app.use(bodyParser.json());

mongoose
  .connect("mongodb://127.0.0.1/SignUp_flutter")
  .then(() => console.log("Success"));

const userSchema = new mongoose.Schema({
  username: String,
  email: String,
  password: String,
});

const User = mongoose.model("user", userSchema);

app.post("/signup", async (req, res) => {
  const { username, email, password } = req.body;
  console.log(username);

  try {
    const newUser = new User({ username, email, password });
    await newUser.save();
    res.status(200).send("Signup successful");
  } catch (error) {
    console.error(error);
    res.status(500).send("Internal Server Error");
  }
});

app.get("/users", async (req, res) => {
  try {
    const users = await User.find().select("username");
    const usernames = users.map((user) => user.username);
    // console.log(usernames);
    res.status(200).json(usernames);
  } catch (error) {
    console.error(error);
    res.status(500).send("Internal Server Error");
  }
});

app.listen(PORT, () => {
  console.log(`Server is running on http://localhost:${PORT}`);
});
