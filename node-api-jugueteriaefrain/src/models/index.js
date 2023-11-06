const dbConfig = require("../config/db.config.js");

const Sequelize = require("sequelize");
const sequelize = new Sequelize(dbConfig.DB, dbConfig.USER, dbConfig.PASSWORD, {
  host: dbConfig.HOST,
  dialect: dbConfig.dialect,
  operatorsAliases: false,
  pool: {
    max: dbConfig.pool.max,
    min: dbConfig.pool.min,
    acquire: dbConfig.pool.acquire,
    idle: dbConfig.pool.idle
  }
});

const db = {};

db.Sequelize = Sequelize;
db.sequelize = sequelize;

db.products = require("./product.model.js")(sequelize, Sequelize);
db.distributors = require("./distributor.model.js")(sequelize, Sequelize);
db.products_prices = require("./products_prices.model.js")(sequelize, Sequelize);
db.billings = require("./billing.model.js")(sequelize, Sequelize);
db.code_generated = require("./code_generated.model.js")(sequelize, Sequelize);

module.exports = db;