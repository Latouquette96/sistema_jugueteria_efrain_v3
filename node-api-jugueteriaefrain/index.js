const express = require('express')
const bodyParser = require('body-parser')
const app = express()
const db_tests = require('./queries_tests')
const db_product = require('./queries_product')
const db_distributor = require('./queries_distributor')
const db_billing = require('./queries_billings')
const db_filter = require('./queries_filter')
const db_price_product = require('./queries_prices_products')
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

app.post('/tests/multipleRows', db_tests.insertValues)

app.get('/filter/brands', db_filter.getLoadedBrands)

app.get('/products', db_product.getProducts)
app.get('/products/:id', db_product.getProductById)
app.post('/products', db_product.createProduct)
app.put('/products/:id', db_product.updateProduct)
app.put('/products/price_public/:id', db_product.updatePricePublicProduct)
app.delete('/products/:id', db_product.deleteProduct)

app.get('/products/prices_products/:id', db_price_product.getProductPriceByID)
app.post('/products/prices_products/', db_price_product.createProductPrice)
app.put('/products/prices_products/:id', db_price_product.updateProductPrice)
app.delete('/products/prices_products/:id', db_price_product.deleteProductPrice)

app.get('/distributors', db_distributor.getDistributors)
app.get('/distributors/:id', db_distributor.getDistributorById)
app.post('/distributors', db_distributor.createDistributor)
app.put('/distributors/:id', db_distributor.updateDistributor)
app.delete('/distributors/:id', db_distributor.deleteDistributor)

app.get('/distributors/billings', db_billing.getAllBillings)
app.get('/distributors/billings/distributor/:id', db_billing.getBillingsByDistributor)
app.post('/distributors/billings', db_billing.createBilling)
app.delete('/distributors/billings/:id', db_billing.deleteBilling)

app.listen(port, () => {
  console.log(`App running on port ${port}.`)
})