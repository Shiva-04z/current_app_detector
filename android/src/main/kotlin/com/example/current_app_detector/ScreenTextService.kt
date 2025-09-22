package com.example.current_app_detector
import android.accessibilityservice.AccessibilityService
import android.view.accessibility.AccessibilityEvent
import android.view.accessibility.AccessibilityNodeInfo
import android.text.TextUtils
import android.accessibilityservice.AccessibilityServiceInfo



class ScreenTextService : AccessibilityService() {

    companion object {
        private var instance: ScreenTextService? = null

        /**
         * Retrieves text from the currently active window.
         * This is called by the plugin to get all text visible on the screen.
         */
        fun getScreenTextCombined(): String {
            if (instance == null) {
                return "Accessibility service is not running."
            }
            val rootNode = instance?.rootInActiveWindow
                ?: return "Could not get the root node. The screen might be empty or locked."
            
            val sb = StringBuilder()
            getTextFromNode(rootNode, sb)
            rootNode.recycle() // Important to recycle the node to avoid memory leaks
            return sb.toString().trim()
        }

        /**
         * Recursively traverses the view hierarchy to extract visible text from nodes.
         */
        private fun getTextFromNode(node: AccessibilityNodeInfo?, builder: StringBuilder) {
            if (node == null) return

            // If the node has text, and it's visible, add it.
            if (!TextUtils.isEmpty(node.text) && node.isVisibleToUser) {
                builder.append(node.text).append("\n")
            }

            // Recursively check all children.
            for (i in 0 until node.childCount) {
                val child = node.getChild(i)
                getTextFromNode(child, builder)
                child?.recycle() // Recycle child node after use
            }
        }
    }

   override fun onServiceConnected() {
    super.onServiceConnected()
    instance = this

    // Optional: configure service info
    val serviceInfo = serviceInfo.apply {
        eventTypes = AccessibilityEvent.TYPES_ALL_MASK
        feedbackType = AccessibilityServiceInfo.FEEDBACK_GENERIC
        flags = AccessibilityServiceInfo.DEFAULT
        notificationTimeout = 100
    }
    this.serviceInfo = serviceInfo
}


    override fun onAccessibilityEvent(event: AccessibilityEvent?) {
        // This service fetches text on demand via the static method,
        // so we don't need to process events here continuously.
    }

    override fun onInterrupt() {
        // Called when the service is interrupted.
    }

    override fun onDestroy() {
        super.onDestroy()
        instance = null
    }
}