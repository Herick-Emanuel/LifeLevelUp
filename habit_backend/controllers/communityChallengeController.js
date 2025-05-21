const CommunityChallenge = require("../models/communityChallenge");
const ChallengeProgress = require("../models/challengeProgress");
const User = require("../models/user");
const { Op } = require("sequelize");

exports.listChallenges = async (req, res) => {
  try {
    const now = new Date();
    const challenges = await CommunityChallenge.findAll({
      where: {
        start_date: { [Op.lte]: now },
        end_date: { [Op.gte]: now },
        status: "active",
      },
      order: [["start_date", "ASC"]],
    });
    res.json(challenges);
  } catch (error) {
    res.status(500).json({ message: "Erro ao listar desafios", error });
  }
};

exports.joinChallenge = async (req, res) => {
  try {
    const user = await User.findByPk(req.user.userId);
    const challenge = await CommunityChallenge.findByPk(req.params.id);
    if (!challenge || challenge.status !== "active") {
      return res
        .status(404)
        .json({ message: "Desafio não encontrado ou inativo" });
    }
    if (user.points < challenge.entry_cost) {
      return res
        .status(400)
        .json({ message: "Pontos insuficientes para participar" });
    }
    // Verifica se já está participando
    const existing = await ChallengeProgress.findOne({
      where: { user_id: user.id, community_challenge_id: challenge.id },
    });
    if (existing) {
      return res
        .status(400)
        .json({ message: "Usuário já está participando deste desafio" });
    }
    // Gasta pontos
    user.points -= challenge.entry_cost;
    await user.save();
    // Cria progresso
    await ChallengeProgress.create({
      user_id: user.id,
      community_challenge_id: challenge.id,
      status: "in_progress",
    });
    res.json({ message: "Participação confirmada!" });
  } catch (error) {
    res.status(500).json({ message: "Erro ao participar do desafio", error });
  }
};

exports.completeChallenge = async (req, res) => {
  try {
    const user = await User.findByPk(req.user.userId);
    const challenge = await CommunityChallenge.findByPk(req.params.id);
    const progress = await ChallengeProgress.findOne({
      where: { user_id: user.id, community_challenge_id: challenge.id },
    });
    if (!progress || progress.status !== "in_progress") {
      return res
        .status(400)
        .json({ message: "Usuário não está participando ou já concluiu" });
    }
    // Premiação
    user.points += challenge.reward_points;
    // Premiação de emblema
    if (challenge.reward_badge) {
      // Simples: adicionar badge ao campo achievements, se existir
      // Aqui, apenas um exemplo de lógica (ajuste conforme seu sistema de conquistas)
      // await user.addAchievement(challenge.reward_badge); // Se existir relação
    }
    // Premiação de item cosmético
    if (challenge.reward_cosmetic) {
      // await user.addCustomizationItem(challenge.reward_cosmetic); // Se existir relação
    }
    await user.save();
    progress.status = "completed";
    progress.completed_at = new Date();
    await progress.save();
    res.json({
      message: "Desafio concluído! Pontos recebidos.",
      reward: challenge.reward_points,
    });
  } catch (error) {
    res.status(500).json({ message: "Erro ao concluir desafio", error });
  }
};

exports.userChallenges = async (req, res) => {
  try {
    const progresses = await ChallengeProgress.findAll({
      where: { user_id: req.user.userId },
      include: [CommunityChallenge],
    });
    res.json(progresses);
  } catch (error) {
    res
      .status(500)
      .json({ message: "Erro ao buscar desafios do usuário", error });
  }
};

exports.createChallenge = async (req, res) => {
  try {
    const challenge = await CommunityChallenge.create(req.body);
    res.status(201).json(challenge);
  } catch (error) {
    res.status(500).json({ message: "Erro ao criar desafio", error });
  }
};

exports.updateChallenge = async (req, res) => {
  try {
    const challenge = await CommunityChallenge.findByPk(req.params.id);
    if (!challenge) {
      return res.status(404).json({ message: "Desafio não encontrado" });
    }
    await challenge.update(req.body);
    res.json(challenge);
  } catch (error) {
    res.status(500).json({ message: "Erro ao atualizar desafio", error });
  }
};

exports.deleteChallenge = async (req, res) => {
  try {
    const challenge = await CommunityChallenge.findByPk(req.params.id);
    if (!challenge) {
      return res.status(404).json({ message: "Desafio não encontrado" });
    }
    await challenge.destroy();
    res.json({ message: "Desafio excluído com sucesso" });
  } catch (error) {
    res.status(500).json({ message: "Erro ao excluir desafio", error });
  }
};
