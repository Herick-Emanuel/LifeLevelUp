// models/motivationMessage.js

const { DataTypes } = require('sequelize');
const sequelize = require('./db');
const User = require('./user');

const MotivationMessage = sequelize.define('MotivationMessage', {
    message: { type: DataTypes.STRING, allowNull: false },
});

MotivationMessage.belongsTo(User, { foreignKey: 'UserId' });
User.hasMany(MotivationMessage, { foreignKey: 'UserId' });

module.exports = MotivationMessage;
