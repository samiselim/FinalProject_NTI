const express = require("express");
const cors = require('cors');
const mongoose = require("mongoose");
const port = 3001;
const uri = process.env.MONGO_URL;
const routes = require("./routes");

main().catch((err) => console.log(err));

async function main() {
  await mongoose.connect(uri, {
    
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
