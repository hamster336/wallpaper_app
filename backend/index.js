import express from "express";
import cors from "cors";
import dotenv from "dotenv";
import connnectDB from "./config/db.js";
import wallpaperRoutes from "./routers/wallpaper.routes.js";
import favRoutes from "./routers/favorites.router.js";

dotenv.config();
connnectDB();

const app = express();
app.use(express.json());
app.use(cors());

app.use("/api/wallpapers", wallpaperRoutes);
app.use("/api/favorites", favRoutes);

const PORT = process.env.PORT || 3000;

app.listen(PORT, () => {
  console.log("Server is running on port " + PORT);
});

app.get("/", (req, res) => {
  res.send("Hello from Node API Server :)");
});
