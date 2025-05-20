"use strict";

module.exports = {
  up: async (queryInterface, Sequelize) => {
    await queryInterface.addColumn("habit", "completion_rate", {
      type: Sequelize.DOUBLE,
      allowNull: false,
      defaultValue: 0.0,
    });

    await queryInterface.addColumn("habit", "status", {
      type: Sequelize.STRING,
      allowNull: false,
      defaultValue: "pending",
      validate: {
        isIn: [["completed", "pending", "failed"]],
      },
    });
  },

  down: async (queryInterface, Sequelize) => {
    await queryInterface.removeColumn("habit", "completion_rate");
    await queryInterface.removeColumn("habit", "status");
  },
};
