const {Model} = require('sequelize');

///Construye el modelo para billings.
module.exports = (sequelize, DataTypes) => {

    class Billing extends Model {}

    Billing.init(
        {
            db_id: {
                type: DataTypes.INTEGER,
                primaryKey: true,
                autoIncrement: true,
            },
            db_distributor: {
                type: DataTypes.SMALLINT,
                allowNull: false,
            },
            db_total: {
                type: DataTypes.DECIMAL(12, 3),
                allowNull: false,
                defaultValue: 0
            },
            db_datetime: {
                type: DataTypes.BIGINT,
                allowNull: false,
                defaultValue: 0
            },
            db_url_file: {
                type: DataTypes.STRING(200),
                allowNull: false
            },
        },
        {
            sequelize,
            tableName: "billings",
            createdAt: false,
            updatedAt: false,
        }
    );

    return Billing;
  };