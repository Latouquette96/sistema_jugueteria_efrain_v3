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

  const createProduct = (request, response) => {
    const {p_barcode, p_internal_code, p_title, p_description, p_brand, p_price_public, p_stock, p_subcategory, p_images, p_sizes, p_date_updated, p_date_created, p_minimum_age} = request.body
  
    pool.query('INSERT INTO public.products(p_barcode, p_internal_code, p_title, p_description, p_brand, p_price_public, p_stock, p_subcategory, p_images, p_sizes, p_date_updated, p_date_created, p_minimum_age) '+
      '   VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13) RETURNING p_id', 
        [p_barcode, p_internal_code, p_title, p_description, p_brand, p_price_public, p_stock, p_subcategory, p_images, p_sizes, p_date_updated, p_date_created, p_minimum_age], 
        (error, results) => {
          if (error) {
            throw error
          }
          response.status(201).json(results.rows)
        }
      )
  }

  module.exports = {
    insertValues
  }