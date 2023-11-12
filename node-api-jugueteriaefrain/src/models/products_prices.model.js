const {Model} = require('sequelize');

///Construye el modelo para billings.
module.exports = (sequelize, DataTypes) => {

    class ProductPrices extends Model {}

    ProductPrices.init(
        {
            pp_id: {
                type: DataTypes.INTEGER,
                primaryKey: true,
                autoIncrement: true,
            },
            pp_internal_code: {
                type: DataTypes.STRING(20),
                allowNull: true,
            },
            pp_product: {
                type: DataTypes.INTEGER,
                allowNull: false,
            },
            pp_distributor: {
                type: DataTypes.INTEGER,
                allowNull: false
            },
            pp_price_base: {
                type: DataTypes.DECIMAL(10, 2),
                allowNull: false,
                defaultValue: 0
            },
            pp_date_update: {
                type: DataTypes.BIGINT,
                allowNull: false
            },
            pp_website: {
                type: DataTypes.STRING(150),
                allowNull: true,
            },
        },
        {
            sequelize,
            tableName: "product_prices",
            createdAt: false,
            updatedAt: false,
        }
    );

    return ProductPrices;
  };