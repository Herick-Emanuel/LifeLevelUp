const { DataTypes } = require("sequelize");
const sequelize = require("../config/database");
const User = require("./user");

const JournalEntry = sequelize.define("journal_entry", {
  content: { type: DataTypes.TEXT, allowNull: false },
  user_id: { type: DataTypes.INTEGER, allowNull: false },
  createdAt: { type: DataTypes.DATE, defaultValue: DataTypes.NOW },
});

JournalEntry.belongsTo(User, { foreignKey: "user_id" });
User.hasMany(JournalEntry, { foreignKey: "user_id" });

module.exports = JournalEntry;
