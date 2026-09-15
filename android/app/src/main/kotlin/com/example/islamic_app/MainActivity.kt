package com.example.islamic_app


import android.os.Build
import android.os.Bundle
import android.view.WindowManager
import com.ryanheise.audioservice.AudioServiceActivity

class MainActivity: AudioServiceActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

        // الكود ده بيجبر شاشة الموبايل تنور وتتخطى القفل وقت الأذان
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O_MR1) {
            setShowWhenLocked(true)
            setTurnScreenOn(true)
        } else {
            window.addFlags(
                WindowManager.LayoutParams.FLAG_SHOW_WHEN_LOCKED or
                        WindowManager.LayoutParams.FLAG_TURN_SCREEN_ON
            )
        }
    }
}