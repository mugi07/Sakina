package com.sakinaapp.sakina

import android.appwidget.AppWidgetManager
import android.content.Context
import android.content.SharedPreferences
import android.graphics.Color
import android.graphics.Typeface
import android.text.SpannableString
import android.text.style.StyleSpan
import android.view.View
import android.widget.RemoteViews
import es.antonborri.home_widget.HomeWidgetLaunchIntent
import es.antonborri.home_widget.HomeWidgetProvider
import org.json.JSONObject

/**
 * Widget « Horaires de prière ».
 *
 * L'app enregistre sous la clé `prayer_widget` les horaires des 7 prochains
 * jours (noms traduits, heures formatées, instants en millisecondes) et
 * programme une mise à jour à chaque heure de prière : le widget choisit
 * lui-même la prochaine prière à partir de l'heure actuelle.
 */
class PrayerTimesWidgetProvider : HomeWidgetProvider() {

  override fun onUpdate(
      context: Context,
      appWidgetManager: AppWidgetManager,
      appWidgetIds: IntArray,
      widgetData: SharedPreferences,
  ) {
    for (id in appWidgetIds) {
      val views = RemoteViews(context.packageName, R.layout.prayer_times_widget)
      views.setOnClickPendingIntent(
          R.id.widget_root,
          HomeWidgetLaunchIntent.getActivity(context, MainActivity::class.java),
      )
      render(views, widgetData.getString("prayer_widget", null))
      appWidgetManager.updateAppWidget(id, views)
    }
  }

  private fun render(views: RemoteViews, json: String?) {
    val data = json?.let { runCatching { JSONObject(it) }.getOrNull() }
    val days = data?.optJSONArray("days")
    if (data == null || days == null || days.length() == 0) {
      showMessage(views, data?.optString("message").orEmpty())
      return
    }

    // Prochaine prière : la première dont l'heure n'est pas passée.
    val now = System.currentTimeMillis()
    var dayIndex = -1
    var prayerIndex = -1
    search@ for (d in 0 until days.length()) {
      val prayers = days.getJSONObject(d).getJSONArray("prayers")
      for (p in 0 until prayers.length()) {
        if (prayers.getJSONObject(p).getLong("at") > now) {
          dayIndex = d
          prayerIndex = p
          break@search
        }
      }
    }
    if (dayIndex < 0) {
      // Horaires périmés : l'app n'a pas été ouverte depuis une semaine.
      showMessage(views, data.optString("staleMessage"))
      return
    }

    val day = days.getJSONObject(dayIndex)
    val prayers = day.getJSONArray("prayers")
    val next = prayers.getJSONObject(prayerIndex)
    views.setViewVisibility(R.id.widget_content, View.VISIBLE)
    views.setViewVisibility(R.id.widget_message, View.GONE)
    views.setTextViewText(
        R.id.widget_title,
        listOf(data.optString("city"), day.optString("hijri")).filter { it.isNotEmpty() }.joinToString(" · "),
    )
    views.setTextViewText(R.id.widget_next_label, data.optString("nextLabel"))
    views.setTextViewText(R.id.widget_next_name, next.getString("name"))
    views.setTextViewText(R.id.widget_next_time, next.getString("time"))

    val nameIds = intArrayOf(R.id.p1_name, R.id.p2_name, R.id.p3_name, R.id.p4_name, R.id.p5_name)
    val timeIds = intArrayOf(R.id.p1_time, R.id.p2_time, R.id.p3_time, R.id.p4_time, R.id.p5_time)
    for (i in 0 until minOf(5, prayers.length())) {
      val p = prayers.getJSONObject(i)
      val highlighted = i == prayerIndex
      views.setTextViewText(nameIds[i], p.getString("name"))
      views.setTextViewText(timeIds[i], bold(p.getString("time"), highlighted))
      val color = if (highlighted) GOLD else Color.WHITE
      views.setTextColor(nameIds[i], color)
      views.setTextColor(timeIds[i], color)
    }
  }

  private fun showMessage(views: RemoteViews, message: String) {
    views.setViewVisibility(R.id.widget_content, View.GONE)
    views.setViewVisibility(R.id.widget_message, View.VISIBLE)
    views.setTextViewText(R.id.widget_message, message.ifEmpty { "Zahrae Noor  —  زهراء نور" })
  }

  private fun bold(text: String, bold: Boolean): CharSequence {
    if (!bold) return text
    return SpannableString(text).apply { setSpan(StyleSpan(Typeface.BOLD), 0, length, 0) }
  }

  private companion object {
    val GOLD = Color.parseColor("#F2D28B")
  }
}
