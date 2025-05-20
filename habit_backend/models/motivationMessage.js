const { DataTypes } = require("sequelize");
const sequelize = require("../config/database");
const User = require("./user");

const MotivationMessage = sequelize.define("motivation_message", {
  message: { type: DataTypes.STRING, allowNull: false },
  user_id: { type: DataTypes.INTEGER, allowNull: false },
  createdAt: { type: DataTypes.DATE, defaultValue: DataTypes.NOW },
});

MotivationMessage.belongsTo(User, { foreignKey: "user_id" });
User.hasMany(MotivationMessage, { foreignKey: "user_id" });

module.exports = MotivationMessage;
