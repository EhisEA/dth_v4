import com.android.build.gradle.AppExtension

val android = project.extensions.getByType(AppExtension::class.java)

android.apply {
    flavorDimensions("environment")

    productFlavors {
        create("dev") {
            dimension = "environment"
            applicationId = "com.dth.dth.dev"
            resValue(type = "string", name = "app_name", value = "Dth (Dev)")
        }
        create("prod") {
            dimension = "environment"
            applicationId = "com.dth.dth"
            resValue(type = "string", name = "app_name", value = "Dth")
        }
    }
}
