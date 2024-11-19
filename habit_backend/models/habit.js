const { DataTypes } = require('sequelize');
const sequelize = require('./db');
const User = require('./user');

const Habit = sequelize.define('Habit', {
    name: { type: DataTypes.STRING, allowNull: false },
    frequency: { type: DataTypes.STRING, allowNull: false },
    goal: { type: DataTypes.INTEGER, allowNull: false },
    progress: { type: DataTypes.INTEGER, defaultValue: 0 },
    reminder: { type: DataTypes.BOOLEAN, defaultValue: false },
});

Habit.belongsTo(User, { foreignKey: 'UserId' });
User.hasMany(Habit, { foreignKey: 'UserId' });

module.exports = Habit;
