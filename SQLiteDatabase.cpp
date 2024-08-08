#include "SQLiteDatabase.h"
#include <iostream>
SQLiteDatabase::SQLiteDatabase(QObject *parent) : QObject(parent)
{
    db = QSqlDatabase::addDatabase("QSQLITE");
}

bool SQLiteDatabase::openDatabase(const QString &dbName)
{
    db.setDatabaseName(dbName);
    bool b = db.open();

    if (!b)
    {
        QString sMsg;
        sMsg = QString("[%1] [%2] %3").arg(__LINE__).arg(__FUNCTION__).arg(db.lastError().text());
        SetError(sMsg);
    }
    else
    {
        SetError("");
    }
    return b;
}

void SQLiteDatabase::close()
{
    db.close();
}

bool SQLiteDatabase::isTableExists(const QString &tableName)
{
    QSqlQuery query(db);
    QString sql = QString("SELECT [name] FROM sqlite_master WHERE [type] = 'table' AND [name]=?").arg(tableName);
    query.prepare(sql);
    query.bindValue(0, tableName);
    bool b = query.exec() && query.next();
    if (!b)
    {
        QString sMsg;
        sMsg = QString("[%1] [%2] %3").arg(__LINE__).arg(__FUNCTION__).arg(query.lastError().text());
        SetError(sMsg);
    }
    else
    {
        SetError("");
    }
    return b;
}

bool SQLiteDatabase::insertData(const QString& tableName, const QVariantMap& data)
{
    QStringList columns, values;
    for (auto it = data.begin(); it != data.end(); ++it) {
        columns << it.key();
        values << ":" + it.key();
    }

    QString sql = QString("INSERT INTO %1 (%2) VALUES (%3)")
            .arg(tableName)
            .arg(columns.join(","))
            .arg(values.join(","));

    QSqlQuery query(db);
    query.prepare(sql);
    for (auto it = data.begin(); it != data.end(); ++it) {
        query.bindValue(":" + it.key(), it.value());
    }
    bool b = query.exec();
    if (!b)
    {
        QString sMsg;
        sMsg = QString("[%1] [%2] %3").arg(__LINE__).arg(__FUNCTION__).arg(query.lastError().text());
        SetError(sMsg);
    }
    else
    {
        SetError("");
    }
    return b;
}

bool SQLiteDatabase::RunSql(const QString& strSql)
{
    QSqlQuery query(db);
    query.prepare(strSql);
    bool b = query.exec();
    if (!b)
    {
        QString sMsg;
        sMsg = QString("[%1] [%2] %3").arg(__LINE__).arg(__FUNCTION__).arg(query.lastError().text());
        SetError(sMsg);
    }
    else
    {
        SetError("");
    }
    return b;
}


bool SQLiteDatabase::GetTable(const QString& strSql,QVector<QStringList>& tbData)
{
    QSqlQuery query;
    if (!query.prepare(strSql)) {
        QString sMsg;
        sMsg = QString("[%1] [%2] %3").arg(__LINE__).arg(__FUNCTION__).arg(query.lastError().text());
        SetError(sMsg);
        return false;
    }
    if (!query.exec())
    {
        QString sMsg;
        sMsg = QString("[%1] [%2] %3").arg(__LINE__).arg(__FUNCTION__).arg(query.lastError().text());
        SetError(sMsg);
        return false;
    }
    // 获取查询结果
    while (query.next()) {
        QStringList rowData;
        for (int i = 0; i < query.record().count(); ++i) {
            rowData.append(query.value(i).toString());
        }
        tbData.append(rowData);
    }
    return true;
}

QString SQLiteDatabase::GetLastError()
{
    return m_sError;
}

void SQLiteDatabase::SetError(const QString& sError)
{
    m_sError = sError;
}
