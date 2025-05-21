const User = require("../models/user");

module.exports = async (req, res, next) => {
  const user = await User.findByPk(req.user.userId);
  if (!user || !user.is_admin) {
    return res
      .status(403)
      .json({ message: "Acesso restrito a administradores" });
  }
  next();
};
