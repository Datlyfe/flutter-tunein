package com.example.music;

import android.os.Bundle;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.support.v7.graphics.Palette;

import android.media.MediaMetadataRetriever;
import android.renderscript.Sampler;

import io.flutter.app.FlutterActivity;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugins.GeneratedPluginRegistrant;
import com.mpatric.mp3agic.*;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

public class MainActivity extends FlutterActivity {
  private static final String CHANNEL = "android_app_retain";

  public static int getDominantColor(Bitmap bitmap) {
    Bitmap newBitmap = Bitmap.createScaledBitmap(bitmap, 1, 1, true);
    final int color = newBitmap.getPixel(0, 0);
    newBitmap.recycle();
    return color;

  }

  @Override
  protected void onCreate(Bundle savedInstanceState) {
    super.onCreate(savedInstanceState);
    GeneratedPluginRegistrant.registerWith(this);

    new MethodChannel(getFlutterView(), CHANNEL).setMethodCallHandler(new MethodChannel.MethodCallHandler() {
      @Override
      public void onMethodCall(MethodCall methodCall, MethodChannel.Result result) {
        // Map<String, Object> arguments = methodCall.arguments();
        if (methodCall.method.equals("sendToBackground")) {
          moveTaskToBack(true);
        }

        if (methodCall.method.equals("getColor")) {
          String path = methodCall.argument("path");

          Bitmap myBitmap = BitmapFactory.decodeFile(path);
          // int color = getDominantColor(myBitmap);
          // String text = methodCall.argument("path");
          // result.success(color);

          Palette.generateAsync(myBitmap, new Palette.PaletteAsyncListener() {
            int defaultColor = 0x000000;
            List<Integer> colors = new ArrayList<Integer>();

            public void onGenerated(Palette palette) {
              Palette.Swatch dominantSwatch = palette.getDominantSwatch();

              int backgroundColor = dominantSwatch.getRgb();
              int textColor = dominantSwatch.getBodyTextColor();
              int titleColor = dominantSwatch.getTitleTextColor();

              colors.add(backgroundColor);
              colors.add(titleColor);
              colors.add(textColor);

              result.success(colors);
            }
          });
        }

      }
    });

  }
}
