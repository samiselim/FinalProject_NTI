const express = require("express");
const cors = require('cors');
const mongoose = require("mongoose");
const port = 3000;
const routes = require("./routes");

main().catch((err) => console.log(err));

async function main() {
  await mongoose.connect("mongodb://root:123@mongo:27017/todos?authSource=admin", {
    
    useUnifiedTopology: true,
    useNewUrlParser: true,
  });
  const app = express();
  
  // Configure CORS
  app.use(cors({
    origin: '*',
    methods: 'GET,POST,OPTIONS,DELETE,PUT',
    allowedHeaders: 'Origin,X-Requested-With,Content-Type,Accept,Authorization',
    credentials: true
  }));
  
  app.use(express.json());
  app.use("/api", routes);

  app.listen(port, () => {
    console.log(`Server is listening on port: ${port}`);
  });
}
