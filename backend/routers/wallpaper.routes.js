import express from "express";
import * as wallpaperController from "../controllers/wallpaper.controller.js";

const wallpaperRouter = express.Router();

wallpaperRouter.get("/search", wallpaperController.searchWallpapers);
wallpaperRouter.get("/curated", wallpaperController.getCuratedWallpapers);

export default wallpaperRouter;
