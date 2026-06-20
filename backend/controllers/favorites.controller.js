import User from "../models/user.model.js";

export const toggleFavorite = async (req, res) => {
  try {
    const { userId } = req.params;
    const { pexelsId, url, photographer, title } = req.body;

    if (!pexelsId || !url) {
      return res.status(400).json({ message: "pexelId and url required" });
    }

    let user = await User.findOne({ userId });

    if (!user) {
      user = new User({ userId, favorites: [] });
    }

    // check if already favorite
    const favoriteIndex = user.favorites.findIndex(
      (fav) => fav.pexelsId === pexelsId,
    );

    if (favoriteIndex !== -1) {
      // remove from favorite
      user.favorites.splice(favoriteIndex, 1);
      await user.save();
      return res.status(200).json({
        message: "Removed from favorites",
        isFavorite: false,
        favorites: user.favorites,
      });
    } else {
      // Add to favorites
      user.favorites.push({ pexelsId, url, photographer, title });
      await user.save();
      return res.status(201).json({
        message: "Added to favorites",
        isFavorite: true,
        favorites: user.favorites,
      });
    }
  } catch (e) {
    res.status(500).json({ message: e.message });
  }
};

// Get favorites
export const getFavorites = async (req, res) => {
  try {
    const { userId } = req.params;

    const user = await User.findOne({ userId });

    if (!user) {
      return res.status(200).json([]);
    }

    res.status(200).json(user.favorites);
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};
