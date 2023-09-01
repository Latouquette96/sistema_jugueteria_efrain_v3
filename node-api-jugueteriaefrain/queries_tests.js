var format = require('pg-format');

const Pool = require('pg').Pool
const pool = new Pool({
  user: 'latouquette96',
  host: 'localhost',
  database: 'db_jugueteria_efrain',
  password: '39925523',
  port: 5432,
})

const values = [
    ["Ejemplo 1"],
    ["Ejemplo 2"]
  ];

const insertValues = (response) => {
    
    pool.query(format('INSERT INTO public.tests(t_text) '+
      '   VALUES %L', values, 
        (error, results) => {
          if (error) {
            throw error
          }
          response.status(201).json(results.rows)
        }
      ))
  }

  module.exports = {
    insertValues
  }