// Utilizar funcionalidades del Ecmascript 6
'use strict'

// *Cargamos el fichero app.js con la configuración de Express
var app = require('./src/app');

const bodyParser = require('body-parser')
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

app.listen(port, () => {
  console.log(`App running on port ${port}.`)
})