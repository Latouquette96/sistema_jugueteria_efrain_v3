const {Model} = require('sequelize');

///Construye el modelo para products.
module.exports = (sequelize, DataTypes) => {
    class Product extends Model {}

    Product.init(
        {
            p_id: {
                type: DataTypes.INTEGER,
                primaryKey: true,
                autoIncrement: true,
            },
            p_barcode: {
                type: DataTypes.STRING(48),
                allowNull: true,
                unique: true
            },
            p_title: {
                type: DataTypes.STRING(65),
                allowNull: false,
                unique: true
            },
            p_description: {
                type: DataTypes.STRING(9999),
                allowNull: false
            },
            p_brand: {
                type: DataTypes.STRING(100),
                allowNull: false,
                defaultValue: "IMPORT."
            },
            p_price_public: {
                type: DataTypes.DECIMAL(8, 2),
                allowNull: false,
                defaultValue: 0.00
            },
            p_stock: {
                type: DataTypes.INTEGER,
                allowNull: false,
                defaultValue: 0
            },
            p_subcategory: {
                type: DataTypes.INTEGER,
                allowNull: false,
                defaultValue: 0
            },
            p_images: {
                type: DataTypes.STRING(3000),
                allowNull: true,
                defaultValue: 'https://drive.google.com/uc?export=view&id=1Mh8yFhGtvhq7AkKzs09jad8d5pjwADKi'
            },
            p_sizes: {
                type: DataTypes.STRING(500),
                allowNull: true,
            },
            p_date_updated: {
                type: DataTypes.BIGINT,
                defaultValue: 0
            },
            p_date_created: {
                type: DataTypes.BIGINT,
                defaultValue: 0
            },
            p_minimum_age: {
                type: DataTypes.SMALLINT,
                defaultValue: 1
            }
        },
        {
            sequelize,
            createdAt: false,
            updatedAt: false,
            tableName: "products"
            //freezeTableName: true //Previene el plural del nombre de la tabla.
        }
    )

    return Product;
};