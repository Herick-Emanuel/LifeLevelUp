// controllers/habitController.js
const Habit = require('../models/habit');
const { validationResult } = require('express-validator');
const { body } = require('express-validator');


exports.validateHabit = [
    body('name').notEmpty().withMessage('O nome do hábito é obrigatório'),
    body('frequency').isIn(['Diário', 'Semanal', 'Mensal']).withMessage('Frequência inválida'),
    body('goal').isInt({ min: 1 }).withMessage('A meta deve ser um número inteiro positivo'),
    body('reminder').isBoolean().withMessage('Reminder deve ser verdadeiro ou falso'),
];

exports.createHabit = async (req, res) => {
    const errors = validationResult(req);
    if (!errors.isEmpty()) {
        return res.status(400).json({ errors: errors.array() });
    }

    try {
        const { name, frequency, goal, reminder } = req.body;
        const habit = await Habit.create({
            name,
            frequency,
            goal,
            reminder,
            UserId: req.user.userId,
        });
        res.status(201).json(habit);
    } catch (error) {
        res.status(500).json({ message: 'Erro ao criar hábito', error: error.message });
    }
};

exports.getHabits = async (req, res) => {
    try {
        const habits = await Habit.findAll({ where: { UserId: req.user.userId } });
        res.json(habits);
    } catch (error) {
        res.status(500).json({ message: 'Erro ao buscar hábitos', error });
    }
};

exports.updateHabit = async (req, res) => {
    try {
        const habit = await Habit.findByPk(req.params.id);
        if (habit && habit.UserId === req.user.userId) {
            await habit.update(req.body);
            res.json(habit);
        } else {
            res.status(404).json({ message: 'Hábito não encontrado' });
        }
    } catch (error) {
        res.status(500).json({ message: 'Erro ao atualizar hábito', error });
    }
};

exports.deleteHabit = async (req, res) => {
    try {
        const habit = await Habit.findByPk(req.params.id);
        if (habit && habit.UserId === req.user.userId) {
            await habit.destroy();
            res.json({ message: 'Hábito excluído' });
        } else {
            res.status(404).json({ message: 'Hábito não encontrado' });
        }
    } catch (error) {
        res.status(500).json({ message: 'Erro ao excluir hábito', error });
    }
};

exports.incrementHabitProgress = async (req, res) => {
    try {
        const habit = await Habit.findByPk(req.params.id);
        if (habit && habit.UserId === req.user.userId) {
            await habit.increment('progress');

            // Atualizar pontos do usuário
            const user = await User.findByPk(req.user.userId);
            user.points += 10; // Exemplo: 10 pontos por progresso
            // Verificar se o usuário atingiu um novo nível
            const pointsNeeded = user.level * 100;
            if (user.points >= pointsNeeded) {
                user.level += 1;
                // Pode adicionar lógica adicional para recompensas de nível
            }
            await user.save();

            res.json(habit);
        } else {
            res.status(404).json({ message: 'Hábito não encontrado' });
        }
    } catch (error) {
        res.status(500).json({ message: 'Erro ao incrementar progresso', error });
    }
};