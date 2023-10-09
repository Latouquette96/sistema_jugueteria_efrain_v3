///Construye el modelo para billings.
module.exports = (sequelize, Sequelize) => {

    const Billings = sequelize.define(
        "billings", 
        {
            db_id: {
                type: Sequelize.INTEGER,
                primaryKey: true,
                autoIncrement: true,
            },
            db_distributor: {
                type: Sequelize.SMALLINT,
                allowNull: true,
            },
            db_total: {
                type: Sequelize.NUMERIC(12,3),
                allowNull: true,
                defaultValue: 0
            },
            db_datetime: {
                type: Sequelize.BIGINT,
                allowNull: true,
                defaultValue: 0
            },
            db_url_file: {
                type: Sequelize.STRING(200),
                allowNull: true
            },
        },
        {
            createdAt: false,
            updatedAt: false,
        }
    );
  
    return Billings;
  };