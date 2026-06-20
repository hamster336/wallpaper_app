import axios from "axios";
import dotenv from "dotenv";

dotenv.config();

const PEXELS_API_KEY = process.env.API_KEY;
const PEXELS_BASE_URL = "https://api.pexels.com/v1";

const pexelsAPI = axios.create({
  baseURL: PEXELS_BASE_URL,
  headers: {
    Authorization: PEXELS_API_KEY,
  },
});

// Search wallpapers
export const searchWallpapers = async (query, page = 1, per_page = 20) => {
  try {
    const response = await pexelsAPI.get('/search', {
      params: {
        query,
        page,
        per_page,
        orientation: 'portrait', // mobile wallpaper ratio
      },
    });
    return response.data;
  } catch (error) {
    console.log('Pexels API error: ' + error.message);
    throw error;
  }
};

// Get curated wallpapers
export const getCuratedWallpapers = async (page = 1, per_page = 20) => {
  try {
    const response = await pexelsAPI.get('/curated', {
      params: {
        page,
        per_page,
        orientation: 'portrait',
      },
    });
    return response.data;
  } catch (error) {
    console.log('Pexels API error: ' + error.message);
    throw error;
  }
};