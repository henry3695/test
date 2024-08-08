#ifndef SQLITEDATABASE_H
#define SQLITEDATABASE_H

#include <QObject>
#include <QtSql>
#include <QDebug>
#include <QVector>
class SQLiteDatabase : public QObject
{
    Q_OBJECT
public:
    explicit SQLiteDatabase(QObject *parent = nullptr);

    bool openDatabase(const QString &dbName);
    void close();
       // 新增方法：检查表是否存在
    bool isTableExists(const QString &tableName);
    bool insertData(const QString& tableName, const QVariantMap& data);
    bool RunSql(const QString& strSql);
    bool GetTable(const QString& strSql,QVector<QStringList>& tbData);

    QString GetLastError();

   private:
       QSqlDatabase db;
       QString m_sError;

       void SetError(const QString& sError);
       
};

#endif // SQLITEDATABASE_H
