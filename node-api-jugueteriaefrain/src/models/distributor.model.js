const {Model} = require('sequelize');

///Construye el modelo para distributors.
module.exports = (sequelize, DataTypes) => {

    class Distributor extends Model {}

    Distributor.init(
        {
            d_id: {
                type: DataTypes.INTEGER,
                primaryKey: true,
                autoIncrement: true,
            },
            d_cuit: {
                type: DataTypes.STRING(13),
                allowNull: true,
                unique: false
            },
            d_name: {
                type: DataTypes.STRING(50),
                allowNull: false,
            },
            d_address: {
                type: DataTypes.STRING(75),
                allowNull: true,
            },
            d_email: {
                type: DataTypes.STRING(150),
                allowNull: true
            },
            d_cel: {
                type: DataTypes.STRING(15),
                allowNull: true,
            },
            d_website: {
                type: DataTypes.STRING(150),
                allowNull: true,
            },
            d_iva: {
                type: DataTypes.DECIMAL(3, 2),
                allowNull: false,
                defaultValue: 1.00
            }
        },
        {
            sequelize,
            tableName: "distributors",
            createdAt: false,
            updatedAt: false,
        }
    );

    return Distributor;
  };