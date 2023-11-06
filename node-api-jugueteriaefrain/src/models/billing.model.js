///Construye el modelo para billings.
module.exports = (sequelize, Sequelize) => {

    return sequelize.define(
        "billings",
        {
            db_id: {
                type: Sequelize.INTEGER,
                primaryKey: true,
                autoIncrement: true,
            },
            db_distributor: {
                type: Sequelize.SMALLINT,
                allowNull: false,
            },
            db_total: {
                type: Sequelize.NUMERIC(12, 3),
                allowNull: false,
                defaultValue: 0
            },
            db_datetime: {
                type: Sequelize.BIGINT,
                allowNull: false,
                defaultValue: 0
            },
            db_url_file: {
                type: Sequelize.STRING(200),
                allowNull: false
            },
        },
        {
            createdAt: false,
            updatedAt: false,
        }
    );
  };