"use strict";

module.exports = {
  up: async (queryInterface, Sequelize) => {
    await queryInterface.addColumn("habit", "reminder_time", {
      type: Sequelize.TIME,
      allowNull: true,
    });

    await queryInterface.addColumn("habit", "reminder_days", {
      type: Sequelize.ARRAY(Sequelize.INTEGER),
      defaultValue: [],
    });
  },

  down: async (queryInterface, Sequelize) => {
    await queryInterface.changeColumn("habit", "reminder_time", {
      type: Sequelize.DATE,
      allowNull: true,
    });
    await queryInterface.removeColumn("habit", "reminder_days");
  },
};
