///Construye el modelo para la generacion de códigos internos.
module.exports = (sequelize, Sequelize) => {

    return sequelize.define(
        "code_generated",
        {
            cg_id: {
                type: Sequelize.INTEGER,
                primaryKey: true,
                autoIncrement: true,
            },
            cg_product: {
                type: Sequelize.INTEGER,
                allowNull: true
            },
        },
        {
            createdAt: false,
            updatedAt: false,
        }
    );
};