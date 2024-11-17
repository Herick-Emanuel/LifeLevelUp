// server.js
const express = require('express');
const bodyParser = require('body-parser');
const authRoutes = require('./routes/authRoutes');
const habitRoutes = require('./routes/habitRoutes');
const userRoutes = require('./routes/userRoutes');
const journalRoutes = require('./routes/journalRoutes');
const sequelize = require('./models/db');
const motivationRoutes = require('./routes/motivationRoutes');
const missionRoutes = require('./routes/missionRoutes');
const customizationRoutes = require('./routes/customizationRoutes');
const rankingRoutes = require('./routes/rankingRoutes');
const eventRoutes = require('./routes/eventRoutes');

const app = express();
app.use(bodyParser.json());

app.use('/auth', authRoutes);
app.use('/users', userRoutes);
app.use('/habits', habitRoutes);
app.use('/journal', journalRoutes);
app.use('/motivation', motivationRoutes);
app.use('/missions', missionRoutes);
app.use('/customization', customizationRoutes);
app.use('/ranking', rankingRoutes);
app.use('/events', eventRoutes);

sequelize.sync({ force: false }).then(() => {
    app.listen(3000, () => {
        console.log('Servidor rodando na porta 3000');
    });
}).catch(error => {
    console.error('Erro ao conectar ao banco de dados:', error);
});
