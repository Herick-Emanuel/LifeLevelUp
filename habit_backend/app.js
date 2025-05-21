// server.js
require("dotenv").config();
const express = require("express");
const bodyParser = require("body-parser");
const cors = require("cors");
const helmet = require("helmet");
const morgan = require("morgan");
const winston = require("winston");
const sequelize = require("./config/database");

// Configuração do logger
const logger = winston.createLogger({
  level: "info",
  format: winston.format.combine(
    winston.format.timestamp(),
    winston.format.json()
  ),
  transports: [
    new winston.transports.File({ filename: "error.log", level: "error" }),
    new winston.transports.File({ filename: "combined.log" }),
  ],
});

if (process.env.NODE_ENV !== "production") {
  logger.add(
    new winston.transports.Console({
      format: winston.format.simple(),
    })
  );
}

// Importação das rotas
const authRoutes = require("./routes/authRoutes");
const habitRoutes = require("./routes/habitRoutes");
const userRoutes = require("./routes/userRoutes");
const journalRoutes = require("./routes/journalRoutes");
const motivationRoutes = require("./routes/motivationRoutes");
const missionRoutes = require("./routes/missionRoutes");
const customizationRoutes = require("./routes/customizationRoutes");
const rankingRoutes = require("./routes/rankingRoutes");
const eventRoutes = require("./routes/eventRoutes");
const habitCompletionRoutes = require("./routes/habitCompletionRoutes");
const communityChallengeRoutes = require("./routes/communityChallengeRoutes");

const app = express();

// Configuração do CORS
const corsOptions = {
  origin: process.env.FRONTEND_URL || "http://localhost:8080",
  methods: ["GET", "POST", "PUT", "DELETE", "OPTIONS"],
  allowedHeaders: ["Content-Type", "Authorization"],
  credentials: true,
};

// Middlewares
app.use(helmet()); // Segurança
app.use(cors(corsOptions)); // CORS configurado
app.use(morgan("combined")); // Logging
app.use(bodyParser.json());
app.use(bodyParser.urlencoded({ extended: true }));

// Middleware de logging
app.use((req, res, next) => {
  logger.info(`${req.method} ${req.url}`);
  next();
});

// Rotas
app.use("/api/auth", authRoutes);
app.use("/api/habits", habitRoutes);
app.use("/api/users", userRoutes);
app.use("/api/journal", journalRoutes);
app.use("/api/motivation", motivationRoutes);
app.use("/api/missions", missionRoutes);
app.use("/api/customization", customizationRoutes);
app.use("/api/ranking", rankingRoutes);
app.use("/api/events", eventRoutes);
app.use("/api/habit-completions", habitCompletionRoutes);
app.use("/api/community-challenges", communityChallengeRoutes);

// Middleware de tratamento de erros
app.use((err, req, res, next) => {
  logger.error(err.stack);
  res.status(500).json({
    error: "Erro interno do servidor",
    message: process.env.NODE_ENV === "development" ? err.message : undefined,
  });
});

// Middleware para rotas não encontradas
app.use((req, res) => {
  res.status(404).json({ error: "Rota não encontrada" });
});

const PORT = process.env.PORT || 3001; // Alterado para 3001

// Função para iniciar o servidor
const startServer = async () => {
  try {
    await sequelize.authenticate();
    logger.info("Conexão com o banco de dados estabelecida com sucesso.");

    await sequelize.sync({ force: false });
    logger.info("Modelos sincronizados com o banco de dados.");

    app.listen(PORT, () => {
      logger.info(`Servidor rodando na porta ${PORT}`);
    });
  } catch (error) {
    logger.error("Erro ao iniciar o servidor:", error);
    process.exit(1);
  }
};

// Iniciar o servidor
startServer();

module.exports = app;
