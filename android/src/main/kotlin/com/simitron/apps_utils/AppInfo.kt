package com.simitron.apps_utils

data class AppInfo(
    val packageName: String,
    val appName: String,
    val isSystemApp: Boolean,
    var icon: ByteArray? = null
) {
    fun toMap(): Map<String, Any?> {
        val map = mapOf(
            "packageName" to packageName,
            "appName" to appName,
            "isSystemApp" to isSystemApp,
            "icon" to icon
        )
        return map
    }

    override fun toString(): String {
        return "AppInfo(name=$appName, package=$packageName, system=$isSystemApp, hasIcon=${icon != null})"
    }
}