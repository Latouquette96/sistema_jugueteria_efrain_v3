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
                allowNull: false,
            },
            pp_distributor: {
                type: Sequelize.INTEGER,
                allowNull: false
            },
            pp_price_base: {
                type: Sequelize.NUMERIC(10,2),
                allowNull: false,
                defaultValue: 0
            },
            pp_date_update: {
                type: Sequelize.BIGINT,
                allowNull: false
            },
            pp_website: {
                type: Sequelize.STRING(150),
                allowNull: true,
            },
        },
        {
            createdAt: false,
            updatedAt: false,
        }
    );
  
    return ProductPrices;
  };