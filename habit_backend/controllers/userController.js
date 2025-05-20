const User = require("../models/user");

exports.getUserProfile = async (req, res) => {
  try {
    console.log("Buscando perfil do usuário:", req.user.userId);
    const user = await User.findByPk(req.user.userId, {
      attributes: ["id", "name", "email", "level", "points"],
    });

    if (!user) {
      return res.status(404).json({ message: "Usuário não encontrado" });
    }

    console.log("Perfil encontrado:", user);
    res.json(user);
  } catch (error) {
    console.error("Erro ao obter perfil do usuário:", error);
    res
      .status(500)
      .json({
        message: "Erro ao obter perfil do usuário",
        error: error.message,
      });
  }
};
