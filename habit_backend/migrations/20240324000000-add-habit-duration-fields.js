"use strict";

module.exports = {
  up: async (queryInterface, Sequelize) => {
    await queryInterface.addColumn("habit", "quantidade_de_conclusoes", {
      type: Sequelize.INTEGER,
      allowNull: true,
    });

    await queryInterface.addColumn("habit", "tempo_de_duracao_do_habito", {
      type: Sequelize.INTEGER,
      allowNull: true,
    });
  },

  down: async (queryInterface, Sequelize) => {
    await queryInterface.removeColumn("habit", "quantidade_de_conclusoes");
    await queryInterface.removeColumn("habit", "tempo_de_duracao_do_habito");
  },
};
