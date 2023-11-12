const {Model} = require('sequelize');

///Construye el modelo para la generacion de códigos internos.
module.exports = (sequelize, DataTypes) => {

    class CodeGenerated extends Model {}

    CodeGenerated.init(
        {
            cg_id: {
                type: DataTypes.INTEGER,
                primaryKey: true,
                autoIncrement: true,
            },
            cg_product: {
                type: DataTypes.INTEGER,
                allowNull: true
            },
        },
        {
            sequelize,
            tableName: "code_generateds",
            createdAt: false,
            updatedAt: false,
        }
    );

    return CodeGenerated;
};