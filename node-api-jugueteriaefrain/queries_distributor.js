const Pool = require('pg').Pool
const pool = new Pool({
  user: 'latouquette96',
  host: 'localhost',
  database: 'db_jugueteria_efrain',
  password: '39925523',
  port: 5432,
})

const getDistributors = (request, response) => {
  pool.query('SELECT * FROM distributors ORDER BY d_name ASC', (error, results) => {
    if (error) {
      throw error
    }
    response.status(200).json(results.rows)
  })
}

const getDistributorById = (request, response) => {
  const id = parseInt(request.params.id)

  pool.query('SELECT * FROM distributors WHERE d_id = $1', [id], (error, results) => {
    if (error) {
      throw error
    }
    response.status(200).json(results.rows)
  })
}

const createDistributor = (request, response) => {
  const { cuit, name, address, email, cel, website, iva } = request.body

  pool.query('INSERT INTO distributors (d_cuit, d_name, d_address, d_email, d_cel, d_website, d_iva) '
            + 'VALUES ($1, $2, $3, $4, $5, $6, $7)', [cuit, name, address, email, cel, website, iva], (error, results) => {
    if (error) {
      throw error
    }
    response.status(201).send(`Distributor added with ID: ${results.insertId}`)
  })
}

const updateDistributor = (request, response) => {
  const id = parseInt(request.params.id)
  const { cuit, name, address, email, cel, website, iva } = request.body

  pool.query(
    'UPDATE public.distributors' + 
	'SET d_cuit=$1, d_name=$2, d_address=$3, d_email=$4, d_cel=$5, d_website=$6, d_iva=$7' +
	'WHERE d_id = $8',
    [cuit, name, address, email, cel, website, iva, id],
    (error, results) => {
      if (error) {
        throw error
      }
      response.status(200).send(`Distributor modified with ID: ${id}`)
    }
  )
}

const deleteDistributor = (request, response) => {
  const id = parseInt(request.params.id)

  pool.query('DELETE FROM distributors WHERE d_id = $1', [id], (error, results) => {
    if (error) {
      throw error
    }
    response.status(200).send(`Distributor deleted with ID: ${id}`)
  })
}

module.exports = {
  getDistributors,
  getDistributorById,
  createDistributor,
  updateDistributor,
  deleteDistributor,
}