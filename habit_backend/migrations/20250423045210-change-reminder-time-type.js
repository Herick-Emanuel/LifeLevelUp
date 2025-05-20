"use strict";

module.exports = {
  up: async (queryInterface, Sequelize) => {
    // Primeiro, vamos criar uma coluna temporária
    await queryInterface.addColumn("habit", "reminder_time_temp", {
      type: Sequelize.TIME,
      allowNull: true,
    });

    // Converter os dados existentes
    await queryInterface.sequelize.query(`
      UPDATE habit 
      SET reminder_time_temp = reminder_time::time 
      WHERE reminder_time IS NOT NULL
    `);

    // Remover a coluna antiga
    await queryInterface.removeColumn("habit", "reminder_time");

    // Renomear a coluna temporária para o nome original
    await queryInterface.renameColumn(
      "habit",
      "reminder_time_temp",
      "reminder_time"
    );
  },

  down: async (queryInterface, Sequelize) => {
    // Primeiro, vamos criar uma coluna temporária
    await queryInterface.addColumn("habit", "reminder_time_temp", {
      type: Sequelize.DATE,
      allowNull: true,
    });

    // Converter os dados existentes
    await queryInterface.sequelize.query(`
      UPDATE habit 
      SET reminder_time_temp = reminder_time::timestamp with time zone 
      WHERE reminder_time IS NOT NULL
    `);

    // Remover a coluna antiga
    await queryInterface.removeColumn("habit", "reminder_time");

    // Renomear a coluna temporária para o nome original
    await queryInterface.renameColumn(
      "habit",
      "reminder_time_temp",
      "reminder_time"
    );
  },
};
