const Pool = require('pg').Pool
const pool = new Pool({
  user: 'latouquette96',
  host: 'localhost',
  database: 'db_jugueteria_efrain',
  password: '39925523',
  port: 5432,
})

///Devuelve toda la informacion almacenadas sobre las facturas, excepto el archivo propio de la factura.
const getAllBillings = (request, response) => {
  pool.query('SELECT db_id, db_distributor, db_datetime, db_total, db_url_file FROM billings ORDER BY db_datetime DESC', (error, results) => {
    if (error) {
      throw error
    }
    response.status(200).json(results.rows)
  })
}

///Devuelve toda la informacion almacenadas sobre las facturas para una determinada distribuidora, excepto el archivo propio de la factura. 
const getBillingsByDistributor = (request, response) => {
  const id = parseInt(request.params.id)

  pool.query('SELECT db_id, db_distributor, db_datetime, db_total, db_url_file FROM billings WHERE db_distributor = $1 ORDER BY db_datetime DESC', [id], (error, results) => {
    if (error) {
      throw error
    }
    response.status(200).json(results.rows)
  })
}

///Crea una factura para una distribuidora.
const createBilling = (request, response) => {
  const db_url_file = request.body.db_url_file;
  const db_datetime = request.body.db_datetime;
  const db_total  = request.body.db_total;
  const db_distributor = request.body.db_distributor;

  pool.query('INSERT INTO public.billings (db_distributor, db_url_file, db_datetime, db_total) '
            + '   VALUES ($1, $2, $3, $4)', [db_distributor, db_url_file, db_datetime, db_total], (error, results) => {
    if (error) {
      throw error
    }
    response.status(201).send(`Billing added with ID: ${results.insertId}`)
  })

}

const deleteBilling = (request, response) => {
  const db_id = parseInt(request.params.id)

  pool.query('DELETE FROM public.billings WHERE db_id=$1', [db_id], (error, results) => {
    if (error) {
      throw error
    }
    response.status(200).send(`Billing deleted with ID: ${db_id}`)
  })
}


module.exports = {
    getAllBillings,
    createBilling,
    getBillingsByDistributor,
    deleteBilling
}