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

import com.simitron.apps_utils.AppInfo

class AppFetcher(private val context: Context) {
    /// Get all installed apps.
    /// 
    /// @param appType: The type of apps to get.
    /// @param includeIcons: Whether to include icons in the returned apps.
    /// @return A list of AppInfo objects.
    fun getInstalledApps(appType: String, includeIcons: Boolean): List<AppInfo> {
        val apps = mutableListOf<AppInfo>()
        try {
            val pm = context.packageManager
            Log.d("AppFetcher", "Starting to fetch apps with type: $appType")
            
            // This is how launchers get their app list
            val mainIntent = Intent(Intent.ACTION_MAIN, null)
            mainIntent.addCategory(Intent.CATEGORY_LAUNCHER)
            
            // Get all apps that can be launched from home screen
            val resolveInfos = pm.queryIntentActivities(mainIntent, 0)
            Log.d("AppFetcher", "Found ${resolveInfos.size} launchable apps")

            // Create a list to sort
            val unsortedApps = mutableListOf<Pair<String, AppInfo>>()

            resolveInfos.forEach { resolveInfo ->
                try {
                    val appInfo = resolveInfo.activityInfo.applicationInfo
                    val isSystemApp = (appInfo.flags and ApplicationInfo.FLAG_SYSTEM) != 0
                    
                    // Filter based on appType
                    when (appType) {
                        "system" -> if (!isSystemApp) return@forEach
                        "user" -> if (isSystemApp) return@forEach
                    }
                    
                    if (appInfo.packageName.startsWith("com.android.")) {
                        val skipPackages = setOf(
                            "com.android.cts",
                            "com.android.providers",
                            "com.android.server",
                            "com.android.systemui"
                        )
                        if (skipPackages.any { appInfo.packageName.startsWith(it) }) {
                            return@forEach
                        }
                    }
                    
                    val appName = resolveInfo.loadLabel(pm).toString()
                    // Create mutable AppInfo object
                    val appDetails = AppInfo(
                        packageName = appInfo.packageName,
                        appName = appName,
                        isSystemApp = isSystemApp,
                        icon = null  // Initialize with null, will be set later if needed
                    )
                    
                    if (includeIcons) {
                        try {
                            val icon = resolveInfo.loadIcon(pm)
                            val bitmap = drawableToBitmap(icon)
                            val stream = ByteArrayOutputStream()
                            bitmap.compress(Bitmap.CompressFormat.PNG, 100, stream)
                            appDetails.icon = stream.toByteArray()
                        } catch (e: Exception) {
                            Log.e("AppFetcher", "Error getting icon for ${appInfo.packageName}", e)
                            // No need to set icon to null as it's already null
                        }
                    }
                    
                    // Add to unsorted list with name for sorting
                    unsortedApps.add(Pair(appName.lowercase(), appDetails))
                    
                } catch (e: Exception) {
                    Log.e("AppFetcher", "Error processing app", e)
                }
            }
            
            // Sort by name (case-insensitive) and add to final list
            apps.addAll(unsortedApps.sortedBy { it.first }.map { it.second })
            
            Log.d("AppFetcher", "Successfully processed ${apps.size} apps")
            return apps
            
        } catch (e: Exception) {
            Log.e("AppFetcher", "Fatal error in getInstalledApps", e)
            throw e
        }
    }
    
    /// Convert a Drawable to a Bitmap.
    /// 
    /// @param drawable: The Drawable to convert.
    /// @return A Bitmap.
    private fun drawableToBitmap(drawable: Drawable): Bitmap {
        try {
            if (drawable is BitmapDrawable) {
                return drawable.bitmap
            }
            
            val width = if (drawable.intrinsicWidth <= 0) 1 else drawable.intrinsicWidth
            val height = if (drawable.intrinsicHeight <= 0) 1 else drawable.intrinsicHeight
            
            val bitmap = Bitmap.createBitmap(
                width,
                height,
                Bitmap.Config.ARGB_8888
            )
            val canvas = Canvas(bitmap)
            drawable.setBounds(0, 0, canvas.width, canvas.height)
            drawable.draw(canvas)
            return bitmap
        } catch (e: Exception) {
            Log.e("AppFetcher", "Error converting drawable to bitmap", e)
            throw e
        }
    }
} 