# Prevent removal of classes used by the SDK
-keep class com.itgsa.opensdk.** { *; }
-dontwarn com.itgsa.opensdk.**

# Prevent removal of Jackson databind dependencies
-keep class com.fasterxml.jackson.databind.** { *; }
-dontwarn com.fasterxml.jackson.databind.**

# Prevent removal of JavaBeans
-keep class java.beans.** { *; }
-dontwarn java.beans.**

# Prevent removal of DOM Bootstrap classes
-keep class org.w3c.dom.bootstrap.** { *; }
-dontwarn org.w3c.dom.bootstrap.**
