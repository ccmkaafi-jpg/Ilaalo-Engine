package com.ilaalo.engine.services

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.provider.Telephony
import org.json.JSONArray
import org.json.JSONObject
import java.security.MessageDigest

class ZaadSmsReceiver : BroadcastReceiver() {

    companion object {
        const val PREFS_NAME = "ilaalo_zaad_sms"
        const val QUEUE_KEY = "pending_messages"
    }

    override fun onReceive(context: Context, intent: Intent) {
        if (intent.action != Telephony.Sms.Intents.SMS_RECEIVED_ACTION) {
            return
        }

        val messages = Telephony.Sms.Intents.getMessagesFromIntent(intent)
        if (messages.isEmpty()) return

        val sender = messages.firstOrNull()?.originatingAddress ?: return
        val digits = sender.filter { it.isDigit() }

        // Marxaladdan waxaan aqbalaynaa sender-ka gaaban ee 898 oo keliya.
        if (sender.trim() != "898" && digits != "898") return

        val body = messages.joinToString(separator = "") {
            it.messageBody.orEmpty()
        }.trim()

        if (body.isEmpty()) return

        val timestamp = messages.minOf { it.timestampMillis }
        val rawId = "$sender|$timestamp|$body"
        val id = MessageDigest.getInstance("SHA-256")
            .digest(rawId.toByteArray(Charsets.UTF_8))
            .joinToString("") { "%02x".format(it) }

        val prefs = context.getSharedPreferences(
            PREFS_NAME,
            Context.MODE_PRIVATE
        )

        val oldQueue = try {
            JSONArray(prefs.getString(QUEUE_KEY, "[]") ?: "[]")
        } catch (_: Exception) {
            JSONArray()
        }

        // Ka hortag in isla SMS-ka laba jeer la geliyo.
        for (i in 0 until oldQueue.length()) {
            if (oldQueue.optJSONObject(i)?.optString("id") == id) {
                return
            }
        }

        val event = JSONObject()
            .put("id", id)
            .put("sender", sender)
            .put("body", body)
            .put("timestamp", timestamp)

        val newQueue = JSONArray()

        // Hay dhacdooyinka ugu dambeeya oo keliya.
        val start = (oldQueue.length() - 99).coerceAtLeast(0)
        for (i in start until oldQueue.length()) {
            newQueue.put(oldQueue.getJSONObject(i))
        }
        newQueue.put(event)

        prefs.edit()
            .putString(QUEUE_KEY, newQueue.toString())
            .apply()
    }
}
