package com.ilaalo.engine.accessibility

import android.accessibilityservice.AccessibilityService
import android.view.accessibility.AccessibilityEvent

class IlaaloAccessibilityService : AccessibilityService() {

    override fun onAccessibilityEvent(event: AccessibilityEvent?) {
        if (event == null) return

        val text = event.text?.joinToString(" ") ?: ""

        if (text.isNotBlank()) {
            android.util.Log.d(
                "IlaaloAccessibility",
                "Screen text: $text"
            )
        }
    }

    override fun onInterrupt() {
        android.util.Log.d(
            "IlaaloAccessibility",
            "Accessibility service interrupted"
        )
    }
}
