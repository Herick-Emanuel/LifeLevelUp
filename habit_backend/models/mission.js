const { DataTypes } = require('sequelize');
const sequelize = require('./db');
const User = require('./user');

const Mission = sequelize.define('Mission', {
    title: { type: DataTypes.STRING, allowNull: false },
    description: { type: DataTypes.STRING },
    type: { type: DataTypes.STRING, allowNull: false },
    isCompleted: { type: DataTypes.BOOLEAN, defaultValue: false },
});

Mission.belongsTo(User, { foreignKey: 'UserId' });
User.hasMany(Mission, { foreignKey: 'UserId' });

module.exports = Mission;
