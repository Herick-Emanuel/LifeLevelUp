const { DataTypes } = require("sequelize");
const sequelize = require("../config/database");
const Habit = require("./habit");

const HabitCompletion = sequelize.define(
  "HabitCompletion",
  {
    habit_id: {
      type: DataTypes.INTEGER,
      allowNull: false,
      references: {
        model: Habit,
        key: "id",
      },
    },
    completion_date: {
      type: DataTypes.DATE,
      allowNull: false,
      defaultValue: DataTypes.NOW,
    },
    tempo_gasto: {
      type: DataTypes.INTEGER, // Armazenado em minutos
      allowNull: true,
    },
  },
  {
    tableName: "habit_completion",
    underscored: true,
  }
);

HabitCompletion.belongsTo(Habit, { foreignKey: "habit_id" });
Habit.hasMany(HabitCompletion, { foreignKey: "habit_id" });

module.exports = HabitCompletion;
