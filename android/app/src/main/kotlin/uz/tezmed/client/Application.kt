package uz.client.tezmed

import android.app.Application
import com.yandex.mapkit.MapKitFactory

class MainApplication : Application() {
    override fun onCreate() {
        super.onCreate()
        
        MapKitFactory.setApiKey("f46b85e7-283f-4ee0-a95d-d5e511ac26ac")
        
        MapKitFactory.initialize(this)
    }
}