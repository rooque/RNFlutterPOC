package com.rnflutterdemo.flutterbridge;

import android.app.Activity;
import android.content.Intent;

import androidx.annotation.NonNull;

import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.facebook.react.bridge.ReactMethod;

import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.embedding.engine.FlutterEngineCache;
import io.flutter.embedding.engine.dart.DartExecutor;

public class FlutterBrigdeModule extends ReactContextBaseJavaModule {
    private static ReactApplicationContext reactContext;

    FlutterBrigdeModule(ReactApplicationContext context) {
        super(context);
        reactContext = context;
    }

    @NonNull
    @Override
    public String getName() {
        return "FlutterBrigde";
    }

    @ReactMethod
    public void show() {
        Activity activity = getCurrentActivity();
        if (activity != null) {
            Intent intent = FlutterActivity.withCachedEngine("my_engine_id").build(activity);
            activity.startActivity(intent);
        }
    }

    @ReactMethod
    public void init() {
        reactContext.getCurrentActivity().runOnUiThread(new Runnable() {
            @Override
            public void run() {
                // Instantiate a FlutterEngine.
                FlutterEngine flutterEngine = new FlutterEngine(reactContext.getBaseContext());

                // Start executing Dart code to pre-warm the FlutterEngine.
                flutterEngine.getDartExecutor().executeDartEntrypoint(
                        DartExecutor.DartEntrypoint.createDefault()
                );

                // Cache the FlutterEngine to be used by FlutterActivity.
                FlutterEngineCache
                        .getInstance()
                        .put("my_engine_id", flutterEngine);
            }
        });
    }
}
