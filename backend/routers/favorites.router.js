import express from "express";
import * as favoritesController from "../controllers/favorites.controller.js";

const favRoutes = express.Router();

favRoutes.post("/:userId", favoritesController.toggleFavorite);
favRoutes.get("/:userId", favoritesController.getFavorites);

export default favRoutes;
