const { DataTypes } = require("sequelize");
const sequelize = require("../config/database");

const CommunityChallenge = sequelize.define(
  "community_challenge",
  {
    title: { type: DataTypes.STRING, allowNull: false },
    description: { type: DataTypes.STRING, allowNull: true },
    type: { type: DataTypes.STRING, allowNull: false }, // criar/eliminação
    entry_cost: { type: DataTypes.INTEGER, allowNull: false, defaultValue: 10 },
    reward_points: {
      type: DataTypes.INTEGER,
      allowNull: false,
      defaultValue: 20,
    },
    reward_badge: { type: DataTypes.STRING, allowNull: true },
    reward_cosmetic: { type: DataTypes.STRING, allowNull: true },
    start_date: { type: DataTypes.DATE, allowNull: false },
    end_date: { type: DataTypes.DATE, allowNull: false },
    status: {
      type: DataTypes.STRING,
      allowNull: false,
      defaultValue: "active",
    },
  },
  {
    tableName: "community_challenge",
    underscored: true,
  }
);

module.exports = CommunityChallenge;
