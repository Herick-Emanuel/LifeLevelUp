const { DataTypes } = require("sequelize");
const sequelize = require("../config/database");
const User = require("./user");
const CommunityChallenge = require("./communityChallenge");

const ChallengeProgress = sequelize.define(
  "challenge_progress",
  {
    user_id: {
      type: DataTypes.INTEGER,
      allowNull: false,
      references: { model: User, key: "id" },
    },
    community_challenge_id: {
      type: DataTypes.INTEGER,
      allowNull: false,
      references: { model: CommunityChallenge, key: "id" },
    },
    status: {
      type: DataTypes.STRING,
      allowNull: false,
      defaultValue: "in_progress", // in_progress, completed, failed
    },
    completed_at: {
      type: DataTypes.DATE,
      allowNull: true,
    },
  },
  {
    tableName: "challenge_progress",
    underscored: true,
  }
);

module.exports = ChallengeProgress;
