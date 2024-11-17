// models/db.js
const { Sequelize } = require('sequelize');
const config = require('../config/config');

const sequelize = new Sequelize(config.DB, config.USER, config.PASSWORD, {
    host: config.HOST,
    dialect: 'postgres',
    logging: false,
});

module.exports = sequelize;
