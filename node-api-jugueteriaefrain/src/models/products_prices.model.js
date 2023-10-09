///Construye el modelo para billings.
module.exports = (sequelize, Sequelize) => {

    const ProductPrices = sequelize.define(
        "products_prices", 
        {
            pp_id: {
                type: Sequelize.INTEGER,
                primaryKey: true,
                autoIncrement: true,
            },
            pp_product: {
                type: Sequelize.INTEGER,
                allowNull: true,
            },
            pp_distributor: {
                type: Sequelize.INTEGER,
                allowNull: true
            },
            pp_price_base: {
                type: Sequelize.NUMERIC(10,2),
                allowNull: true,
                defaultValue: 0
            },
            pp_date_update: {
                type: Sequelize.BIGINT,
                allowNull: true
            },
        },
        {
            createdAt: false,
            updatedAt: false,
        }
    );
  
    return ProductPrices;
  };