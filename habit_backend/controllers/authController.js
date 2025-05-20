const jwt = require("jsonwebtoken");
const bcrypt = require("bcryptjs");
const User = require("../models/user");
const config = require("../config/config");

exports.register = async (req, res) => {
  try {
    const { name, email, password } = req.body;
    console.log("Dados de registro recebidos:", { name, email });

    // Verifica se o usuário já existe
    const existingUser = await User.findOne({ where: { email } });
    if (existingUser) {
      console.log("Usuário já existe:", email);
      return res.status(400).json({ message: "E-mail já cadastrado" });
    }

    console.log("Criando novo usuário...");
    const user = await User.create({ name, email, password });
    console.log("Usuário criado com sucesso:", {
      id: user.id,
      email: user.email,
    });
    res.status(201).json({ message: "Usuário criado com sucesso!" });
  } catch (error) {
    console.error("Erro ao criar usuário:", error);
    res
      .status(500)
      .json({ message: "Erro ao criar usuário", error: error.message });
  }
};

exports.login = async (req, res) => {
  try {
    const { email, password } = req.body;
    console.log("Tentativa de login:", { email });

    const user = await User.findOne({ where: { email } });
    console.log("Usuário encontrado:", user ? "Sim" : "Não");

    if (!user) {
      console.log("Usuário não encontrado:", email);
      return res.status(401).json({ message: "Credenciais inválidas" });
    }

    console.log("Comparando senhas...");
    const isPasswordValid = await bcrypt.compare(password, user.password);
    console.log("Senha válida:", isPasswordValid);

    if (isPasswordValid) {
      const token = jwt.sign({ userId: user.id }, config.JWT_SECRET, {
        expiresIn: "1d",
      });
      console.log("Token gerado com sucesso para:", email);
      res.json({ token });
    } else {
      console.log("Senha inválida para:", email);
      res.status(401).json({ message: "Credenciais inválidas" });
    }
  } catch (error) {
    console.error("Erro ao fazer login:", error);
    res
      .status(500)
      .json({ message: "Erro ao fazer login", error: error.message });
  }
};
