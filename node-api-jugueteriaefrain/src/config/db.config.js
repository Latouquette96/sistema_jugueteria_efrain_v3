module.exports = {
    HOST: "localhost",
    USER: "latouquette96",
    PASSWORD: "39925523",
    DB: "db_jugueteria_efrain",
    PORT: 5432,
    dialect: "postgres",
    pool: {
      max: 5,
      min: 0,
      acquire: 30000,
      idle: 10000
    }
};