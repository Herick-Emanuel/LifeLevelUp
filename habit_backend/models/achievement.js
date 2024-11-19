const { DataTypes } = require('sequelize');
const sequelize = require('./db');
const User = require('./user');

const Achievement = sequelize.define('Achievement', {
    title: { type: DataTypes.STRING, allowNull: false },
    description: { type: DataTypes.STRING },
    isTemporary: { type: DataTypes.BOOLEAN, defaultValue: false },
});

Achievement.belongsToMany(User, { through: 'UserAchievements' });
User.belongsToMany(Achievement, { through: 'UserAchievements' });

module.exports = Achievement;
