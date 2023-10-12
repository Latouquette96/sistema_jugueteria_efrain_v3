const mysql = require("mysql");

//Credenciales para mysql
module.exports = mysql.createPool({
  host: "localhost",
  user: "Latouquette96",
  password: "39925523",
  database: "db_jugueteria_efrain",
  port: 3306
});

