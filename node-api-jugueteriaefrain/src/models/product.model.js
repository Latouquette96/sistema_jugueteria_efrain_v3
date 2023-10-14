///Construye el modelo para products.
module.exports = (sequelize, Sequelize) => {

    const Product = sequelize.define(
        "products", 
        {
            p_id: {
                type: Sequelize.INTEGER,
                primaryKey: true,
                autoIncrement: true,
            },
            p_barcode: {
                type: Sequelize.STRING(48),
                allowNull: true,
                unique: true
            },
            p_internal_code: {
                type: Sequelize.STRING(10),
                allowNull: true,
                unique: true
            },
            p_title: {
                type: Sequelize.STRING(65),
                allowNull: false,
                unique: true
            },
            p_description: {
                type: Sequelize.STRING(9999),
                allowNull: false
            },
            p_brand: {
                type: Sequelize.STRING(100),
                allowNull: false,
                defaultValue: "IMPORT."
            },
            p_price_public: {
                type: Sequelize.NUMERIC(8,2),
                allowNull: false,
                defaultValue: 0.00
            },
            p_stock: {
                type: Sequelize.INTEGER,
                allowNull: false,
                defaultValue: 0
            },
            p_subcategory: {
                type: Sequelize.INTEGER,
                allowNull: false,
                defaultValue: 0
            },
            p_images: {
                type: Sequelize.STRING(3000),
                allowNull: true,
                defaultValue: 'https://drive.google.com/uc?export=view&id=1Mh8yFhGtvhq7AkKzs09jad8d5pjwADKi'
            },
            p_sizes: {
                type: Sequelize.STRING(500),
                allowNull: true,
            },
            p_date_updated: {
                type: Sequelize.BIGINT,
                defaultValue: 0
            },
            p_date_created: {
                type: Sequelize.BIGINT,
                defaultValue: 0
            },
            p_minimum_age: {
                type: Sequelize.SMALLINT,
                defaultValue: 1
            }
        },
        {
            createdAt: false,
            updatedAt: false,
        }
    );
  
    return Product;
  };