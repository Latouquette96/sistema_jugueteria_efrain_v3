const db = require("../../models");
const CodeGenerated = db.code_generated;

//Crear y guardar una nueva factura.
exports.create = (req, res) => {

    //Modelo para crear un nuevo código interno
    const code = {
        cg_product: null,
    };

    //Guarda el código interno en la base de datos.
    CodeGenerated.create(code)
        .then(data => {
            res.status(201).json({
                status: 201,
                title: "Operación exitosa",
                message: 'El código interno fue creado en la base de datos con éxito.',
                error: null,
                value: {gc_id: data.gc_id}
            });
        })
        .catch(err => {
            res.status(500).json({
                status: 500,
                title: "Error 500",
                message: 'Error::CodeGenerated.create(): Error al crear el código interno en la base de datos.',
                error: err,
                value: null
            });
        });
};

//Realiza la busqueda de un código interno con identificador id.
exports.findOne = (req, res) => {
    const id = req.params.id;

    CodeGenerated.findByPk(id)
        .then(data => {
            if (data) {
                res.status(200).json({
                    status: 200,
                    title: "Operación exitosa",
                    message: 'El código interno fue recuperado de la base de datos con éxito.',
                    error: null,
                    value: data
                });
            } else {
                res.status(404).json({
                    status: 404,
                    title: "Error 404",
                    message: 'Error::CodeGenerated.findOne(): No se pudo recuperar el código interno de la base de datos.',
                    error: null,
                    value: null
                });
            }
        })
        .catch(err => {
            res.status(500).json({
                status: 500,
                title: "Error 500",
                message: 'Error::CodeGenerated.findOne(): Ocurrió un problema al recuperar el código interno de la base de datos.',
                error: err,
                value: null
            });
        });
};

//Realiza la busqueda de un código interno que esté libre (o lo crea y lo retorna).
exports.findFirstFree = (req, res) => {
    try {
        const [data, _created] = CodeGenerated.findOrCreate({
            where: { cb_product: null },
        });

        res.status(200).json({
            status: 200,
            title: "Operación exitosa",
            message: 'El código interno fue recuperado de la base de datos con éxito.',
            error: null,
            value: data
        });
    }
    catch (error) {
        res.status(500).json({
            status: 500,
            title: "Error 500",
            message: 'Error::CodeGenerated.findOne(): Ocurrió un problema al recuperar el código interno de la base de datos.',
            error: error,
            value: null
        });
    }
};

//Establece un producto para un código interno con identificador id.
exports.update = (req, res) => {
    const id = req.params.id;

    //Crea un código interno.
    const code = {
        gc_product: req.body.gc_product,
    };

    update(req, res, id, code);
};

//Libera un código interno.
exports.free = (req, res) => {
    const id = req.params.id;

    //Crea un código interno.
    const code = {
        gc_product: null
    };

    update(req, res, id, code);
};

//Función para actualizar.
function update(req, res, id, code){
    CodeGenerated.update(code, { where: { gc_id: id } })
        .then(num => {
            if (num === 1) {
                res.status(200).json({
                    status: 200,
                    title: "Operación exitosa",
                    message: 'El código interno fue actualizado con éxito.',
                    error: null,
                    value: num
                });
            }
            else {
                res.status(501).json({
                    status: 501,
                    title: "Error 501",
                    message: 'Error::CodeGenerated.update(): No se pudo efectuar la actualización del código interno. Compruebe los datos e intente nuevamente.',
                    error: null,
                    value: null
                });
            }
        })
        .catch(err => {
            res.status(500).json({
                status: 500,
                title: "Error 500",
                message: 'Error::CodeGenerated.update(): Ocurrió un problema al actualizar el código interno en la base de datos.',
                error: err,
                value: null
            });
        });
}