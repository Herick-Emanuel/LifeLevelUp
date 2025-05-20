require("dotenv").config();
const { Sequelize } = require("sequelize");
const fs = require("fs");
const path = require("path");

const sequelize = new Sequelize(
  process.env.DB_NAME,
  process.env.DB_USER,
  process.env.DB_PASSWORD,
  {
    host: process.env.DB_HOST,
    port: process.env.DB_PORT,
    dialect: "postgres",
    logging: false,
  }
);

async function runMigration() {
  try {
    // Primeiro, vamos criar uma coluna temporária
    await sequelize.query(`
      ALTER TABLE habit 
      ADD COLUMN reminder_time_temp TIME;
    `);

    // Converter os dados existentes
    await sequelize.query(`
      UPDATE habit 
      SET reminder_time_temp = reminder_time::time 
      WHERE reminder_time IS NOT NULL;
    `);

    // Remover a coluna antiga
    await sequelize.query(`
      ALTER TABLE habit 
      DROP COLUMN reminder_time;
    `);

    // Renomear a coluna temporária para o nome original
    await sequelize.query(`
      ALTER TABLE habit 
      RENAME COLUMN reminder_time_temp TO reminder_time;
    `);

    console.log("Migration executada com sucesso!");
  } catch (error) {
    console.error("Erro ao executar migration:", error);
  } finally {
    await sequelize.close();
  }
}

runMigration();
