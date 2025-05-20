"use strict";

/** @type {import('sequelize-cli').Migration} */
module.exports = {
  async up(queryInterface, Sequelize) {
    await queryInterface.addColumn("habit", "reminder_time", {
      type: Sequelize.TIME,
      allowNull: true,
    });

    await queryInterface.addColumn("habit", "reminder_days", {
      type: Sequelize.ARRAY(Sequelize.INTEGER),
      allowNull: true,
      defaultValue: [],
    });

    await queryInterface.addColumn("habit", "reminder_enabled", {
      type: Sequelize.BOOLEAN,
      allowNull: false,
      defaultValue: false,
    });
  },

  async down(queryInterface, Sequelize) {
    await queryInterface.removeColumn("habit", "reminder_time");
    await queryInterface.removeColumn("habit", "reminder_days");
    await queryInterface.removeColumn("habit", "reminder_enabled");
  },
};
