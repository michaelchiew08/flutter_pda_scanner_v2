package com.ztt.flutter_pda_scanner_v2

import android.app.Activity
import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.content.IntentFilter
import android.util.Log
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.BinaryMessenger

class PdaScannerPlugin: FlutterPlugin, EventChannel.StreamHandler, ActivityAware {
  private companion object {
    private const val CHANNEL = "com.ztt.flutter_pda_scanner_v2/plugin"
    private const val XM_SCAN_ACTION = "com.android.server.scannerservice.broadcast"
    private const val SHINIOW_SCAN_ACTION = "com.android.server.scannerservice.shinow"
    private const val IDATA_SCAN_ACTION = "android.intent.action.SCANRESULT"
    private const val YBX_SCAN_ACTION = "android.intent.ACTION_DECODE_DATA"
    private const val PL_SCAN_ACTION = "scan.rcv.message"
    private const val BARCODE_DATA_ACTION = "com.ehsy.warehouse.action.BARCODE_DATA"
    private const val HONEYWELL_SCAN_ACTION = "com.honeywell.decode.intent.action.EDIT_DATA"
		private const val HONEYWELL_EDA_SCAN_ACTION = "com.honeywell.scan.broadcast"
    private const val NL_SCAN_ACTION = "nlscan.action.SCANNER_RESULT"
  }

  private var activity: Activity? = null
  private var eventChannel: EventChannel? = null
  private var eventSink: EventChannel.EventSink? = null

  private val scanReceiver = object : BroadcastReceiver() {
    override fun onReceive(context: Context?, intent: Intent?) {
      intent?.let {
        when (it.action) {
          XM_SCAN_ACTION, SHINIOW_SCAN_ACTION -> {
            eventSink?.success(it.getStringExtra("scannerdata"))
          }
          IDATA_SCAN_ACTION -> {
            eventSink?.success(it.getStringExtra("value"))
          }
          YBX_SCAN_ACTION -> {
            eventSink?.success(it.getStringExtra("barcode_string"))
          }
          PL_SCAN_ACTION -> {
            val barcode = it.getByteArrayExtra("barocode")
            val barcodeLen = it.getIntExtra("length", 0)
            barcode?.let { code ->
              val result = String(code, 0, barcodeLen)
              eventSink?.success(result)
            }
          }
          BARCODE_DATA_ACTION, HONEYWELL_SCAN_ACTION, HONEYWELL_EDA_SCAN_ACTION -> {
            eventSink?.success(it.getStringExtra("data"))
          }
					NL_SCAN_ACTION -> {
            eventSink?.success(it.getStringExtra("SCAN_BARCODE1"))
          }
          else -> {
            Log.i("PdaScannerPlugin", "NoSuchAction")
          }
        }
      }
    }
  }

  override fun onAttachedToEngine(binding: FlutterPlugin.FlutterPluginBinding) {
    eventChannel = EventChannel(binding.binaryMessenger, CHANNEL).apply {
      setStreamHandler(this@PdaScannerPlugin)
    }
  }

  override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
    eventChannel?.setStreamHandler(null)
    eventChannel = null
  }

  override fun onAttachedToActivity(binding: ActivityPluginBinding) {
    activity = binding.activity
    registerReceivers(binding.activity)
  }

  override fun onDetachedFromActivity() {
    activity?.unregisterReceiver(scanReceiver)
    activity = null
  }

  override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
    onAttachedToActivity(binding)
  }

  override fun onDetachedFromActivityForConfigChanges() {
    onDetachedFromActivity()
  }

  override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
    eventSink = events
  }

  override fun onCancel(arguments: Any?) {
    Log.i("PdaScannerPlugin", "PdaScannerPlugin:onCancel")
    eventSink = null
  }

  private fun registerReceivers(activity: Activity) {
    val filters = listOf(
      IntentFilter().apply { 
        addAction(XM_SCAN_ACTION)
        priority = Integer.MAX_VALUE 
      },
      IntentFilter().apply { 
        addAction(SHINIOW_SCAN_ACTION)
        priority = Integer.MAX_VALUE 
      },
      IntentFilter().apply { 
        addAction(IDATA_SCAN_ACTION)
        priority = Integer.MAX_VALUE 
      },
      IntentFilter().apply { 
        addAction(YBX_SCAN_ACTION)
        priority = Integer.MAX_VALUE 
      },
      IntentFilter().apply { 
        addAction(PL_SCAN_ACTION)
        priority = Integer.MAX_VALUE 
      },
      IntentFilter().apply { 
        addAction(BARCODE_DATA_ACTION)
        priority = Integer.MAX_VALUE 
      },
      IntentFilter().apply { 
        addAction(HONEYWELL_SCAN_ACTION)
        priority = Integer.MAX_VALUE 
      },
      IntentFilter().apply { 
        addAction(HONEYWELL_EDA_SCAN_ACTION)
        priority = Integer.MAX_VALUE 
      },
      IntentFilter().apply { 
        addAction(NL_SCAN_ACTION)
        priority = Integer.MAX_VALUE 
      }
    )

    filters.forEach { filter ->
      activity.registerReceiver(scanReceiver, filter)
    }
  }
}