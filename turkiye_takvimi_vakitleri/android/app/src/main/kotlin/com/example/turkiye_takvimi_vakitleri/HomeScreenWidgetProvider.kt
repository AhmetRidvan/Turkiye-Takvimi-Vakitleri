package com.example.turkiye_takvimi_vakitleri

import android.appwidget.AppWidgetManager
import android.content.Context
import android.content.SharedPreferences
import android.widget.RemoteViews
import es.antonborri.home_widget.HomeWidgetLaunchIntent
import es.antonborri.home_widget.HomeWidgetProvider

class HomeScreenWidgetProvider : HomeWidgetProvider() {
    override fun onUpdate(
        context: Context,
        appWidgetManager: AppWidgetManager,
        appWidgetIds: IntArray,
        widgetData: SharedPreferences
    ) {
        appWidgetIds.forEach { widgetId ->
            val views = RemoteViews(context.packageName, R.layout.widget_layout).apply {

                // App açma tıklaması
                val pendingIntent = HomeWidgetLaunchIntent.getActivity(
                    context,
                    MainActivity::class.java
                )
                setOnClickPendingIntent(R.id.widget_root, pendingIntent)

                // Flutter'dan gelen verileri al
                val imsak = widgetData.getString("_imsak", "İmsak") ?: "İmsak"
                val sabah = widgetData.getString("_sabah", "Sabah") ?: "Sabah"
                val gunes = widgetData.getString("_gunes", "Güneş") ?: "Güneş"
                val ogle = widgetData.getString("_ogle", "Öğle") ?: "Öğle"
                val ikindi = widgetData.getString("_ikindi", "İkindi") ?: "İkindi"
                val aksam = widgetData.getString("_aksam", "Akşam") ?: "Akşam"
                val yatsi = widgetData.getString("_yatsi", "Yatsı") ?: "Yatsı"

                // TextView'lere verileri yerleştir
                setTextViewText(R.id.tv_imsak, "İmsak: $imsak")
                setTextViewText(R.id.tv_sabah, "Sabah: $sabah")
                setTextViewText(R.id.tv_gunes, "Güneş: $gunes")
                setTextViewText(R.id.tv_ogle, "Öğle: $ogle")
                setTextViewText(R.id.tv_ikindi, "İkindi: $ikindi")
                setTextViewText(R.id.tv_aksam, "Akşam: $aksam")
                setTextViewText(R.id.tv_yatsi, "Yatsı: $yatsi")
            }

            appWidgetManager.updateAppWidget(widgetId, views)
        }
    }
}
