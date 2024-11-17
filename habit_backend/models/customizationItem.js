const { DataTypes } = require('sequelize');
const sequelize = require('./db');
const User = require('./user');

const CustomizationItem = sequelize.define('CustomizationItem', {
    name: { type: DataTypes.STRING, allowNull: false },
    type: { type: DataTypes.STRING, allowNull: false },
    levelRequired: { type: DataTypes.INTEGER, defaultValue: 1 },
    pointsCost: { type: DataTypes.INTEGER, defaultValue: 0 },
});

CustomizationItem.belongsToMany(User, { through: 'UserCustomizationItems' });
User.belongsToMany(CustomizationItem, { through: 'UserCustomizationItems' });

module.exports = CustomizationItem;
