import * as pexelsService from "../services/pexels.services.js";

// Search wallpapers
export const searchWallpapers = async (req, res) => {
  try {
    const { query, page = 1 } = req.query;

    if (!query) {
      return res.status(400).json({ message: "Query parameter required" });
    }

    const wallpapers = await pexelsService.searchWallpapers(query, page);
    res.status(200).json(wallpapers);
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};

// Get curated wallpapers
export const getCuratedWallpapers = async (req, res) => {
  try {
    const { page = 1 } = req.query;
    const wallpapers = await pexelsService.getCuratedWallpapers(page);
    res.status(200).json(wallpapers);
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};
