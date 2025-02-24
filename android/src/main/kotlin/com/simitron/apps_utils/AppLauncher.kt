package com.simitron.apps_utils

import android.content.Context
import android.content.Intent
import android.content.pm.ApplicationInfo
import android.content.pm.PackageManager
import android.content.pm.ResolveInfo
import android.graphics.Bitmap
import android.graphics.Canvas
import android.graphics.drawable.BitmapDrawable
import android.graphics.drawable.Drawable
import java.io.ByteArrayOutputStream
import android.util.Log
import android.provider.MediaStore
import android.provider.AlarmClock
import android.content.ActivityNotFoundException

class AppLauncher(private val context: Context) {
    /// Open a specific system application.
    /// 
    /// @param appName: The name of the app to open.
    /// @throws Exception if the app is not installed.
    fun openSystemApp(appName: String) {
        val intent = when (appName.toLowerCase()) {
            "calendar" -> Intent(Intent.ACTION_MAIN).apply {
                addCategory(Intent.CATEGORY_APP_CALENDAR)
            }
            "camera" -> Intent(MediaStore.ACTION_IMAGE_CAPTURE).apply {
                addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
            }
            "camera_video" -> Intent(MediaStore.ACTION_VIDEO_CAPTURE).apply {
                addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
            }
            "clock" -> Intent(AlarmClock.ACTION_SHOW_ALARMS)
            "phone" -> Intent(Intent.ACTION_DIAL)
            "settings" -> Intent(android.provider.Settings.ACTION_SETTINGS).apply {
                addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
            }
            else -> throw Exception("Invalid application: $appName")
        }

        try {
            context.startActivity(intent)
        } catch (e: ActivityNotFoundException) {
            throw Exception("The requested app is not installed")
        }
    }

    /// Launch the app with the given package name.
    fun launchApp(packageName: String) {
        try {
            val intent = context.packageManager.getLaunchIntentForPackage(packageName)
            if (intent != null) {
                intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
                context.startActivity(intent)
            } else {
                throw Exception("Unable to launch app: $packageName")
            }
        } catch (e: Exception) {
            throw Exception("Failed to launch app: ${e.message}")
        }
    }

    /// Open the settings for the app with the given package name.
    fun openAppSettings(packageName: String) {
        try {
            val intent = Intent(android.provider.Settings.ACTION_APPLICATION_DETAILS_SETTINGS).apply {
                addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
                data = android.net.Uri.parse("package:$packageName")
            }
            context.startActivity(intent)
        } catch (e: Exception) {
            throw Exception("Failed to open app settings: ${e.message}")
        }
    }
} 