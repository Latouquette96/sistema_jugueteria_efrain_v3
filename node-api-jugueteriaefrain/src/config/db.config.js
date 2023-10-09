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

/*
export const HOST = "localhost";
export const USER = "latouquette96";
export const PASSWORD = "39925523";
export const DB = "db_jugueteria_efrain";
export const PORT = 5432;
export const dialect = "postgres";
export const pool = {
    max: 5,
    min: 0,
    acquire: 30000,
    idle: 10000
};
*/