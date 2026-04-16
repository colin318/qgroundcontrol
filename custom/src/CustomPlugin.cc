#include "CustomPlugin.h"
#include "FusionStatusTextModel.h"
#include "FusionMissionModel.h"
#include "QGCLoggingCategory.h"

#include <QtCore/QApplicationStatic>
#include <QtCore/QFile>
#include <QtQml/QQmlApplicationEngine>
#include <QtQml/QQmlContext>
#include <QtQml/qqml.h>

QGC_LOGGING_CATEGORY(CustomLog, "Custom.CustomPlugin")

Q_APPLICATION_STATIC(CustomPlugin, _customPluginInstance)

CustomPlugin::CustomPlugin(QObject *parent)
    : QGCCorePlugin(parent)
{
    qWarning() << "[Fusion] CustomPlugin constructed" << this;
}

QGCCorePlugin *CustomPlugin::instance()
{
    return _customPluginInstance();
}

void CustomPlugin::cleanup()
{
    if (_qmlEngine) {
        _qmlEngine->removeUrlInterceptor(_interceptor);
    }
    delete _interceptor;
    _interceptor = nullptr;
}

void CustomPlugin::setFusionDashboardVisible(bool v)
{
    if (_fusionDashboardVisible != v) {
        _fusionDashboardVisible = v;
        emit fusionDashboardVisibleChanged();
    }
}

void CustomPlugin::setFusionPage(int page)
{
    if (_fusionPage != page) {
        _fusionPage = page;
        emit fusionPageChanged();
    }
}

const QVariantList& CustomPlugin::toolBarIndicators()
{
    if (_toolBarIndicators.isEmpty()) {
        const QUrl buttonUrl = QUrl::fromUserInput(QStringLiteral("qrc:/qml/FusionGCS/src/FusionToolBarButton.qml"));
        qWarning() << "[Fusion] CustomPlugin::toolBarIndicators building list; button URL =" << buttonUrl
                   << "exists?" << QFile::exists(QStringLiteral(":/qml/FusionGCS/src/FusionToolBarButton.qml"));
        _toolBarIndicators.append(QVariant::fromValue(buttonUrl));
    }
    return _toolBarIndicators;
}

QQmlApplicationEngine *CustomPlugin::createQmlApplicationEngine(QObject *parent)
{
    _qmlEngine = QGCCorePlugin::createQmlApplicationEngine(parent);

    qmlRegisterType<FusionStatusTextModel>("FusionGCS", 1, 0, "FusionStatusTextModel");
    qmlRegisterType<FusionMissionModel>   ("FusionGCS", 1, 0, "FusionMissionModel");
    _qmlEngine->rootContext()->setContextProperty(QStringLiteral("FusionPlugin"), this);

    _interceptor = new FusionUrlInterceptor();
    _qmlEngine->addUrlInterceptor(_interceptor);

    return _qmlEngine;
}

QUrl FusionUrlInterceptor::intercept(const QUrl &url, QQmlAbstractUrlInterceptor::DataType type)
{
    switch (type) {
    case QQmlAbstractUrlInterceptor::QmlFile:
    case QQmlAbstractUrlInterceptor::UrlString:
        if (url.scheme() == QStringLiteral("qrc")) {
            const QString origPath    = url.path();
            const QString overridePath = QStringLiteral(":/Custom%1").arg(origPath);
            if (QFile::exists(overridePath)) {
                const QString relPath = overridePath.mid(2);
                QUrl result;
                result.setScheme(QStringLiteral("qrc"));
                result.setPath(QLatin1Char('/') + relPath);
                return result;
            }
        }
        break;
    default:
        break;
    }
    return url;
}
