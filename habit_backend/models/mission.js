const { DataTypes } = require("sequelize");
const sequelize = require("../config/database");
const User = require("./user");

const Mission = sequelize.define("mission", {
  title: { type: DataTypes.STRING, allowNull: false },
  description: { type: DataTypes.STRING },
  type: { type: DataTypes.STRING, allowNull: false },
  is_completed: { type: DataTypes.BOOLEAN, defaultValue: false },
});

Mission.belongsTo(User, { foreignKey: "user_id" });
User.hasMany(Mission, { foreignKey: "user_id" });

module.exports = Mission;
