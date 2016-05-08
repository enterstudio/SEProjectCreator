import de.richsource.gradle.plugins.gwt.GwtSuperDev;

apply plugin: 'java'
apply plugin: 'gwt'
apply plugin: 'jetty'

gwt {
    minHeapSize = "512M";
    maxHeapSize = "1024M";

    gwtVersion = '2.8.0-beta1'
    modules '${packageName}.${className}Gwt'
    devModules '${packageName}.${className}Gwt'

    src += files(project(':${className}Core').sourceSets.main.allJava.srcDirs)
}

javadoc {
    options.addStringOption("sourcepath", "")
}

task run(type: JettyRunWar) {
    dependsOn war
    webApp = war.archivePath
    daemon = true
}

task superDev(type: GwtSuperDev) {
    dependsOn run
    doFirst {
        gwt.modules = gwt.devModules
    }
}

war {
    from sourceSets.main.resources
    from zipTree(file("../libs/silenceengine-resources.jar"))
    from project(':${className}Core').sourceSets.main.resources

    rootSpec.exclude("**/*.class")
    rootSpec.exclude("WEB-INF")
}

dependencies {
    providedCompile files("../libs/silenceengine.jar")
    providedCompile files("../libs/silenceengine-sources.jar")
    providedCompile files("../libs/backend-gwt.jar")
    providedCompile project(':${className}Core')

    providedCompile 'com.goharsha:webgl4j:0.2.9-SNAPSHOT'
    providedCompile 'com.goharsha:gwt-al:0.1-SNAPSHOT'
    providedCompile 'com.goharsha:gwt-opentype:0.1-SNAPSHOT'
    providedCompile 'com.google.gwt:gwt-user:2.8.0-beta1'
    providedCompile 'com.google.gwt:gwt-servlet:2.8.0-beta1'
}
