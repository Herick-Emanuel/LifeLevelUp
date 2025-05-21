const Habit = require("../models/habit");
const User = require("../models/user");
const { validationResult } = require("express-validator");
const { body } = require("express-validator");

// Função para calcular a taxa de conclusão e atualizar o status
const updateHabitProgress = async (habit) => {
  const completionRate = (habit.progress / habit.goal) * 100;
  let status = "pending";

  if (completionRate >= 100) {
    status = "completed";
  } else if (habit.progress === 0) {
    status = "pending";
  } else if (completionRate < 100) {
    status = "pending";
  }

  // Arredonda a taxa de conclusão para 2 casas decimais
  const roundedCompletionRate = Math.round(completionRate * 100) / 100;

  await habit.update({
    completion_rate: roundedCompletionRate,
    status: status,
  });

  return habit;
};

const updateUserPointsAndLevel = async (
  user,
  pointsEarned = 10,
  pointsPerLevel = 100
) => {
  await user.update({
    points: user.points + pointsEarned,
  });
  const newLevel =
    Math.floor((user.points + pointsEarned) / pointsPerLevel) + 1;
  if (newLevel > user.level) {
    await user.update({ level: newLevel });
  }
};

exports.validateHabit = [
  body("name").notEmpty().withMessage("O nome do hábito é obrigatório"),
  body("frequency")
    .isIn(["Diário", "Semanal", "Mensal"])
    .withMessage("Frequência inválida"),
  body("goal")
    .isInt({ min: 1 })
    .withMessage("A meta deve ser um número inteiro positivo"),
  body("reminder")
    .isBoolean()
    .withMessage("Reminder deve ser verdadeiro ou falso"),
  body("quantidade_de_conclusoes").custom((value, { req }) => {
    if (req.body.frequency !== "Diário") {
      return true; // Não valida para semanal/mensal
    }
    if (value === undefined || value === null || value === "") {
      throw new Error(
        "A quantidade de conclusões é obrigatória para hábitos diários"
      );
    }
    if (typeof value === "string" && value.trim() === "") {
      throw new Error(
        "A quantidade de conclusões é obrigatória para hábitos diários"
      );
    }
    if (isNaN(Number(value)) || Number(value) < 1) {
      throw new Error(
        "A quantidade de conclusões deve ser um número inteiro positivo"
      );
    }
    return true;
  }),
  body("tempo_de_duracao_do_habito")
    .optional()
    .isInt({ min: 0 })
    .withMessage("O tempo de duração deve ser um número inteiro não negativo"),
];

exports.createHabit = async (req, res) => {
  try {
    const errors = validationResult(req);
    if (!errors.isEmpty()) {
      return res.status(400).json({
        message: "Erro de validação",
        errors: errors.array(),
      });
    }

    const {
      name,
      frequency,
      goal,
      reminder,
      reminder_time,
      reminder_days,
      tempo_de_duracao_do_habito,
    } = req.body;

    // Validação adicional
    if (!["Diário", "Semanal", "Mensal"].includes(frequency)) {
      return res.status(400).json({
        message: "Frequência inválida. Use: Diário, Semanal ou Mensal",
      });
    }

    if (typeof goal !== "number" || goal < 1) {
      return res.status(400).json({
        message: "Meta deve ser um número maior que zero",
      });
    }

    // Validação para quantidade_de_conclusoes
    if (
      frequency === "Diário" &&
      quantidade_de_conclusoes &&
      (typeof quantidade_de_conclusoes !== "number" ||
        quantidade_de_conclusoes < 1)
    ) {
      return res.status(400).json({
        message:
          "Quantidade de conclusões deve ser um número maior que zero para hábitos diários",
      });
    }

    // Validação para tempo_de_duracao_do_habito
    if (
      tempo_de_duracao_do_habito &&
      (typeof tempo_de_duracao_do_habito !== "number" ||
        tempo_de_duracao_do_habito < 0)
    ) {
      return res.status(400).json({
        message: "Tempo de duração deve ser um número não negativo",
      });
    }

    // Processa a hora do lembrete
    let parsedReminderTime = null;
    if (reminder_time) {
      try {
        // Verifica se já é uma string de hora válida
        if (
          typeof reminder_time === "string" &&
          /^([0-1]?[0-9]|2[0-3]):[0-5][0-9](:[0-5][0-9])?$/.test(reminder_time)
        ) {
          parsedReminderTime =
            reminder_time.length === 5 ? reminder_time + ":00" : reminder_time;
        } else {
          // Tenta converter para hora
          const date = new Date(reminder_time);
          if (!isNaN(date.getTime())) {
            parsedReminderTime = date.toTimeString().split(" ")[0];
          } else {
            return res.status(400).json({
              message: "Hora do lembrete inválida",
            });
          }
        }
      } catch (error) {
        return res.status(400).json({
          message: "Hora do lembrete inválida",
          error: error.message,
        });
      }
    }

    // Processa os dias do lembrete
    let parsedReminderDays = [];
    if (reminder_days) {
      if (Array.isArray(reminder_days)) {
        parsedReminderDays = reminder_days
          .map((day) => parseInt(day))
          .filter((day) => !isNaN(day) && day >= 0 && day <= 6);
      } else if (typeof reminder_days === "string") {
        try {
          const parsed = JSON.parse(reminder_days);
          if (Array.isArray(parsed)) {
            parsedReminderDays = parsed
              .map((day) => parseInt(day))
              .filter((day) => !isNaN(day) && day >= 0 && day <= 6);
          }
        } catch (e) {
          console.warn("Erro ao processar reminder_days:", e);
          parsedReminderDays = [];
        }
      }
    }

    let { quantidade_de_conclusoes } = req.body;
    if (
      quantidade_de_conclusoes === "" ||
      quantidade_de_conclusoes === undefined
    ) {
      quantidade_de_conclusoes = null;
    }

    const habitData = {
      name,
      frequency,
      goal,
      reminder: reminder || false,
      reminder_time: parsedReminderTime,
      reminder_days: parsedReminderDays,
      user_id: req.user.userId,
      quantidade_de_conclusoes:
        frequency === "Diário" ? quantidade_de_conclusoes : null,
      tempo_de_duracao_do_habito,
    };

    console.log("Criando hábito com dados:", habitData);

    try {
      const habit = await Habit.create(habitData);
      console.log("Hábito criado:", habit.toJSON());
      res.status(201).json(habit);
    } catch (error) {
      console.error("Erro ao criar hábito:", error);
      res.status(500).json({
        message: "Erro ao criar hábito",
        error: error.message,
      });
    }
  } catch (error) {
    console.error("Erro ao criar hábito:", error);
    res.status(500).json({
      message: "Erro ao criar hábito",
      error: error.message,
    });
  }
};

