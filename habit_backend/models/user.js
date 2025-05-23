const { DataTypes } = require("sequelize");
const sequelize = require("../config/database");
const bcrypt = require("bcryptjs");

const User = sequelize.define(
  "user",
  {
    name: { type: DataTypes.STRING, allowNull: false },
    email: { type: DataTypes.STRING, allowNull: false, unique: true },
    password: { type: DataTypes.STRING, allowNull: false },
    level: { type: DataTypes.INTEGER, defaultValue: 1 },
    points: { type: DataTypes.INTEGER, defaultValue: 0 },
    is_admin: { type: DataTypes.BOOLEAN, defaultValue: false },
  },
  {
    tableName: "user",
    underscored: true,
  }
);

// Hook para criptografar a senha antes de salvar
User.beforeCreate(async (user) => {
  if (user.password) {
    const salt = await bcrypt.genSalt(10);
    user.password = await bcrypt.hash(user.password, salt);
  }
});

module.exports = User;
