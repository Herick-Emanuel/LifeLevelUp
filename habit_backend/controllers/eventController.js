const Event = require('../models/event');
const Achievement = require('../models/achievement');
const User = require('../models/user');

exports.getActiveEvents = async (req, res) => {
    try {
        const events = await Event.findAll({
            where: {
                startDate: { [Op.lte]: new Date() },
                endDate: { [Op.gte]: new Date() },
            },
        });
        res.json(events);
    } catch (error) {
        res.status(500).json({ message: 'Erro ao obter eventos', error });
    }
};