exports.getHabits = async (req, res) => {
  try {
    console.log("Buscando hábitos para o usuário:", req.user.userId);
    const habits = await Habit.findAll({
      where: { user_id: req.user.userId },
      order: [["createdAt", "DESC"]],
      attributes: {
        include: ["user_id"],
      },
    });

    console.log("Hábitos encontrados:", habits.length);
    res.json(habits);
  } catch (error) {
    console.error("Erro ao buscar hábitos:", error);
    res
      .status(500)
      .json({ message: "Erro ao buscar hábitos", error: error.message });
  }
};

exports.updateHabit = async (req, res) => {
  try {
    const { id } = req.params;
    const {
      name,
      frequency,
      goal,
      progress,
      reminder,
      reminder_time,
      reminder_days,
      quantidade_de_conclusoes,
      tempo_de_duracao_do_habito,
    } = req.body;

    const habit = await Habit.findOne({
      where: { id, user_id: req.user.userId },
    });

    if (!habit) {
      return res.status(404).json({ message: "Hábito não encontrado" });
    }

    // Validação para quantidade_de_conclusoes
    if (
      frequency === "Diário" &&
      quantidade_de_conclusoes &&
      (typeof quantidade_de_conclusoes !== "number" ||
        quantidade_de_conclusoes < 1)
    ) {
      return res.status(400).json({
        message:
          "Quantidade de conclusões deve ser um número maior que zero para hábitos diários",
      });
    }

    // Validação para tempo_de_duracao_do_habito
    if (
      tempo_de_duracao_do_habito &&
      (typeof tempo_de_duracao_do_habito !== "number" ||
        tempo_de_duracao_do_habito < 0)
    ) {
      return res.status(400).json({
        message: "Tempo de duração deve ser um número não negativo",
      });
    }

    await habit.update({
      name,
      frequency,
      goal,
      progress,
      reminder,
      reminder_time,
      reminder_days,
      quantidade_de_conclusoes:
        frequency === "Diário" ? quantidade_de_conclusoes : null,
      tempo_de_duracao_do_habito,
    });

    // Atualiza a taxa de conclusão e o status
    const updatedHabit = await updateHabitProgress(habit);

    res.json(updatedHabit);
  } catch (error) {
    console.error("Erro ao atualizar hábito:", error);
    res.status(500).json({ message: "Erro ao atualizar hábito" });
  }
};

exports.deleteHabit = async (req, res) => {
  try {
    const { id } = req.params;
    const habit = await Habit.findOne({
      where: { id, user_id: req.user.userId },
    });

    if (!habit) {
      return res.status(404).json({ message: "Hábito não encontrado" });
    }

    await habit.destroy();
    res.status(200).json({ message: "Hábito excluído com sucesso" });
  } catch (error) {
    console.error("Erro ao excluir hábito:", error);
    res.status(500).json({ message: "Erro ao excluir hábito" });
  }
};

exports.getHabitById = async (req, res) => {
  try {
    const { id } = req.params;
    const habit = await Habit.findOne({
      where: { id, user_id: req.user.userId },
    });

    if (!habit) {
      return res.status(404).json({ message: "Hábito não encontrado" });
    }

    res.json(habit);
  } catch (error) {
    console.error("Erro ao buscar hábito:", error);
    res.status(500).json({ message: "Erro ao buscar hábito" });
  }
};

exports.updateProgress = async (req, res) => {
  try {
    const { id } = req.params;
    const { progress } = req.body;

    const habit = await Habit.findOne({
      where: { id, user_id: req.user.userId },
    });

    if (!habit) {
      return res.status(404).json({ message: "Hábito não encontrado" });
    }

    await habit.update({ progress });
    const updatedHabit = await updateHabitProgress(habit);

    // Verifica se o usuário completou o hábito
    if (progress >= habit.goal) {
      const user = await User.findByPk(req.user.userId);
      await updateUserPointsAndLevel(user);
    }

    res.json(updatedHabit);
  } catch (error) {
    console.error("Erro ao atualizar progresso:", error);
    res
      .status(500)
      .json({ message: "Erro ao atualizar progresso", error: error.message });
  }
};

exports.updateUserPointsAndLevel = updateUserPointsAndLevel;
