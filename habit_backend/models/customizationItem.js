const { DataTypes } = require("sequelize");
const sequelize = require("../config/database");
const User = require("./user");

const CustomizationItem = sequelize.define("customization_item", {
  name: { type: DataTypes.STRING, allowNull: false },
  type: { type: DataTypes.STRING, allowNull: false },
  level_required: { type: DataTypes.INTEGER, defaultValue: 1 },
  points_cost: { type: DataTypes.INTEGER, defaultValue: 0 },
});

CustomizationItem.belongsToMany(User, { through: "user_customization_items" });
User.belongsToMany(CustomizationItem, { through: "user_customization_items" });

module.exports = CustomizationItem;
