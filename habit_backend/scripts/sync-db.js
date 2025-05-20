const sequelize = require("../config/database");
const User = require("../models/user");
const Habit = require("../models/habit");

async function syncDatabase() {
  try {
    // Força a recriação das tabelas
    await sequelize.sync({ force: true });
    console.log("Banco de dados sincronizado com sucesso!");
    process.exit(0);
  } catch (error) {
    console.error("Erro ao sincronizar banco de dados:", error);
    process.exit(1);
  }
}

syncDatabase();
