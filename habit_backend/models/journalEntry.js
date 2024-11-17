// models/journalEntry.js

const { DataTypes } = require('sequelize');
const sequelize = require('./db');
const User = require('./user');

const JournalEntry = sequelize.define('JournalEntry', {
    content: { type: DataTypes.TEXT, allowNull: false },
});

JournalEntry.belongsTo(User, { foreignKey: 'UserId' });
User.hasMany(JournalEntry, { foreignKey: 'UserId' });

module.exports = JournalEntry;
