import express from "express";
import cors from "cors";
import dotenv from "dotenv";
import wallpaperRoutes from "./routers/wallpaper.routes.js";

dotenv.config();

const app = express();
app.use(express.json());
app.use(cors());

app.use("/api/wallpapers", wallpaperRoutes);

const PORT = process.env.PORT || 3000;

app.listen(PORT, () => {
  console.log("Server is running on port " + PORT);
});

app.get("/", (req, res) => {
  res.send("Hello from Node API Server :)");
});
