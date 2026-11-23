# flutter_callkit_incoming: keep its classes so release shrinking does not
# rename the keys it reads (full-screen incoming-call ringing on Android).
-keep class com.hiennv.flutter_callkit_incoming.** { *; }
