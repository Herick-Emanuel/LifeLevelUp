const { DataTypes } = require("sequelize");
const sequelize = require("../config/database");
const User = require("./user");

const Habit = sequelize.define(
  "Habit",
  {
    name: { type: DataTypes.STRING, allowNull: false },
    frequency: {
      type: DataTypes.STRING,
      allowNull: false,
      validate: {
        isIn: [["Diário", "Semanal", "Mensal"]],
      },
    },
    goal: { type: DataTypes.INTEGER, allowNull: false },
    progress: { type: DataTypes.INTEGER, defaultValue: 0 },
    completion_rate: {
      type: DataTypes.DOUBLE,
      allowNull: false,
      defaultValue: 0.0,
    },
    status: {
      type: DataTypes.STRING,
      allowNull: false,
      defaultValue: "pending",
      validate: {
        isIn: [["completed", "pending", "failed"]],
      },
    },
    reminder: { type: DataTypes.BOOLEAN, defaultValue: false },
    reminder_time: {
      type: DataTypes.TIME,
      allowNull: true,
    },
    reminder_days: {
      type: DataTypes.ARRAY(DataTypes.INTEGER),
      allowNull: true,
      defaultValue: [],
      validate: {
        isValidDays(value) {
          if (value && Array.isArray(value)) {
            if (!value.every((day) => day >= 0 && day <= 6)) {
              throw new Error("Os dias devem estar entre 0 e 6");
            }
          }
        },
      },
    },
    quantidade_de_conclusoes: {
      type: DataTypes.INTEGER,
      allowNull: true,
      validate: {
        min: 1,
      },
    },
    tempo_de_duracao_do_habito: {
      type: DataTypes.INTEGER, // Armazenado em minutos
      allowNull: true,
      validate: {
        min: 0,
      },
    },
    user_id: {
      type: DataTypes.INTEGER,
      allowNull: false,
      references: {
        model: User,
        key: "id",
      },
    },
  },
  {
    tableName: "habit",
    underscored: true,
  }
);

Habit.belongsTo(User, { foreignKey: "user_id" });
User.hasMany(Habit, { foreignKey: "user_id" });

module.exports = Habit;
