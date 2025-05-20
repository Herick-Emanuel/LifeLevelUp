const { DataTypes } = require("sequelize");
const sequelize = require("../config/database");
const User = require("./user");

const Achievement = sequelize.define("achievement", {
  title: { type: DataTypes.STRING, allowNull: false },
  description: { type: DataTypes.STRING },
  is_temporary: { type: DataTypes.BOOLEAN, defaultValue: false },
});

Achievement.belongsToMany(User, { through: "user_achievements" });
User.belongsToMany(Achievement, { through: "user_achievements" });

module.exports = Achievement;
