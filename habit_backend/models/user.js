const { DataTypes } = require('sequelize');
const sequelize = require('./db');

const User = sequelize.define('User', {
    name: { type: DataTypes.STRING, allowNull: false },
    email: { type: DataTypes.STRING, allowNull: false, unique: true },
    password: { type: DataTypes.STRING, allowNull: false },
    level: { type: DataTypes.INTEGER, defaultValue: 1 },
    points: { type: DataTypes.INTEGER, defaultValue: 0 },
});

module.exports = User;
