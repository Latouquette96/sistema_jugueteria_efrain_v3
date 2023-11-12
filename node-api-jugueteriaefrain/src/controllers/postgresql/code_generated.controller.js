const db = require("../../models");
const CodeGenerated = db.code_generated;

const code_generated_controller = {};

//Crear y guardar una nueva factura.
code_generated_controller.create = async (req, res) => {

    //Modelo para crear un nuevo código interno
    const code = {
        cg_product: null,
    };

    //Guarda el código interno en la base de datos.
    await CodeGenerated.create(code)
        .then(data => {
            res.status(201).json({
                status: 201,
                title: "Operación exitosa",
                message: 'El código interno fue creado en la base de datos con éxito.',
                error: null,
                value: {cg_id: data.cg_id}
            });
        })
        .catch(err => {
            res.status(500).json({
                status: 500,
                title: "Error 500",
                message: 'Error::await CodeGenerated.create(): Error al crear el código interno en la base de datos.',
                error: err,
                value: null
            });
        });
};

//Inicializa la tabla con 100 registros (en caso de estar vacía)
code_generated_controller.generateCodeBlock = async (req, res) => {
    try{
        //Recupera la cantidad de códigos generados (tanto utilizados como no).
        const count = await CodeGenerated.count();

        //Si no hay ningún código generado, entonces
        if (count===0){
            await generateCodeBlockAuxasync (req, res);
        }
        else{
            const constWhere = await CodeGenerated.count({
                where: {
                    cg_product: null
                }
            });
            if (constWhere>0){
                res.status(200).json({
                    status: 200,
                    title: "Sin cambios",
                    message: 'No se produjo ningún cambio porque no fue necesario crear 100 registros nuevos.',
                    error: null,
                    value: null
                });
            }
            else{
                await generateCodeBlockAuxasync (req, res);
            }
        }
    }
    catch (e){
        res.status(500).json({
            status: 500,
            title: "Error 500",
            message: 'Error::await CodeGenerated.generateCodeBlock(): Ocurrió un problema al generar bloque de 100 códigos en la base de datos.',
            error: e,
            value: null
        });
    }
};

async function generateCodeBlockAuxasync (req, res){
    const cg = [];
    for (let i=0; i<100; i++){
        cg.push({
            cg_product: null,
        });
    }

    await CodeGenerated.bulkCreate(cg)
        .then(data => {
            res.status(201).json({
                status: 201,
                title: "Operación exitosa",
                message: 'Los códigos internos fueron creados con éxito en la base de datos.',
                error: null,
                value: data
            });
        })
        .catch(err => {
                res.status(500).json({
                    status: 500,
                    title: "Error 500",
                    message: 'Error::await CodeGenerated.initialize(): Error al crear bloque de 100 códigos en la base de datos.',
                    error: err,
                    value: null
                });
            }
        );
}

//Realiza la busqueda de un código interno por el identificador del producto.
code_generated_controller.findByProduct = async (req, res) => {
    const cg_id = req.body.cg_id;

    await CodeGenerated.findAll({where: {cg_product: cg_id}})
        .then(data => {
            console.log(data);
            res.status(200).json({
                status: 200,
                title: "Operación exitosa",
                message: 'El código interno fue recuperado de la base de datos con éxito.',
                error: null,
                value: data
            });
        })
        .catch(error => {
            res.status(500).json({
                status: 500,
                title: "Error 500",
                message: 'Error::await CodeGenerated.findByProduct(): Ocurrió un problema al recuperar el código interno de la base de datos.',
                error: error,
                value: null
            });
        });
};

//Realiza la busqueda de un código interno que esté libre (o lo crea y lo retorna).
code_generated_controller.findFirstFree = async (req, res) => {
    await CodeGenerated.findOne({
        where: {cg_product: null}
    },)
        .then(data => {
            res.status(200).json({
                status: 200,
                title: "Operación exitosa",
                message: 'El código interno fue recuperado de la base de datos con éxito.',
                error: null,
                value: data.cg_id
            });
        })
        .catch(error => {
            console.log(error);
            res.status(500).json({
                status: 500,
                title: "Error 500",
                message: 'Error::await CodeGenerated.findOne(): Ocurrió un problema al recuperar el código interno de la base de datos.',
                error: error,
                value: null
            });
        });
};

//Establece un producto para un código interno con identificador id.
code_generated_controller.updateState = async (req, res) => {
    const id = req.params.id;

    //Crea un código interno.
    const code = {
        cg_product: req.body.cg_product,
    };

    await update(req, res, id, code);
};

//Libera un código interno.
code_generated_controller.free = async (req, res) => {
    const id = req.params.id;

    //Crea un código interno.
    const code = {
        cg_product: null
    };

    await update(req, res, id, code);
};

//Función para actualizar.
async function update(req, res, id, code){
    await CodeGenerated.update(code, {
        where: {
            cg_id: id
        }})
        .then(num => {
            console.log(num);
            if (num[0] === 1) {
                res.status(200).json({
                    status: 200,
                    title: "Operación exitosa",
                    message: 'El código interno fue actualizado con éxito.',
                    error: null,
                    value: num[0]
                });
            }
            else {
                res.status(501).json({
                    status: 501,
                    title: "Error 501",
                    message: 'Error::await CodeGenerated.update(): No se pudo efectuar la actualización del código interno. Compruebe los datos e intente nuevamente.',
                    error: null,
                    value: null
                });
            }
        })
        .catch(err => {
            res.status(500).json({
                status: 500,
                title: "Error 500",
                message: 'Error::await CodeGenerated.update(): Ocurrió un problema al actualizar el código interno en la base de datos.',
                error: err,
                value: null
            });
        });
}

module.exports = code_generated_controller;