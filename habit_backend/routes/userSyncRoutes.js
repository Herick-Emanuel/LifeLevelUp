const express = require('express'); // Importação única
const router = express.Router(); // Utilize o router do express
const userController = require('../controllers/userController');
const authMiddleware = require('../middlewares/authMiddleware');
const userController = require('../controllers/userController');//

// Rota para obter perfil do usuário autenticado
router.get('/profile', authMiddleware, userController.getUserProfile);

// Rota para atualizar perfil do usuário autenticado
router.put('/profile', authMiddleware, userController.updateUserProfile);

// Rota para deletar usuário autenticado
router.delete('/', authMiddleware, userController.deleteUser);

// Rota para sincronizar usuários entre `users` e `"Users"`
router.get('/sync', userController.syncUsers);

module.exports = router;
