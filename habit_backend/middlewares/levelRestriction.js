const User = require("../models/user");

module.exports = (minLevel) => async (req, res, next) => {
  const user = await User.findByPk(req.user.userId);
  if (!user || user.level < minLevel) {
    return res.status(403).json({ message: `Requer nível mínimo ${minLevel}` });
  }
  next();
};
