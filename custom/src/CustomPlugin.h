#pragma once

#include <QtQml/QQmlAbstractUrlInterceptor>

#include "QGCCorePlugin.h"

class QQmlApplicationEngine;

Q_DECLARE_LOGGING_CATEGORY(CustomLog)

class CustomPlugin : public QGCCorePlugin
{
    Q_OBJECT

    Q_PROPERTY(bool fusionDashboardVisible
               READ  fusionDashboardVisible
               WRITE setFusionDashboardVisible
               NOTIFY fusionDashboardVisibleChanged)

    Q_PROPERTY(int fusionPage
               READ  fusionPage
               WRITE setFusionPage
               NOTIFY fusionPageChanged)

public:
    explicit CustomPlugin(QObject *parent = nullptr);

    static QGCCorePlugin *instance();

    bool fusionDashboardVisible() const { return _fusionDashboardVisible; }
    void setFusionDashboardVisible(bool v);

    int  fusionPage() const { return _fusionPage; }
    void setFusionPage(int page);

    // Overrides from QGCCorePlugin
    void               cleanup() final;
    const QVariantList& toolBarIndicators() final;
    QQmlApplicationEngine *createQmlApplicationEngine(QObject *parent) final;

signals:
    void fusionDashboardVisibleChanged();
    void fusionPageChanged();

private:
    bool         _fusionDashboardVisible = false;
    int          _fusionPage             = 0;
    QVariantList _toolBarIndicators;

    QQmlApplicationEngine *_qmlEngine = nullptr;
    class FusionUrlInterceptor *_interceptor = nullptr;
};

class FusionUrlInterceptor : public QQmlAbstractUrlInterceptor
{
public:
    FusionUrlInterceptor() : QQmlAbstractUrlInterceptor() {}
    QUrl intercept(const QUrl &url, QQmlAbstractUrlInterceptor::DataType type) final;
};
