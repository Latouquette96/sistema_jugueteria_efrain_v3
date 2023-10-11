///Construye el modelo para distributors.
module.exports = (sequelize, Sequelize) => {

    const Distributors = sequelize.define(
        "distributors", 
        {
            d_id: {
                type: Sequelize.INTEGER,
                primaryKey: true,
                autoIncrement: true,
            },
            d_cuit: {
                type: Sequelize.STRING(13),
                allowNull: true,
                unique: false
            },
            d_name: {
                type: Sequelize.STRING(50),
                allowNull: false,
            },
            d_address: {
                type: Sequelize.STRING(75),
                allowNull: true,
            },
            d_email: {
                type: Sequelize.STRING(150),
                allowNull: true
            },
            d_cel: {
                type: Sequelize.STRING(15),
                allowNull: true,
            },
            d_website: {
                type: Sequelize.STRING(150),
                allowNull: true,
            },
            d_iva: {
                type: Sequelize.DECIMAL(3,2),
                allowNull: false,
                defaultValue: 1.00
            }
        },
        {
            createdAt: false,
            updatedAt: false,
        }
    );
  
    return Distributors;
  };