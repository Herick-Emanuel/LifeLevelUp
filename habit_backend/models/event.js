const { DataTypes } = require('sequelize');
const sequelize = require('./db');

const Event = sequelize.define('Event', {
    name: { type: DataTypes.STRING, allowNull: false },
    description: { type: DataTypes.STRING },
    startDate: { type: DataTypes.DATE, allowNull: false },
    endDate: { type: DataTypes.DATE, allowNull: false },
});

module.exports = Event;
