const { DataTypes } = require("sequelize");
const sequelize = require("../config/database");

const Event = sequelize.define("event", {
  name: { type: DataTypes.STRING, allowNull: false },
  description: { type: DataTypes.STRING },
  start_date: { type: DataTypes.DATE, allowNull: false },
  end_date: { type: DataTypes.DATE, allowNull: false },
});

module.exports = Event;
