const HabitCompletion = require("../models/habit_completion");
const Habit = require("../models/habit");
const { Op } = require("sequelize");
const sequelize = require("sequelize");
const { updateUserPointsAndLevel } = require("./habitController");

exports.createCompletion = async (req, res) => {
  try {
    const { habit_id, tempo_gasto } = req.body;

    // Verifica se o hábito existe
    const habit = await Habit.findByPk(habit_id);
    if (!habit) {
      return res.status(404).json({ message: "Hábito não encontrado" });
    }

    // Verifica se já atingiu o limite de conclusões para o dia (apenas para hábitos diários)
    if (habit.frequency === "Diário" && habit.quantidade_de_conclusoes) {
      const today = new Date();
      today.setHours(0, 0, 0, 0);
      const tomorrow = new Date(today);
      tomorrow.setDate(tomorrow.getDate() + 1);

      const completionsToday = await HabitCompletion.count({
        where: {
          habit_id,
          completion_date: {
            [Op.between]: [today, tomorrow],
          },
        },
      });

      if (completionsToday >= habit.quantidade_de_conclusoes) {
        return res.status(400).json({
          message: `Limite de ${habit.quantidade_de_conclusoes} conclusões por dia atingido`,
        });
      }
    }

    const completion = await HabitCompletion.create({
      habit_id,
      tempo_gasto,
    });

    // Atualiza o progresso do hábito
    await habit.increment("progress");
    await habit.reload();
    if (habit.progress >= habit.goal) {
      const user = await require("../models/user").findByPk(habit.user_id);
      await updateUserPointsAndLevel(user);
    }

    res.status(201).json(completion);
  } catch (error) {
    console.error("Erro ao criar conclusão:", error);
    res.status(500).json({ message: "Erro ao criar conclusão" });
  }
};

exports.getCompletions = async (req, res) => {
  try {
    const { habit_id } = req.params;
    const completions = await HabitCompletion.findAll({
      where: { habit_id },
      order: [["completion_date", "DESC"]],
    });
    res.json(completions);
  } catch (error) {
    console.error("Erro ao buscar conclusões:", error);
    res.status(500).json({ message: "Erro ao buscar conclusões" });
  }
};

exports.getCompletionStats = async (req, res) => {
  try {
    const { habit_id } = req.params;
    const completions = await HabitCompletion.findAll({
      where: { habit_id },
      attributes: [
        [sequelize.fn("AVG", sequelize.col("tempo_gasto")), "media_tempo"],
        [sequelize.fn("MIN", sequelize.col("tempo_gasto")), "min_tempo"],
        [sequelize.fn("MAX", sequelize.col("tempo_gasto")), "max_tempo"],
        [sequelize.fn("COUNT", sequelize.col("id")), "total_conclusoes"],
      ],
    });

    const stats = completions[0];
    if (!stats) {
      return res.json({
        media_tempo: 0,
        min_tempo: 0,
        max_tempo: 0,
        total_conclusoes: 0,
      });
    }

    // Converte os valores para números
    const response = {
      media_tempo: parseFloat(stats.getDataValue("media_tempo")) || 0,
      min_tempo: parseInt(stats.getDataValue("min_tempo")) || 0,
      max_tempo: parseInt(stats.getDataValue("max_tempo")) || 0,
      total_conclusoes: parseInt(stats.getDataValue("total_conclusoes")) || 0,
    };

    res.json(response);
  } catch (error) {
    console.error("Erro ao buscar estatísticas:", error);
    res.status(500).json({ message: "Erro ao buscar estatísticas" });
  }
};
