// controllers/customizationController.js

const CustomizationItem = require('../models/customizationItem');
const User = require('../models/user');

exports.getAvailableItems = async (req, res) => {
    try {
        const user = await User.findByPk(req.user.userId);
        const items = await CustomizationItem.findAll({
            where: {
                levelRequired: { [Op.lte]: user.level },
            },
        });
        res.json(items);
    } catch (error) {
        res.status(500).json({ message: 'Erro ao obter itens', error });
    }
};

exports.purchaseItem = async (req, res) => {
    try {
        const user = await User.findByPk(req.user.userId);
        const item = await CustomizationItem.findByPk(req.params.id);

        if (item && user.points >= item.pointsCost) {
            await user.addCustomizationItem(item);
            user.points -= item.pointsCost;
            await user.save();

            res.json({ message: 'Item adquirido com sucesso', item });
        } else {
            res.status(400).json({ message: 'Pontos insuficientes ou item não encontrado' });
        }
    } catch (error) {
        res.status(500).json({ message: 'Erro ao adquirir item', error });
    }
};
