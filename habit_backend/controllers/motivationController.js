const MotivationMessage = require("../models/motivationMessage");

exports.addMessage = async (req, res) => {
  try {
    const { message } = req.body;
    const newMessage = await MotivationMessage.create({
      message,
      user_id: req.user.userId,
    });
    res.status(201).json(newMessage);
  } catch (error) {
    console.error("Erro ao adicionar mensagem:", error);
    res
      .status(500)
      .json({ message: "Erro ao adicionar mensagem", error: error.message });
  }
};

exports.getMessages = async (req, res) => {
  try {
    console.log("Buscando mensagens para o usuário:", req.user.userId);
    const messages = await MotivationMessage.findAll({
      where: { user_id: req.user.userId },
      order: [["createdAt", "DESC"]],
    });
    console.log("Mensagens encontradas:", messages.length);
    res.json(messages);
  } catch (error) {
    console.error("Erro ao obter mensagens:", error);
    res
      .status(500)
      .json({ message: "Erro ao obter mensagens", error: error.message });
  }
};

exports.deleteMessage = async (req, res) => {
  try {
    const { id } = req.params;
    const message = await MotivationMessage.findOne({
      where: { id, user_id: req.user.userId },
    });

    if (!message) {
      return res.status(404).json({ message: "Mensagem não encontrada" });
    }

    await message.destroy();
    res.status(200).json({ message: "Mensagem excluída com sucesso" });
  } catch (error) {
    console.error("Erro ao excluir mensagem:", error);
    res
      .status(500)
      .json({ message: "Erro ao excluir mensagem", error: error.message });
  }
};
