const express = require('express')
const bodyParser = require('body-parser')
const app = express()
const db_product = require('./queries_product')
const db_distributor = require('./queries_distributor')
const port = 3000

app.use(bodyParser.json())
app.use(
  bodyParser.urlencoded({
    extended: true,
  })
)

app.get('/', (request, response) => {
  response.json({ info: 'Node.js, Express, and Postgres API' })
})

app.get('/products', db_product.getProducts)
app.get('/products/:id', db_product.getProductById)
app.post('/products', db_product.createProduct)
app.put('/products/:id', db_product.updateProduct)
app.delete('/products/:id', db_product.deleteProduct)
app.get('/distributors', db_distributor.getDistributors)
app.get('/distributors/:id', db_distributor.getDistributorById)
app.post('/distributors', db_distributor.createDistributor)
app.put('/distributors/', db_distributor.updateDistributor)
app.delete('/distributors/:id', db_distributor.deleteDistributor)

app.listen(port, () => {
  console.log(`App running on port ${port}.`)
})