const User = require("./user");
const Habit = require("./habit");
const HabitCompletion = require("./habit_completion");
const JournalEntry = require("./journalEntry");
const MotivationMessage = require("./motivationMessage");
const Achievement = require("./achievement");
const CustomizationItem = require("./customizationItem");
const Mission = require("./mission");
const Event = require("./event");
const CommunityChallenge = require("./communityChallenge");
const CosmeticItem = require("./cosmeticItem");
const ChallengeProgress = require("./challengeProgress");

// Definir as associações entre os modelos
User.hasMany(Habit, { foreignKey: "user_id" });
Habit.belongsTo(User, { foreignKey: "user_id" });

User.hasMany(HabitCompletion, { foreignKey: "user_id" });
HabitCompletion.belongsTo(User, { foreignKey: "user_id" });

Habit.hasMany(HabitCompletion, { foreignKey: "habit_id" });
HabitCompletion.belongsTo(Habit, { foreignKey: "habit_id" });

User.hasMany(JournalEntry, { foreignKey: "user_id" });
JournalEntry.belongsTo(User, { foreignKey: "user_id" });

User.hasMany(Mission, { foreignKey: "user_id" });
Mission.belongsTo(User, { foreignKey: "user_id" });

User.hasMany(Event, { foreignKey: "user_id" });
Event.belongsTo(User, { foreignKey: "user_id" });

// Exportar todos os modelos
module.exports = {
  User,
  Habit,
  HabitCompletion,
  JournalEntry,
  MotivationMessage,
  Achievement,
  CustomizationItem,
  Mission,
  Event,
  CommunityChallenge,
  CosmeticItem,
  ChallengeProgress,
};
